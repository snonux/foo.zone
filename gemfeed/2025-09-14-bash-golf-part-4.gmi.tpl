# Bash Golf Part 4

> Published at 2025-09-13T12:04:03+03:00

This is the fourth blog post about my Bash Golf series. This series is random Bash tips, tricks, and weirdnesses I have encountered over time. 

<< template::inline::index bash-golf

```

    '\       '\        '\        '\                   .  .        |>18>>
      \        \         \         \              .         ' .   |
     O>>      O>>       O>>       O>>         .                 'o |
      \       .\. ..    .\. ..    .\. ..   .                      |
      /\    .  /\     .  /\     .  /\    . .                      |
     / /   .  / /  .'.  / /  .'.  / /  .'    .                    |
jgs^^^^^^^`^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        Art by Joan Stark, mod. by Paul Buetow
```

<< template::inline::toc

## Split pipelines with tee + process substitution

Sometimes you want to fan out one stream to multiple consumers and still continue the original pipeline. `tee` plus process substitution does exactly that:

```
somecommand \
    | tee >(command1) >(command2) \
    | command3
```

All of `command1`, `command2`, and `command3` see the output of `somecommand`. Example:

```bash
printf 'a\nb\n' \
    | tee >(sed 's/.*/X:&/; s/$/ :c1/') >(tr a-z A-Z | sed 's/$/ :c2/') \
    | sed 's/$/ :c3/'
```

Output:

```
a :c3
b :c3
A :c2 :c3
B :c2 :c3
X:a :c1 :c3
X:b :c1 :c3
```

This relies on Bash process substitution (`>(...)`). Make sure your shell is Bash and not a POSIX `/bin/sh`.

Example (fails under `dash`/POSIX sh):

```bash
/bin/sh -c 'echo hi | tee >(cat)'
# /bin/sh: 1: Syntax error: "(" unexpected
```

Combine with `set -o pipefail` if failures in side branches should fail the whole pipeline.

Example:

```bash
set -o pipefail
printf 'ok\n' | tee >(false) | cat >/dev/null
echo $?   # 1 because a side branch failed
```

Further reading:

=> https://blogtitle.github.io/splitting-pipelines/ Splitting pipelines with tee

## Heredocs for remote sessions (and their gotchas)

Heredocs are great to send multiple commands over SSH in a readable way:

```bash
ssh "$SSH_USER@$SSH_HOST" <<EOF
    # Go to the work directory
    cd "$WORK_DIR"
  
    # Make a git pull
    git pull
  
    # Export environment variables required for the service to run
    export AUTH_TOKEN="$APP_AUTH_TOKEN"
  
    # Start the service
    docker compose up -d --build
EOF
```

Tips:

Quoting the delimiter changes interpolation. Use `<<'EOF'` to avoid local expansion and send the content literally.

Example:

```bash
FOO=bar
cat <<'EOF'
$FOO is not expanded here
EOF
```

Prefer explicit quoting for variables (as above) to avoid surprises. Example (spaces preserved only when quoted):

```bash
WORK_DIR="/tmp/my work"
ssh host <<EOF
    cd $WORK_DIR      # may break if unquoted
    cd "$WORK_DIR"   # safe
EOF
```

Consider `set -euo pipefail` at the top of the remote block for stricter error handling. Example:

```bash
ssh host <<'EOF'
    set -euo pipefail
    false   # causes immediate failure
    echo never
EOF
```

Indent-friendly variant: use a dash to strip leading tabs in the body:

```bash
cat <<-EOF > script.sh
	#!/usr/bin/env bash
	echo "tab-indented content is dedented"
EOF
```

Further reading:

=> https://rednafi.com/misc/heredoc_headache/ Heredoc headaches and fixes

## Namespacing and dynamic dispatch with `::`

You can emulate simple namespacing by encoding hierarchy in function names. One neat pattern is pseudo-inheritance via a tiny `super` helper that maps `pkg::lang::action` to a `pkg::base::action` default.

```bash
#!/usr/bin/env bash
set -euo pipefail

