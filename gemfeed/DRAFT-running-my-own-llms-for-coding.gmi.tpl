# Running my own LLMs for coding: Hyperstack, vLLM and the pi coding agent

The `gt` calculator was built almost entirely with local LLMs running on rented Hyperstack VMs, and I ended that post with a promise: "I will write another blog post at some point about my setup and what I learned from self-hosting models on Hyperstack." This is that post.

=> ./2026-06-01-gt-calculator.gmi 2026-06-01 `gt` calculator - a calculator built with local LLMs

In this post I go through the setup, how the inference works under the hood (prefill, decode, KV cache, prefix caching), the numbers I see in practice, and where I stand now on buying hardware.

=> ./running-my-own-llms-for-coding/logo.svg The hypr logo

<< template::inline::toc

## Why rent instead of buy

The main motivation was a question I wanted to answer before spending money: should I buy hardware to run my own LLMs? A new RTX 5090 with 32 GB VRAM costs a few thousand dollars, and a 128 GB DGX Spark box starts at $3,999. Before putting either on my desk, I wanted to know what it feels like to have a 27B model (and the occasional 120B one) as a daily coding partner. So I rented instead: Hyperstack VMs with A100 80 GB GPUs, spun up when I need them, torn down when I don't.

=> https://www.hyperstack.cloud/ Hyperstack

A few months in, the setup has grown into a small toolchain I call `hypr`. One Ruby script manages the whole lifecycle (create the VM, open a WireGuard tunnel, start vLLM with the model of choice), and I can run two VMs at the same time, each with its own model and its own pi coding agent in a tmux pane. For example, Qwen3.8 27B works on one project in pane 0 while Gemma 4 31B works on another in pane 1, and when one of them gets stuck I hand the same problem to the other.

=> https://github.com/snonux/hypr hypr on GitHub
=> https://pi.dev Pi coding agent

## The setup at a glance

Everything starts on my laptop. `ruby hyperstack.rb --vm 1 create` (or `--vm both` for two VMs in parallel) provisions a Hyperstack VM (Ubuntu 24.04 with CUDA and Docker preinstalled, one A100 80 GB PCIe GPU), sets up a WireGuard tunnel to it, and starts the model in a vLLM Docker container. About ten minutes later the model is serving on an OpenAI-compatible API, reachable over the tunnel.

=> ./running-my-own-llms-for-coding/architecture.svg The setup: pi on the laptop, vLLM on two Hyperstack VMs, WireGuard in between

The WireGuard tunnel is the interesting bit. A single `wg1` interface on my laptop (Fedora Linux, by the way!) routes traffic to both VMs. The firewall on the Hyperstack VMs only lets in SSH and the WireGuard port, so the vLLM port (11434) is only reachable through the tunnel. There's no other authentication: no proxy, no load balancer, no API keys. The API isn't exposed to the internet at all, and the tunnel is the security boundary.

`hypr` is a Ruby script with a small TOML config per VM. The commands that matter:

* `create` / `delete` — provision or destroy a VM (WireGuard + vLLM included)
* `status` — VM, tunnel and model state
* `test` — end-to-end inference check over the tunnel
* `watch` — live dashboard: GPU, throughput, KV cache per VM
* `model switch <preset>` — hot-swap the model on a running VM

## What decides if this works

Before the walkthrough, a short glossary of the things that matter when you run LLMs yourself. The bigger topics get their own section below or come back later in the post:

* VRAM — the GPU's memory (unified memory on Apple silicon or a DGX Spark). Holds the weights plus the KV cache.
* KV cache — the model's working memory for everything in the context. Grows with context length and lives in VRAM.
* Memory bandwidth — decode is bandwidth-bound. "Fits" and "feels fast" are different questions.
* Token generation speed (decode tok/s) — the speed you feel while the agent "types".
* Prefill speed (prompt tok/s) — how fast the prompt is read in. Decides how long you wait for the first token.
* Parameter count vs quantization — bigger and less quantized is usually better, but costs VRAM. Newer small models can beat older big ones.
* MoE vs dense — MoE models only use a small part of their parameters per token. Faster, but not smaller. Dense models usually are a bit "smarter" but also slower.
* Context vs weights — every token of context costs VRAM the weights already claimed.
* LLM reasoning level — Makes the LLM "think harder" in exchange for more tokens.
* Tool-calling reliability — without working tool calls, you are back to copy-paste chat.
* Harness overhead — the system prompt, tool schemas and extensions eat context before you type a word.
* Runtime — plug-and-play (Ollama, LM Studio) vs knobs and throughput (vLLM). hypr picks the second.

The next section explains how inference works: VRAM, the KV cache, prefill, decode and the runtime. MoE, quantization and reasoning come with the models after that, and the harness topics (system prompt, tool calling) get their own section once pi enters the picture.

## How the inference works

This is the part I set out to learn, so here is the mental model that finally clicked.

### CUDA: the layer under everything

CUDA is NVIDIA's platform for running general-purpose code on a GPU. It has three parts: the driver that talks to the chip, the runtime and libraries on top of it, and a toolchain that compiles code into kernels, the small programs that run on the GPU.

=> ./running-my-own-llms-for-coding/cuda.svg How vLLM uses the GPU through CUDA: CPU launches kernels, the GPU's SMs stream weights from HBM

The split between CPU and GPU is the key to understanding it:

* The CPU (the host) decides what to run. vLLM schedules and batches requests and tokenizes text. PyTorch describes the model as Python code (every vLLM model is a PyTorch module, and the log shows it: `torch.compile took 29.95 s`), and then launches kernels on the GPU through the CUDA runtime.
* The GPU (the device) does the math. The A100 has 108 streaming multiprocessors (SMs). Each SM has CUDA cores, tensor cores for matrix math, and a bit of very fast on-chip memory. A kernel runs as thousands of threads spread over all SMs at once.
* Memory sits in between. The 80 GB of HBM2e on the card hold the weights and the KV cache. The SMs can read it at ~1.9 TB/s, which is fast, but still much slower than the SMs can compute.

Every prefill and decode step is a batch of kernels launched on the A100. The vLLM log on my VM shows which ones it picked: FlashAttention 2 for attention, Marlin for the FP8 weights, FlashInfer for sampling the next token, and Triton kernels generated by torch.compile for the rest. That one surprised me: the A100 has no native FP8 support, so vLLM logs "Your GPU does not have native support for FP8 computation" and uses Marlin to unpack the 8-bit weights on the fly. The model still gets the memory savings of FP8, just not FP8 math.

