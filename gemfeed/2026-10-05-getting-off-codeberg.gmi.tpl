# Getting off Codeberg

> Published at 2026-10-04T14:01:34+03:00

Codeberg voted to restrict LLM-heavy projects on the forge. I was a supporting member. I had been somehow proud of that — supporting Codeberg, being on their platform, and what they stood for. Part of it was the mission. Part of it, if I am honest, was also that I like(d) being a bit different than the masses, not just parking everything on GitHub with everyone else. Is that still valuable? I think so, yes.

I gave Codeberg around a month after the terms change, to see whether the community would backfire enough to change it back again. Nothing happened. So I decided to move off now.

=> https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html Protecting our FLOSS commons from LLMs — Codeberg News

<< template::inline::toc

## What they decided

Two motions passed at the Codeberg e. V. assembly. One is the usual "we will not train LLMs on your data" statement. Fine. The other changes the terms of use. The blog post spells out the broader "vibe-coded projects" thinking; the actual ToU patch is shorter and sharper:

=> https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html Protecting our FLOSS commons from LLMs — Codeberg News
=> https://codeberg.org/Codeberg/org/commit/96fac426a32d1ba91ff879366d59bf1af54080c2 Terms of Use change (commit 96fac426)

```
You must not share projects that mostly consist of code written by
"generative AI"-tools (including services such as *Claude*, *OpenAI Codex*).
Such projects having an unclear copyright status (see requirements § 2 (1) 1
and § 2 (1) 3) and furthermore have little safeguards to ensure that they do
not include harmful code (c.f. § 2 (1) 5).
```

Two claims in that paragraph do not land for me.

How does banning LLM-heavy projects ensure they do not include harmful code? Could Codeberg ensure that before LLMs existed? Of course not. Hand-written malware, supply-chain tricks, and "oops I pushed credentials" could already have been therej LLM or not, the forge never had a magic filter for "harmful code".

And unclear copyright status: I don't think that is Codeberg's responsibility. It is the responsibility of the "author", or rather the orchestrator of the LLMs — the person who shipped the project. Same as with any other dependency soup or copied snippet. And if it really comes to a fight, Codeberg can still act and remove a repo when a governmental institution demands it. That was already true before LLMs. You do not need a forge-wide ban on generative AI to keep that door open. 

They say they will not mass-delete overnight and will not auto-scan every repo. Still, the signal is clear: if you build software the way a lot of people build software in 2026, Codeberg would rather you go somewhere else.

## Typically German thinking

Honestly, this reads like typically German thinking to me. Careful, rule-heavy, a bit proud of doing things the old way. Software development from the stone age, without LLMs. And yes, Codeberg is located in Germany — the Verein, and the hosting too.

Me, being german (but being an expat for over a decate now not living in Germany anymore) understands the fears. Slop PRs. Ghost projects that burn CI. Crawlers hammering the forge. Copyright fog. Those are real problems. Banning the modern way of writing software is not a serious answer to them, IMHO.

## Still coding by hand?

Is there still a place for coding by hand? Sure. A few, even:

* To keep you sharp. I still do this occasionally for that reason alone.
* For fun. For the flow state. Sometimes you just want to sit with the editor and write the thing yourself with headphones on.
* LeetCoding. Same sharpness argument, and it still helps with interviews.

But if you really want to get stuff done, all projects should be using LLMs now. I am not talking about vibe-coding everything — though vibe coding also has its place. I mean using models as part of the normal loop: design, write, review, refactor, ship. Pretending that is optional already feels like pretending compilers are optional.

## Capacity problems I understand

I do understand that Codeberg may have capacity issues. Donation-funded hardware, crawlers chewing through pages, one-person repos with giant CI matrices — that costs money. Fair.

But then adapt to the new way of doing things. Put limits on CI minutes. Rate-limit the dumb crawlers. Charge for heavy use if you have to. Do not write a moral rule that treats LLM-assisted software as second-class FLOSS. The tooling moved. The forge has to move with it, or people leave.

## Where I go from here

So I am getting off Codeberg for new work. Anything that treats "mostly written by generative AI" as a problem is the wrong host for how I build software now.

Over time I may retire the existing Codeberg repos, or just archive them. Before archiving, I would point each README.md at the GitHub mirror so people still land somewhere useful.

I also created my own Forgejo instance on the home-lab k3s cluster now. That is where the LLM coding happens day to day. From there I also merge the projects out to my public GitHub repos, so the code stays easy to find.

=> https://github.com/snonux github.com/snonux
=> https://forgejo.org Forgejo

Friends pointed me at `codefloe.com` as a more LLM-friendly Codeberg alternative. I have not switched yet, and I am not sure I will — maybe, maybe not.

=> https://codefloe.com Codefloe

Related post:

=> ./2024-09-07-projects-i-support.gmi 2024-09-07 Projects I support (includes Codeberg)

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