super() {
    local -r fn=${FUNCNAME[1]}
    # Split name on :: and dispatch to base implementation
    local -a parts=( ${fn//::/ } )
    "${parts[0]}::base::${parts[2]}" "$@"
}

foo::base::greet() { echo "base: $@"; }
foo::german::greet()  { super "Guten Tag, $@!"; }
foo::english::greet() { super "Good day,  $@!"; }

for lang in german english; do
    foo::$lang::greet Paul
done
```

Output:

```
base: Guten Tag, Paul!
base: Good day,  Paul!
```

## Indirect references with namerefs

`declare -n` creates a name reference — a variable that points to another variable. It’s cleaner than `eval` for indirection:

```bash
user_name=paul
declare -n ref=user_name
echo "$ref"       # paul
ref=julia
echo "$user_name" # julia
```

Output:

```
paul
julia
```

Namerefs are local to functions when declared with `local -n`. Requires Bash ≥4.3.

You can also construct the target name dynamically:

```bash
make_var() {
    local idx=$1; shift
    local name="slot_$idx"
    printf -v "$name" '%s' "$*"   # create variable slot_$idx
}

get_var() {
    local idx=$1
    local -n ref="slot_$idx"      # bind ref to slot_$idx
    printf '%s\n' "$ref"
}

make_var 7 "seven"
get_var 7
```

Output:

```
seven
```

## Function declaration forms

All of these work in Bash, but only the first one is POSIX-ish:

```bash
foo() { echo foo; }
function foo { echo foo; }
function foo() { echo foo; }
```

Recommendation: prefer `name() { ... }` for portability and consistency.

## Chaining function calls in conditionals

Functions return a status like commands. You can short-circuit them in conditionals:

```bash
deploy_check() { test -f deploy.yaml; }
smoke_test()   { curl -fsS http://localhost/healthz >/dev/null; }

if deploy_check || smoke_test; then
    echo "All good."
else
    echo "Something failed." >&2
fi
```

You can also compress it golf-style:

```bash
deploy_check || smoke_test && echo ok || echo fail >&2
```

## Grep, sed, awk quickies

Word match and context: `grep -w word file`; with context: `grep -C3 foo file` (same as `-A3 -B3`). Example:

```bash
cat > /tmp/ctx.txt <<EOF
one
foo
two
three
bar
EOF
grep -C1 foo /tmp/ctx.txt
```

Output:

```
one
foo
two
```

Skip a directory while recursing: `grep -R --exclude-dir=foo 'bar' /path`. Example:

```bash
mkdir -p /tmp/golf/foo /tmp/golf/src
printf 'bar\n' > /tmp/golf/src/a.txt
printf 'bar\n' > /tmp/golf/foo/skip.txt
grep -R --exclude-dir=foo 'bar' /tmp/golf
```

Output:

```
/tmp/golf/src/a.txt:bar
```

Insert lines with sed: `sed -e '1isomething' -e '3isomething' file`. Example:

```bash
printf 'A\nB\nC\n' > /tmp/s.txt
sed -e '1iHEAD' -e '3iMID' /tmp/s.txt
```

Output:

```
HEAD
A
B
MID
C
```

Drop last column with awk: `awk 'NF{NF-=1};1' file`. Example:

```bash
printf 'a b c\nx y z\n' > /tmp/t.txt
cat /tmp/t.txt
echo
awk 'NF{NF-=1};1' /tmp/t.txt
```

Output:

```
a b c
x y z

a b
x y
```

## Safe xargs with NULs

Avoid breaking on spaces/newlines by pairing `find -print0` with `xargs -0`:

```bash
find . -type f -name '*.log' -print0 | xargs -0 rm -f
```

Example with spaces and NULs only:

```bash
printf 'a\0b c\0' | xargs -0 -I{} printf '<%s>\n' {}
```

Output:
  
```
<a>
<b c>
```

## Efficient file-to-variable and arrays

Read a whole file into a variable without spawning `cat`:

```bash
cfg=$(<config.ini)
```

Read lines into an array safely with `mapfile` (aka `readarray`):

```bash
mapfile -t lines < <(grep -v '^#' config.ini)
printf '%s\n' "${lines[@]}"
```

Assign formatted strings without a subshell using `printf -v`:

```bash
printf -v msg 'Hello %s, id=%04d' "$USER" 42
echo "$msg"
```

Output:

```
Hello paul, id=0042
```

Read NUL-delimited data (pairs well with `-print0`):

```bash
mapfile -d '' -t files < <(find . -type f -print0)
printf '%s\n' "${files[@]}"
```

## Quick password generator

Pure Bash with `/dev/urandom`:

```bash
LC_ALL=C tr -dc 'A-Za-z0-9_' </dev/urandom | head -c 16; echo
```

Alternative using `openssl`:

```bash
openssl rand -base64 16 | tr -d '\n' | cut -c1-22
```

## `yes` for automation

`yes` streams a string repeatedly; handy for feeding interactive commands or quick load generation:

```bash
yes | rm -r large_directory        # auto-confirm
yes n | dangerous-command          # auto-decline
yes anything | head -n1            # prints one line: anything
```

## Forcing `true` to fail (and vice versa)

You can shadow builtins with functions:

```bash
true()  { return 1; }
false() { return 0; }

true  || echo 'true failed'
false && echo 'false succeeded'

# Bypass function with builtin/command
builtin true # returns 0
command true # returns 0
```

To disable a builtin entirely: `enable -n true` (re-enable with `enable true`).

Further reading:

=> https://blog.robertelder.org/force-true-command-to-return-false/ Force true to return false

## Restricted Bash

`bash -r` (or `rbash`) starts a restricted shell that limits potentially dangerous actions, for example:

* Changing directories (`cd`).
* Modifying `PATH`, `SHELL`, `BASH_ENV`, or `ENV`.
* Redirecting output.
* Running commands with `/` in the name.
* Using `exec`.

It’s a coarse sandbox for highly constrained shells; read `man bash` (RESTRICTED SHELL) for details and caveats.

Example session:

```bash
rbash -c 'cd /'            # cd: restricted
rbash -c 'PATH=/tmp'       # PATH: restricted
rbash -c 'echo hi > out'   # redirection: restricted
rbash -c '/bin/echo hi'    # commands with /: restricted
rbash -c 'exec ls'         # exec: restricted
```

## Useless use of cat (and when it’s ok)

Avoid the extra process if a command already reads files or `STDIN`:

```bash
# Prefer
grep -i foo file
<file grep -i foo        # or feed via redirection

# Over
cat file | grep -i foo
```

But for interactive composition, or when you truly need to concatenate multiple sources into a single stream, `cat` is fine, as you may think, "First I need the content, then I do X." Changing the "useless use of cat" in retrospect is really a waste of time for one-time interactive use:

```bash
cat file1 file2 | grep -i foo
```

From notes: “Good for interactivity; Useless use of cat” — use judgment.

## Atomic locking with `mkdir`

Portable advisory locks can be emulated with `mkdir` because it’s atomic:

```bash
lockdir=/tmp/myjob.lock
if mkdir "$lockdir" 2>/dev/null; then
    trap 'rmdir "$lockdir"' EXIT INT TERM
    # critical section
    do_work
else
    echo "Another instance is running" >&2
    exit 1
fi
```

This works well on Linux. Remove the lock in `trap` so crashes don’t leave stale locks.

## Smarter globs and faster find-exec

* Enable extended globs when useful: `shopt -s extglob`; then patterns like `!(tmp|cache)` work.
* Use `-exec ... {} +` to batch many paths in fewer process invocations:

```bash
find . -name '*.log' -exec gzip -9 {} +
```

Example for extglob (exclude two dirs from listing):

```bash
shopt -s extglob
ls -d -- !(.git|node_modules) 2>/dev/null
```

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other related posts are:

<< template::inline::rindex bash

=> ../ Back to the main site