The diagram also shows why decode is memory-bound. For every token, all 28.9 GiB of weights have to stream from HBM through the SMs once. At ~1.9 TB/s, that's about 16 ms per step, so a single conversation can't get more than ~60 tokens per second on this card, no matter how fast the SMs are. I measure ~40. When three conversations are batched, the same weight read produces three tokens, and that's why the total throughput goes up with more agents.

You can see the software layers in the VM image name: `Ubuntu Server 24.04 LTS R570 CUDA 12.8 with Docker`. That's the OS, the GPU driver (570.195.03 on my VM), the CUDA 12.8 stack, and Docker. The vLLM container sees the GPU through `--gpus all`. Docker's NVIDIA toolkit injects the driver and the device into the container, and the model's math runs entirely on the GPU.

### What vLLM is

vLLM is an open-source inference engine: the program that takes a model's weights and turns prompts into tokens at high throughput. Ollama does the same job packaged for convenience: one command pulls a quantized model and it's serving. vLLM is the lower-level engine you run yourself, in Docker, with flags, and tune per model. Ollama optimizes for "make it run"; vLLM optimizes for throughput, context length, and batching, and exposes the knobs (`--max-model-len`, `--gpu-memory-utilization`, `--enable-prefix-caching`) so you can spend the VRAM the way your workload needs it.

An LLM request has two phases:

* Prefill — the model reads the entire prompt and computes attention over all of it in one shot. All prompt tokens can be processed in parallel, so it's compute-bound, and that's where big GPUs shine.
* Decode — generating the answer, one token at a time. Every new token depends on the previous one, so this is sequential and memory-bandwidth-bound. This is the phase you are waiting for while the agent "types".

=> ./running-my-own-llms-for-coding/prefill-decode.svg One request: prefill, then decode

The two phases show up as very different numbers. Prefill runs at thousands of tokens per second, because the entire prompt is one big parallel job, and a datacenter GPU like the A100 is exactly the kind of hardware that eats that for breakfast. Decode runs at tens of tokens per second, because every output token is its own step: the model re-reads the weights from VRAM, produces one token, and starts over. That's roughly two orders of magnitude, and no setup can fix it: it's inherent to generating one token at a time. When you "feel" speed in an agent session, you are feeling decode tok/s. Prefill tok/s mostly decides how long the first token takes after you hit enter.

The key data structure is the KV cache. To generate the next token, the model has to attend to every previous token, and without a cache it would have to reprocess the whole context for every single new token. So the key and value tensors for all previous tokens are stored in GPU memory and reused. Note that the KV cache isn't the context window: the window is the maximum length, the KV cache is the memory the tokens in it take up. It grows linearly with context length, and it's the reason "how long a context can I have" is really a VRAM question:

```
VRAM = model weights + KV cache pool + headroom

--gpu-memory-utilization 0.92   → vLLM may use 92% of the 80 GB
--max-model-len 262144          → max context: 262,144 tokens (the "262K")
```

At startup, vLLM loads the weights, then allocates the rest of the allowed VRAM as a pool of KV cache blocks. That is why `nvidia-smi` shows ~72–75 GiB "used" even when nothing is running. The pool is preallocated, not busy.

=> ./running-my-own-llms-for-coding/vram-budget.svg How three presets split the A100's 80 GB between weights and KV cache

### Prefix caching: the big one for agentic coding

`--enable-prefix-caching` keeps those KV blocks around between requests instead of freeing them. If a new request shares a prefix with a previous one (same system prompt, same conversation history), the shared part is not prefilled again. The tokens are served from cache.

For a coding agent this is huge. Every turn of a coding agent session resends the system prompt plus the entire conversation. Without prefix caching, that whole context is re-prefilled on every single turn. With it, most of the prompt arrives already computed. My current sessions sit at an 80–97% hit rate (numbers below).

=> ./running-my-own-llms-for-coding/prefix-cache.svg Prefix caching over four agent turns

This is also the main reason I moved from Ollama to vLLM:

* Prefix caching: vLLM caches in blocks and keeps the blocks of many conversations around at once, so everything up to the first changed block is reused, even with several agents taking turns.
* Prefill kernels: vLLM uses FlashAttention v2, ~1.5–2× faster on long prompts.
* Chunked prefill: vLLM interleaves prefill chunks with decode, so a huge prompt doesn't stall the conversations that are already decoding.
* Quant kernels: vLLM has Marlin kernels for AWQ 4-bit models, which several of my presets (more on those below) rely on.

Ollama is fine for quick experiments. But for an agent that sends 100K+ token contexts dozens of times a day, recomputing the whole prompt every turn is painful, while computing only the ~15% that changed is fine.

To be fair, Ollama is still nicer if you just want a model serving in two minutes. vLLM + hypr wins on throughput and knobs and loses on "download and go".

### Speculative decoding (not set up yet)

There's one more decode trick I haven't set up yet, but it fits right here: speculative decoding. The idea is to guess the next few tokens cheaply and let the big model check all the guesses in one go.

=> ./running-my-own-llms-for-coding/speculative.svg Speculative decoding: a cheap guess of 4 tokens, verified by the big model in one pass

How it works:

* A cheap predictor guesses the next few tokens. That's either a small draft model of the same family, or extra prediction layers built into the big model itself (multi-token prediction, MTP).
* The big model then runs one pass over all the guesses at once, like a tiny prefill. For every position, it computes the token it would have picked itself.
* The guesses are kept up to the first wrong one. At that position, the big model's own token is used instead. So the output is the same as without the trick, it just arrives faster.

Why is that faster? Because decode is memory-bound (see the CUDA section above). One pass reads all 28.9 GiB of weights from VRAM, no matter if it checks one token or four, and the SMs are mostly idle while they wait for the memory anyway. So checking extra tokens is nearly free. If two or three guesses get accepted on average, one pass produces three or four tokens instead of one. Code is a good fit, because a lot of it is predictable: boilerplate, closing brackets, identifiers that were just used.

It helps less when several agents are already batched, since then the GPU already does more work per weight read. Wrong guesses waste a bit of compute, and the predictor needs some VRAM, which comes out of the KV cache pool.

Would it work in my setup? It's not enabled: the vLLM log on my VM says `speculative_config=None`. But Qwen3.8 ships with an MTP layer built in (`mtp_num_hidden_layers: 1` in its config, with the weights in `mtp.safetensors`), and vLLM supports MTP for this model architecture. So it should be one extra line in the hypr preset, something like `--speculative-config '{"method": "mtp", "num_speculative_tokens": 2}'`. I haven't tested it yet, so I don't know yet how it plays with the FP8 Marlin kernels on the A100, how much KV cache it costs, and whether it still helps with three agents in parallel. That's the next experiment.

## The VMs and the models

Both VMs are `n3-A100x1` flavors: one A100 80 GB PCIe, 28 vCPUs, 120 GB RAM, in a Canadian region. When the A100 flavor is sold out, the config flips to `n3-H100x1` (80 GB as well, faster, but also pricier), and everything else stays the same.

The default model on VM1 is `Qwen/Qwen3.8-27B-FP8`, a dense 27B model with a native 262K context window, FP8-quantized. As of writing, that is also my main model in this setup, and every number measured in this post is measured on it. VM2 runs `Gemma 4 31B` (AWQ 4-bit) by default, so I can work on two projects in parallel with two different models and compare how they behave.

Each VM's TOML config defines named presets, so switching models does not mean reprovisioning:

* `qwen38-27b` — Qwen3.8 27B FP8 (default), ~29 GiB weights, 262K context
* `qwen36-27b` — Qwen3.6 27B FP8, ~29 GiB weights, 262K context
* `gemma4-31b` — Gemma 4 31B IT (AWQ-4bit), ~19 GB VRAM, 32K context
* `nemotron-super` — Nemotron-3-Super 120B (Mamba+MoE, 12B active), ~74 GiB VRAM, 32K context
* `qwen36-35b-a3b` — Qwen3.6-35B-A3B MoE (AWQ, 3B active), ~18 GB VRAM, 65K context; runs with a quantized KV cache (`turboquant_k8v4`) and chunked prefill disabled
* `qwen3-coder-30b` — Qwen3-Coder-30B-A3B (MoE, AWQ), ~18 GB VRAM, 65K context
* `qwen25-coder-32b` — Qwen2.5-Coder-32B (AWQ), ~18 GB VRAM, 32K context
* `deepseek-r1-32b` — DeepSeek-R1-Distill-Qwen-32B (AWQ), ~18 GB VRAM, 32K context
* `qwen3-32b` — Qwen3-32B (AWQ), ~18 GB VRAM, 32K context
* `devstral` — Devstral-Small-2507 (AWQ-4bit), ~15 GB VRAM, 32K context

`ruby hyperstack.rb --vm 1 model switch nemotron-super` stops the running container, starts a new one with the preset's flags, and waits for readiness. The weights are cached on the VM's ephemeral NVMe disk after the first download, but a switch still takes minutes (see below).

Two details:

* Qwen3.8 is brand new, so VM1 runs the `vllm/vllm-openai:nightly` image until stable vLLM ships support for the architecture.
* The big 120B MoE (Nemotron-3-Super) has to have its context capped at 32K, prefix caching disabled and `--gpu-memory-utilization` raised to 0.98 to fit on a single A100, since the weights alone take most of the 80 GB. That tension between model size and context length is the core of VRAM budgeting (see the VRAM chart above).

### Why starting a model takes minutes

Loading a model onto the GPU sounds like "copy 29 GiB from disk to VRAM". That part is actually fast. I restarted the vLLM container on a fresh VM and timed every phase from its log:

=> ./running-my-own-llms-for-coding/startup-timeline.svg Where the startup time goes: fresh VM vs container restart

On a fresh VM, `hypr create` took about 10 minutes in total:

* VM boot — ~1.5 minutes until Hyperstack hands over a running VM.
* Bootstrap — ~3.5 minutes for packages, WireGuard, the firewall and pulling the 32 GB vLLM Docker image.
* vLLM start — ~1 minute for Python, the API server and the engine to come up.
* Weights — ~1 minute to download 29 GiB from Hugging Face, then 5 seconds to load them into VRAM.
* torch.compile — ~40 seconds to compile the model's GPU kernels for this GPU.
* Profiling run — ~1 minute for a dummy pass at the maximum batch size.
* CUDA graphs and KV cache — ~1.3 minutes to allocate the KV cache pool and capture CUDA graphs.

The last three are what "loading everything into CUDA" really means. torch.compile turns the model's Python code into fused GPU kernels. The profiling run measures the peak memory the model needs, so vLLM knows how much VRAM is left for the KV cache (40.9 GiB here). And the CUDA graph capture records the exact sequence of GPU kernel launches for each batch size (86 graphs here), so that later every decode step can replay a graph instead of launching hundreds of small kernels from Python one by one. That's a big part of why decode is fast, but it costs time on every start.

A restart of the same container is faster: about 2 minutes. The weights are already on disk, and the compiled kernels come from vLLM's on-disk compile cache (0.55 seconds instead of 30). But the CUDA graphs are captured again on every start (~1 minute), and the Python and API startup doesn't get faster either.

That's why switching models ad hoc is painful. `model switch` takes at least 2 minutes for a model that was already used on this VM, and more for a new one (download plus a cold compile). On top of that, every running agent session loses its prefix cache and has to prefill its whole context again. So instead of switching back and forth, I run two VMs with two different models loaded. Switching between them is then just picking the other provider in pi (`Ctrl+L`), and it's instant.

### MoE vs dense, and quantization

A dense model uses all of its parameters for every token. A mixture-of-experts (MoE) model is split into many "experts", and a small router picks only a few of them per token. So only a small active set does the work, e.g. 3B active out of 35B total.

=> ./running-my-own-llms-for-coding/moe-vs-dense.svg Dense vs mixture-of-experts: fewer weights read per token, same memory

That makes decode much faster than on a dense model of the same total size, because far fewer weights are read per token. The catch: all experts still have to sit in VRAM, since the router can pick any of them for the next token. You save compute, not memory.

Several presets are MoEs (Nemotron-3-Super, `qwen36-35b-a3b`, `qwen3-coder-30b`). Only the active parameters do the work per token, which is why Nemotron can be 120B total with 12B active and still decode at a usable speed. But remember, all 120B still have to fit into VRAM, and that's why it barely fits once the context is capped. The `qwen36-35b-a3b` preset only fits into ~18 GB because it's also 4-bit quantized.

Quantization is how the rest of the list fits. FP8 stores each weight in 8 bits (a 27B model is ~27 GB of weights, plus some overhead). AWQ-4bit stores each weight in 4 bits and trades some quality for footprint and speed. FP8 on the 27B is my daily driver: good quality, 28.9 GiB of weights, and 40.9 GiB left for the KV cache. vLLM reports that as 657,281 tokens, enough for about 2.5 full 262K contexts at the same time. I haven't tried QAT (quantization-aware training, where the model is trained to cope with the lower precision) yet.

### Why this is the daily driver

The official model card benchmarks Qwen3.8-27B against its predecessor, Qwen's own closed-weight Qwen3.7-Plus, a 30B-class competitor, and the frontier Opus 4.6 Max. Here are the coding-relevant rows as a chart:

=> ./running-my-own-llms-for-coding/benchmarks.svg Qwen3.8-27B vs Qwen3.6-27B, Qwen3.7-Plus, Muse Glimmer-30B and Opus 4.6 Max (vendor-reported)

It beats its direct predecessor on every row, and the rows that match how I use it are the interesting ones: on SWE-bench Pro (agentic coding) the 27B dense model scores 61.7, ahead of Opus 4.6 Max's 53.4 and Muse Glimmer's 51.2; on terminal coding it runs 73.0 to Qwen3.6's 63.4; on competitive coding (90.3) it even edges Opus (88.8). That's a model I can run on a single rented A100 that beats models I can only rent per-token, on the benchmarks that resemble my actual workload.

But benchmarks are one thing, and real workloads are another. Take all of them with a grain of salt. These are vendor-reported numbers from the model card, a couple of the benchmarks are Qwen's own, and the Opus 4.6 Max SWE-bench Pro figure is the one Anthropic reported. I take the direction, not the exact decimals. Simon Willison ran the model on a DGX Spark and an M5 Max MacBook the week it shipped, and his verdict matches mine: an excellent model that defaults to wildly overthinking, because its reasoning effort defaults to `xhigh`:

=> https://simonwillison.net/2026/Aug/16/qwen-38-27b/ Qwen 3.8 27B is excellent, but it defaults to wildly overthinking things (Simon Willison)

### Reasoning: what it is and the effort levels

Reasoning models "think" before they answer. They write out their thoughts first, usually between `<think>` and `</think>` tags, and only then produce the answer or tool call. They were trained (mostly with reinforcement learning) to work through a problem step by step in that scratchpad, and for tricky tasks the answers get noticeably better.

For the inference engine, thinking tokens are completely normal output tokens. They're decoded one by one at decode speed, and they fill the KV cache like everything else. vLLM's reasoning parser (`--reasoning-parser qwen3` in my presets) only splits them from the answer, so pi can show them separately. They're the greyed-out text in the screenshots.

=> ./running-my-own-llms-for-coding/reasoning.svg Reasoning effort: more effort means more thinking tokens before the answer

Many models offer reasoning effort levels: off, low, medium, high, and sometimes xhigh. The model was trained to think shorter or longer depending on the level. How the level reaches the model depends on the model and the API:

* A chat template flag — Qwen's `enable_thinking` switches thinking on or off.
* A line in the system prompt — e.g. `Reasoning: high` for OpenAI's open-weight gpt-oss models.
* An API parameter — `reasoning_effort` in OpenAI-style APIs, which the provider translates for the model.

And not every model supports it:

* Non-reasoning models never think, and the level does nothing. On my preset list, that's Qwen2.5-Coder, Qwen3-Coder and Devstral.
* Always-on models, like DeepSeek-R1-Distill, always think. You can't switch it off.
* Hybrid models, like Qwen3-32B, Qwen3.6 and Qwen3.8, can switch thinking on and off. Qwen3.8 also has effort levels and defaults to `xhigh`.

Here's a catch I only found while writing this post. pi shows "medium" as the thinking level in its footer. But for Qwen models, pi only sends `enable_thinking: true` or `false` to vLLM. So low, medium and high all just mean "on", and Qwen3.8 then thinks at its own default, `xhigh`. That explains a lot of the overthinking Simon Willison describes. pi also asks the chat template to keep the thinking of earlier turns in the history (`preserve_thinking`), so the thinking keeps taking up context later, too. And for Gemma and Nemotron, my pi config marks the models as non-reasoning, so pi's level does nothing there at all. For Nemotron, that's a config gap on my side: hypr runs it with a reasoning parser, so it thinks anyway, pi just can't turn it off.

I haven't done a clean on-vs-off comparison on my own tasks yet, so I won't pretend I have numbers. But the math is simple: at ~40 tokens per second, 2,000 thinking tokens are 50 seconds before the first word of the answer. For agent turns where I already know what the change should look like, that's mostly wasted time and context. Worth a dedicated experiment later. For now, I live with the default and interrupt the model when it spirals.

## Inside the VM

Once the tunnel is up, the VM is just another machine on your network, and I mostly work on it over its WireGuard address rather than the public IP:

```fish
$ ssh ubuntu@192.168.3.1
ubuntu@hyperstack1:~$ hostname
hyperstack1
```

The entire "AI service" from the inside is one Docker container:

```
$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED       STATUS       PORTS     NAMES
aa1845729f93   vllm/vllm-openai:nightly   "vllm serve --model …"   2 hours ago   Up 2 hours             vllm_qwen38_27b
```

The interesting part of the container's log is the `Engine 0` line vLLM emits every ten seconds, the same line the `watch` dashboard parses. This snapshot is from later in the day than the numbers further down:

```
$ docker logs --tail 4 vllm_qwen38_27b 2>&1 | grep "Engine 0"
(APIServer pid=1) INFO 09-13 08:56:54 [loggers.py:311] Engine 000: Avg prompt
throughput: 0.0 tokens/s, Avg generation throughput: 53.6 tokens/s, Running:
2 reqs, Waiting: 0 reqs, GPU KV cache usage: 59.3%, Prefix cache hit rate: 96.9%
(APIServer pid=1) INFO 09-13 08:57:14 [loggers.py:311] Engine 000: Avg prompt
throughput: 0.0 tokens/s, Avg generation throughput: 48.3 tokens/s, Running:
1 reqs, Waiting: 0 reqs, GPU KV cache usage: 33.3%, Prefix cache hit rate: 96.9%
```

Follow it live with `docker logs -f vllm_qwen38_27b 2>&1 | grep "Engine 0"`, or watch the hardware side with `nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,power.draw --format=csv -l 5`.

## The harness: pi

So far, everything was about the model side. Now to the other half, the coding agent I actually type into.

### LLM vs harness

I say "the model edited my file" all the time, but that's not really what happens. Two different programs are involved:

* The LLM — the model weights, served by vLLM on the VM. Text goes in, text comes out. It has no memory between requests, can't see my files and can't run anything.
* The harness — pi, running on my laptop. It keeps the conversation, builds the system prompt, offers tools to the model, runs the tools the model asks for, edits the files, and shows it all in the terminal.

Claude Code, Codex, OpenCode and Cursor are harnesses, too. They usually come bundled with their vendor's model, which blurs the line. With a self-hosted setup the line is very visible: the model is on a VM in Canada, the harness is on my laptop, and the only thing between them is HTTP over WireGuard.

So the model decides what to do, and the harness does it. That's why I can swap the model under pi with one keystroke without changing anything else. It's also why the same model can feel smart in one harness and dumb in another. The harness decides what the model gets to see, and that has a huge effect on how good "the LLM" seems. More on that once the system prompt, tools and skills are explained.

### How pi talks to vLLM

Pi speaks the OpenAI chat completions API, and vLLM serves exactly that on `:11434`, so pi points straight at the VM over the tunnel, with no translation proxy in between.

The repo ships a `pi/` directory that I symlink to `~/.pi`. It defines providers in `models.json`, one per VM, plus a single-VM variant:

* `hyperstack1` → `http://hyperstack1.wg1:11434/v1` — Qwen3.8 27B FP8
* `hyperstack2` → `http://hyperstack2.wg1:11434/v1` — Gemma 4 31B AWQ
* `hyperstack` → `http://hyperstack.wg1:11434/v1` — single-VM variant

Every preset from the TOML configs is registered under its provider, so after a `model switch` I can just tell pi to use the new model ID, or hit `Ctrl+L` in the TUI to switch models mid-session without restarting.

Fish abbreviations keep the day-to-day short:

```fish
abbr pi-hyperstack-coder  pi --model hyperstack1/Qwen/Qwen3.8-27B-FP8
abbr pi-hyperstack-gemma4 pi --model hyperstack2/cyankiwi/gemma-4-31B-it-AWQ-4bit
```

My standard setup is a tmux session with one pi per pane: `pi-coder` on Qwen3.8 in pane 0, `pi-gemma4` in pane 1, each working on a different project against its own VM. When one model gets stuck on a task, I hand the same problem to the other pane and compare.

Here is what a session looks like in practice. I asked Qwen3.8 on VM1 to add a `version` command to the REPL of `gt`, and then to include the Go runtime version in its output. The screenshot shows the Go diff for the tests, followed by the test run. The footer shows the model and how much of the 262K context the session has used so far:

=> ./running-my-own-llms-for-coding/pi-go-edit.png pi with Qwen3.8 27B editing Go code in the gt project, followed by the test run

And one from an earlier session: diff on top, the model's reasoning in the middle, shell output at the bottom:

=> ./running-my-own-llms-for-coding/pi-coding-agent.png pi coding agent mid-task: diff, reasoning, and shell in one TUI

### The system prompt and harness overhead

Every harness puts a system prompt in front of every conversation: a hidden first message that tells the model who it is (a coding agent), how to behave (be concise, ask before destroying things, edit files with the edit tool and not with `sed`), which tools it has, and which project rules apply.

Here's what that looks like in pi. This is the start of its built-in system prompt, trimmed a little:

```
You are an expert coding assistant operating inside pi, a coding agent
harness. You help users by reading files, executing commands, editing
code, and writing new files.

Available tools:
- read: Read file contents
- bash: Execute bash commands (ls, grep, find, etc.)
- edit: Make precise file edits with exact text replacement, including
  multiple disjoint edits in one call
- write: Create or overwrite files

Guidelines:
- Use read to examine files instead of cat or sed.
- Use edit for precise changes (edits[].oldText must match exactly)
- Use write only for new files or complete rewrites.
- Be concise in your responses
- Show file paths clearly when working with files
```

After that, pi appends the project context (the content of any `AGENTS.md` or `CLAUDE.md` in the project), then the list of skills, and at the very end the current date and working directory:

```
<project_context>
Project-specific instructions and guidelines:
<project_instructions path="/home/paul/git/hypr/AGENTS.md">
...
</project_instructions>
</project_context>

The following skills provide specialized instructions for specific tasks.
Use the read tool to load a skill's file when the task matches its description.

<available_skills>
  <skill>
    <name>blog-writing-style</name>
    <description>De-LLM blog posts to sound authentically human. ...</description>
    <location>/home/paul/.pi/skills/blog-writing-style/SKILL.md</location>
  </skill>
  ...
</available_skills>

Current date: 2026-09-30
Current working directory: /home/paul/git/hypr
```

The order is not random. Everything that never changes comes first, and the parts that change (the date, the directory) come last. That way the prefix cache can reuse as much of the prompt as possible.

You never type it, but it's resent with every request and takes up KV cache like everything else. So do all the tool definitions (bash, read, edit, `web_search`, ...), skill descriptions (more on skills below), and project instructions such as an `AGENTS.md`. With dozens of tools, that's thousands of tokens before you've typed a word. The good news: all of that is identical on every turn, so it's the first thing prefix caching serves from cache.

### How tool calling works

The model doesn't run anything itself. The harness sends it a list of tool schemas (name, description, JSON arguments) along with the prompt. When the model wants to act, it outputs a structured call such as `read_file {"path": "main.go"}` instead of prose. The harness runs the tool, appends the result to the conversation, and asks the model again. That repeats until the task is done.

That loop is what makes an agent an agent. It falls apart when the model emits broken JSON or picks the wrong tool.

=> ./running-my-own-llms-for-coding/agent-loop.svg One agent turn: the tool-calling loop between pi and vLLM

### Tool calling on the wire

So what does this look like on the wire? Since vLLM speaks the OpenAI chat completions API, the whole agent loop is ordinary HTTP. Here's one turn, trimmed down. First, the harness (pi) sends the conversation plus the tool schemas:

```
POST http://hyperstack1.wg1:11434/v1/chat/completions
{
  "model": "Qwen/Qwen3.8-27B-FP8",
  "messages": [
    {"role": "system", "content": "You are a coding agent. Use the tools..."},
    {"role": "user",   "content": "What does main.go do?"}
  ],
  "tools": [{
    "type": "function",
    "function": {
      "name": "read_file",
      "description": "Read a file from the project",
      "parameters": {
        "type": "object",
        "properties": {"path": {"type": "string"}},
        "required": ["path"]
      }
    }
  }]
}
```

The model doesn't answer the question yet. It answers with a tool call instead of text. This is the real (trimmed) response from Qwen3.8 on VM1:

```
{
  "role": "assistant",
  "content": null,
  "tool_calls": [{
    "id": "chatcmpl-tool-996eae953d7c06fa",
    "type": "function",
    "function": {"name": "read_file", "arguments": "{\"path\": \"main.go\"}"}
  }]
}
```

Note that `arguments` is a JSON string the model generated token by token. If it forgets a quote or a brace, the call is broken. That's exactly what the `nemotron-tool-repair` extension (further down) patches. The harness validates the arguments, runs the tool locally, and sends everything back with the result appended:

```
"messages": [
  {"role": "system",    "content": "You are a coding agent. Use the tools..."},
  {"role": "user",      "content": "What does main.go do?"},
  {"role": "assistant", "tool_calls": [{"id": "chatcmpl-tool-996e...", ... "read_file" ...}]},
  {"role": "tool",      "tool_call_id": "chatcmpl-tool-996e...", "content": "package main\n\nfunc main() {..."}
]
```

By the way, vLLM reported 292 prompt tokens for that first request, with just one short system prompt and one tool. pi's real system prompt with all its tools is a lot bigger.

Now the model has the file contents in its context and can answer in plain text (or request another tool call, and the loop goes on). Two things I found interesting here. The model only ever sees text going in and text coming out, so "calling a tool" is just a special output format it was trained to produce. And every round trip resends the whole history, including all tool results, so the context (and the KV cache) grows with every step. That is why agentic work is so prefix-cache-heavy.

One server-side detail: the model emits its tool calls in its own raw format (Qwen uses XML-ish tags, others use JSON). vLLM only turns that into the structured `tool_calls` field if it runs with `--enable-auto-tool-choice --tool-call-parser <name>`, with the parser matching the model family. hypr sets these per preset; with the wrong parser you get the raw text back and the agent stalls.

### Skills, commands and MCP servers

Most harnesses (pi, Claude Code, Codex, OpenCode) know two kinds of reusable prompts, and it took me a while to get the difference:

* Commands — prompt templates you trigger yourself, like `/handoff` or `/plan`. They cost nothing until you type them.
* Skills — a folder with a `SKILL.md` (name, description, instructions, maybe scripts). The model triggers them itself.

For skills to work, the harness puts the name and description of every skill into the system prompt. So a command is "I decide", a skill is "the model decides". The harness never loads a whole skill up front. It works in levels, and each level is only loaded when it's needed:

* Level 1 — the name and description of every skill. Always in the system prompt.
* Level 2 — the skill's `SKILL.md`. The model reads it with a normal file read once a task matches.
* Level 3 — files the `SKILL.md` points to, like reference docs or scripts. Only read if the instructions for the task at hand need them.

=> ./running-my-own-llms-for-coding/skill-loading.svg Progressive skill loading: descriptions always, SKILL.md on a match, references only when needed

And yes, that changes how much context gets used. Level 1 costs context on every single request, even for skills you never use. Levels 2 and 3 cost nothing until they're loaded. But once the model has read a `SKILL.md` or a reference file, it's a tool result in the conversation, and it stays in the context (and the KV cache) for the rest of the session, until a compaction or a `/handoff` throws it out. My blog-writing-style skill is a good example: its `SKILL.md` is ~2.3K tokens, and the one reference file a style fix usually needs is another ~1.2K. The other three reference files (~11K tokens) stay on disk unless a task asks for them. Loading everything up front would cost ~14K tokens, which is almost half of a 32K preset.

I have 47 skills and 21 commands in my pi setup. The skill descriptions alone are ~17 KB of text, roughly 4K tokens in every request. On the 262K daily driver, that's fine. On a 32K preset, it's an eighth of the context gone before I've typed a word.

The bigger downside of too many skills isn't even the tokens, though. The model has to pick the right skill from the list, and with many similar descriptions, it picks the wrong one or none at all. Big frontier models handle that pretty well. Smaller self-hosted models get confused much more easily. So fewer, clearly distinct skills work better, especially with local models.

MCP (Model Context Protocol) servers are a third way to extend a harness, and they build directly on the tool calling from above. An MCP server is a separate process that offers tools (and other things) to the harness over a standard protocol, e.g. for a database, a ticket system or a browser. The harness adds its tool schemas to the tool list, so for the model it's just more tools, with the same context cost. A single MCP server can bring dozens of tool schemas. pi deliberately ships without MCP support (its author suggests CLI tools plus skills instead), and I haven't added it, so MCP is out of scope for this post.

=> https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/ What if you don't need MCP? (Mario Zechner)

### Why the harness makes the model look smart (or dumb)

With the system prompt, tools and skills explained, it's easier to see why the harness matters so much. The model only knows what's in its context, and the harness decides what goes in there. Here is what makes the difference:

* Context selection — which files, logs and search results the harness feeds in. The model can't fix code it has never seen.
* System prompt and tool descriptions — clear instructions and well-named tools mean fewer wrong tool calls.
* Tool design — a precise "replace this exact snippet" edit tool is much easier for a model than rewriting a whole file.
* Feedback loops — running tests, `go vet` or the compiler and feeding the errors back lets the model fix its own mistakes.
* Context hygiene — compaction, `/handoff` and sub-agents keep the context short, and models get worse as the context fills up.
* Tolerance for quirks — the right chat template, tool-call parser and small repairs (like `nemotron-tool-repair`) keep one broken call from derailing a session.
* Settings — reasoning effort, temperature and the context limit are configured on the harness or provider side, not in the weights.

The screenshot above is a good example. Qwen3.8 didn't just write the `version` command. It looked at how the other builtins are registered, added a matching help entry, and ran `go vet` and the tests before saying it was done. The model did the thinking, but it could only do that because pi gave it file reading, editing and a shell, and fed the test output back into the context.

This also matters for benchmarks. Scores like SWE-bench are measured with a specific agent setup around the model. Put the same weights into a different harness, and you get different results, sometimes a lot better or worse. So when a self-hosted model disappoints, it's worth checking the harness side (tools, context, parser, settings) before blaming the weights.

### The extensions

Pi ships deliberately minimal: no permission popups, no plan mode, no built-in sub-agents. The `hypr` repo bundles a set of TypeScript extensions that fill in the gaps. The ones I use daily:

* `web-search` — `web_search` and `web_fetch` tools backed by DuckDuckGo (no API key), so the agent looks things up instead of guessing from training data.
* `inline-bash` — `!{cmd}` in a prompt expands the command's output before it reaches the model; that is how `git status`, logs, and `nvidia-smi` output end up inside a question.
* `ask-mode` — `/ask` flips the session into a read-only investigation mode: understand the codebase and read logs without the agent touching a single file. Before I let a model near code I don't fully know, this is the first call: `/ask why does the tunnel setup regenerate keys on the second run?`
* `loop-scheduler` — `/loop` re-sends a prompt on an interval and `/watch` fires when the agent goes idle or a response contains a substring. The two forms I actually use: `/loop 10m check the VM status and warn me if KV cache usage is above 80%` for the periodic check, and the reactive `/watch contains ERROR => summarize the latest error and propose a fix`. That is how I babysit long builds and flaky services.
* `handoff` — `/handoff <goal>` compacts the session into a self-contained prompt for a fresh one, so a long-lived agent does not drown in its own history.
* `fresh-subagent` — the `subagent` tool and `/subagent` command run a self-contained task in a clean `pi` process with its own log file, while the main session stays focused: `/subagent review the last commit and list the risks` gives me the verdict without the digging.
* `btw` — a mid-task question that must not derail the context: `/btw which file owns the SSH host key bootstrap logic?` The answer appears in a temporary overlay and stays out of the session history.
* `agent-plan-mode` — `/plan` separates planning from execution: a read-only planning mode, a numbered plan, then the plan converted into real tasks before anything gets built. That is how the multi-step work in this repo stays on rails.
* `modal-editor` — an in-TUI modal editor for composing long prompts without fighting the line editor.
* `session-name` — labels a session with something more useful than the first prompt line.

The long tail is smaller: `nemotron-tool-repair` fixes the malformed tool calls the Nemotron models occasionally emit, and `prompt-history` quietly records the last 500 prompts.

For the record: `handoff`, `inline-bash`, `session-name`, and `reload-runtime` are upstream pi examples installed locally; the rest are my own.

### What the extensions cost

The same trade-off as with skills applies: every tool an extension adds lands in the system prompt. I haven't measured the exact token bill of the full extension set, but it isn't free. On the 27B FP8 daily driver the full set is fine. On the smaller AWQ presets with 32K context, I'd start with fewer tools and add them when needed, since fewer tools also means fewer chances for a small model to pick the wrong one or mangle the arguments. That's a hypothesis, though. I haven't measured it.

### Tool calling in practice

I haven't compared tool-call reliability systematically across the preset list, so no failure-rate table from me. What I know from daily use: the Nemotron models occasionally emit malformed tool calls, which is why `nemotron-tool-repair` exists. It patches the broken calls so the session continues instead of stalling.

## The numbers: tokens per second and friends

All measured on VM1 (A100 80 GB PCIe, `Qwen3.8-27B-FP8`, 262K context) during a normal work morning:

```
Engine 000: Avg prompt throughput: 253.8 tokens/s, Avg generation
throughput: 35.9 tokens/s, Running: 1 reqs, Waiting: 0 reqs,
GPU KV cache usage: 5.0%, Prefix cache hit rate: 81.1%
```

That is vLLM's engine log line, emitted every ten seconds. `ruby hyperstack.rb watch` parses it (plus `nvidia-smi`) into a live dashboard, refreshed every two seconds. It's a colored TUI, so here's a screenshot:

=> ./running-my-own-llms-for-coding/watch-dashboard.png The hypr watch dashboard during a decode burst

What the rows mean:

* Title bar — current time, how to quit, and the refresh interval.
* `hyperstack-vm1` line — the VM name, its WireGuard hostname, and the model that is loaded.
* `GPU0` line — straight from `nvidia-smi`: the device, its temperature, and its power draw right now.
* `util` — GPU compute utilization. 100% while a burst is being decoded, back to 0% between turns.
* `VRAM` — memory used of the 80 GB. It sits at ~90% even when idle, because vLLM preallocates the entire KV cache pool at startup (`--gpu-memory-utilization 0.92`), so this bar shows the budget, not the load.
* `throughput` — vLLM's rolling averages: prefill (prompt) tok/s and decode (generation) tok/s.
* `requests` — how many conversations are being decoded right now (`running`) and how many are queued (`waiting`). A sustained `waiting > 0` means the model is overloaded.
* `KV cache` — the share of the preallocated KV cache pool in use: your active context as a fraction of everything the GPU can hold.
* `cache hits` — the prefix-cache hit rate: the percentage of prompt tokens served from cache instead of being prefilled.

All of it is collected with a single SSH call per VM over the tunnel: `nvidia-smi` for the hardware rows, `docker logs --tail 200` filtered to vLLM's `Engine 0` line for the rest.

The engine log kept all of it: 474 samples from a single ~80 minute work morning, with two or three agents active for most of it. What the numbers mean:

* Decode: ~40 tok/s for a single conversation, up to ~110 tok/s in total when two or three are decoding at once, because batching keeps the GPU saturated. Benchmark numbers for 27B FP8 on this GPU land at 40–99 tok/s. For a coding agent that's comfortable: you can read a generated line about as fast as it arrives.
* Prefill: benchmarks for 27B FP8 on this GPU land at 5,000–11,000 tok/s at peak. The `Avg prompt throughput` in the log looks much lower (the best 10-second window of my morning was ~3,000 tok/s), because it's averaged over idle time too, and because most of the prompt never needs computing at all: 80–97% of it came from the prefix cache. The GPU only prefills the ~3–20% that is new.
* KV cache usage: ~16% for most of the morning, up to 40% when two long conversations were in flight. The pool is everything left after the weights, and even at 40% vLLM was nowhere near running out of context.
* GPU: ~80 W and 57°C idle; under a real burst it hits 100% utilization, 299 W, and 66°C. The A100 PCIe is a 300 W card, so a full burst runs it right at its power limit.

One more thing I did not expect: three pi agents against the same VM at once. Three tmux panes, three conversations, all Qwen3.8 27B FP8 on one A100, and I noticed no slowdown on any of them. vLLM batches concurrent requests: every decode step produces the next token for all running conversations at once. Since decode is limited by reading the weights from VRAM, and the weights are read only once per step no matter how many conversations are in the batch, three conversations cost barely more than one. Each conversation keeps its own slice of the KV cache pool. The morning's log shows all three running at the same time around 07:30, with total decode throughput pushing ~100 tok/s and the KV cache at ~32% at that point. So three full agent conversations only filled the pool about a third of the way.

One caveat on all of these numbers: prompt length, whether the prefix cache is warm, how many agents share the GPU, whether reasoning is chewing tokens and which extensions are loaded all play into it. Change any of those, and the same model on the same card looks different. It's one morning's snapshot, not a leaderboard.

Per-turn latency for a full agent step (prompt in, answer out) is roughly 10–15 seconds with vLLM on this hardware, versus ~28 seconds I measured with Ollama at 32K context, and Ollama was truncating my context at 32K while vLLM runs the full 262K.

Startup is the other number that matters for the "rent, don't buy" math: about 10 minutes from `create` to the first token on a fresh VM, and about 2 minutes for a container restart (see "Why starting a model takes minutes" above for the breakdown).

## What I trust it with (and what I don't)

The `gt` calculator was the proof case, a real project built almost entirely on this stack. Day to day I also use it for ops babysitting via `/loop` and `/watch`: check the VM, watch a build, poke me when something smells wrong. That is work I trust it with.

Vendor SWE-bench numbers are not my session success rate. Hit-and-miss still happens. When a turn starts looping or the model gets lost in its own plan, I bounce the hard bit to a hosted frontier model and bring the answer back.

Bottom line: it's good enough that I built a real project on it and keep using it every day. But I still have to babysit it.

## What it costs, and do I buy the hardware?

Hyperstack bills per minute. The relevant prices (as of September 2026):

* A100 80 GB: $1.35/h on-demand, from $0.95/h reserved
* H100 80 GB: $2.50/h on-demand, from $1.75/h reserved

So one VM running 24/7 costs around $1,000/month, two VMs just under $2,000. That sounds expensive until you remember the alternative I was actually considering:

* RTX 5090 32 GB — $1,999 MSRP, $3,000–5,000 in the real world of 2026. But 32 GB is a hard ceiling: the 27B FP8 model with its 262K context does not fit, and anything 70B+ is out of the question. I would be buying a card that cannot run the models I actually want to test. Even when a model does fit, consumer cards usually bring less memory bandwidth than a rented A100, so "it loads" is not the same as "it feels fast" while the agent is decoding. Same goes for a future ThinkPad with a laptop GPU: interesting for privacy and independence (more on that at the end), but bandwidth decides whether it feels like this A100 or merely loads the weights.
* DGX Spark, 128 GB unified memory — $3,999 launch price (closer to $5,000 in 2026, memory shortages being what they are). It can run 200B-parameter models, but its memory bandwidth (273 GB/s, versus ~1,900 GB/s on the A100) is laptop-class. It's a fascinating machine for fitting big models, not for decoding them fast. Same bandwidth lesson as above, just louder.

If you do buy hardware instead, watch the stack too. A Mac or a DGX Spark box mostly lives in GGUF / MLX / LM Studio land. hypr is the NVIDIA / Hugging Face / vLLM path. The models overlap; the weight formats and runtimes don't. Mixing the two in your head is a good way to buy the wrong box.

The rented A100, meanwhile, runs everything on the preset list (including the 120B MoE) for $1.35 an hour, and costs me exactly zero when I am not using it. The `gt` project ran on exactly this setup, and its whole GPU bill is trivial next to what the hardware it needed would have cost.

Monthly cost is the wrong unit though. The real comparison is per token. The numbers from that morning's engine log: 1.3 hours of GPU time ($1.78), ~11M prompt tokens of which 90–95% came from the prefix cache, plus ~250K generated tokens.

* New prompt tokens (prefill): roughly $0.05–0.15 per million on the A100, versus $0.21 on OpenRouter for the same model (`qwen/qwen3.8-27b`, live pricing, September 2026).
* Cached prompt tokens: effectively free, since they are looked up in the KV cache, not computed. OpenRouter charges $0.15 per million for the same privilege.
* Generated tokens (decode): the weak spot. About $9 per million with one agent (~40 tok/s), $3–5 with two or three agents sharing the GPU, versus $2.55 on OpenRouter.

=> ./running-my-own-llms-for-coding/cost-per-token.svg Cost per million tokens: rented A100 vs OpenRouter

For that morning's exact workload the math lands at about $0.16 per million total tokens on the VM, versus about $0.20 on OpenRouter. An agentic session is mostly resending the same context, so with a 90%+ cache hit rate the local setup is at parity with the API for the same model, and it gets cheaper the more agents share the GPU, because the $1.35 hour is a fixed cost that three conversations split.

Flip the workload and the API wins comfortably: a light session here and there costs almost nothing on OpenRouter, while the VM bills the full hour whether you send tokens or not, and local decode runs about 3–4× the API price per output token with a single agent. So: for a full day of heavy agentic work, renting an A100 costs roughly what the API charges per token for the same model, except nothing leaves my infrastructure and nobody rate-limits me. For occasional use, the API is simply cheaper.

So where does that leave the question from the gt post: will I invest a couple of thousand dollars in hardware? Still no. At current prices, buying a consumer GPU that cannot run the models I want to experiment with, in order to save a $1.35/hour bill that I only run a few hours a day, does not compute. The 128 GB unified-memory boxes (DGX Spark, and the RTX Spark machines shipping later this year) are the first consumer hardware that could genuinely change the math, because they remove the VRAM ceiling. I will watch those closely.

## Wrapping up

So no DGX Spark for me yet. The models it can run are good enough for real work, but for the few hours a day I use a local model, renting (or the API) is cheaper, and a $5,000 box only pays off if it runs around the clock.

The other side of the ledger isn't small, though. Only a box on my desk is really local: a rented VM still puts my code on someone else's hardware, and an API sends it out of the house. Privacy is one reason. The bigger one is independence: I don't like depending on cloud providers for tools I use every day, with their price changes, rate limits and models that quietly disappear. And the tinkerer in me wants a GPU I can play with at 2 a.m. without a meter running.

So I'm waiting for one of two things: my ThinkPad dying and being replaced by something with real local-LLM power (the RTX Spark class of machine, if it ever gets proper Linux support), or the next superchip generation after Grace Blackwell (Vera Rubin, probably 2027 or 2028). Buying a $5,000 box right before its successor ships with more memory and bandwidth is exactly the trap renting keeps me out of. Especially since the models change every few months: the Qwen3.8 on VM1 this month isn't the model I was testing in May.

One more thing, to be honest about where this stands. The frontier models, especially Opus 5.5, are so good now that this local setup can't really beat them. Whatever the benchmark table above says about Qwen3.8 vs Opus 4.6, in daily use the gap to the current frontier is obvious, especially for big, fuzzy tasks where the model has to plan and work on its own for a long time. So even with my own LLM hardware on the desk, I'd keep my cloud subscriptions for most of my LLM usage.

That doesn't make this a wasted investigation, though. You can already do a lot with these local models. They're especially well suited for "in the loop" coding and for study projects, where I want to deep dive into a topic myself and the LLM only assists here and there: explaining a piece of code, writing a test, doing a small refactoring. For that, a 27B model on a rented A100 is more than good enough, and I learned a lot about how all of this works under the hood along the way.

Until then, the setup is all in the repo: `git clone https://github.com/snonux/hypr` gets you the provisioner, the WireGuard script, the per-VM model presets and the pi extensions. If you don't want any Ruby, the manual path is short: rent a GPU VM with CUDA and Docker, run `vllm/vllm-openai` with `--enable-prefix-caching --gpu-memory-utilization 0.92 --max-model-len 262144`, tunnel in with WireGuard or a port forward, and point any OpenAI-compatible client at it.

Other related posts:

<< template::inline::rindex llm calculator agentic-coding

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
