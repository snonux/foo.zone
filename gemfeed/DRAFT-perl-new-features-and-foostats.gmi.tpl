# Perl New Features and Foostats

> Published at DRAFT; Updated at DRAFT

Perl just reached rank 10 in the TIOBE index again. That headline matches my day-to-day reality because I keep maintaining the foostats script in `temp/foostats/foostats.pl`, and every new Perl release makes the job easier. The book *Perl New Features* by Joshua McAdams and brian d foy documents the changes well; this post shows how those features look in a real program that runs every morning.

I stuck with Perl for foostats for three simple reasons: I wanted an excuse to explore the newer features of my first programming love, Perl ships with OpenBSD so the dependency story is painless, and it really does live up to its Practical Extraction and Report Language nickname for this kind of log grinding.

=> https://developers.slashdot.org/story/25/09/14/0134239/is-perl-the-worlds-10th-most-popular-programming-language Perl re-enters the top ten
=> https://perlschool.com/books/perl-new-features/ Perl New Features by Joshua McAdams and brian d foy

<< template::inline::toc

## Inside foostats

### Log pipeline

A cron job starts foostats, reads OpenBSD httpd and relayd access logs plus vger Gemini logs, and produces the numbers published at https://stats.foo.zone and gemini://stats.foo.zone. The dashboards are humble because traffic is still light, yet the trends are useful for spotting patterns. The script is opinionated for that stack: filesystem paths, log formats, and TLS replication defaults target my OpenBSD hosts running httpd, relayd, and vger. `Foostats::Logreader` parses each line, turns timestamps into YYYYMMDD/HHMMSS values, hashes IP addresses with SHA3, and hands a normalised event to `Foostats::Filter`. The filter compares the URI against entries in `fooodds.txt`, tracks how many times an IP requests within the same second, and drops anything suspicious. Valid events reach `Foostats::Aggregator`, which counts requests per protocol, records unique visitors for the Gemtext and Atom feeds, and remembers page-level IP sets. `Foostats::FileOutputter` writes the result as gzipped JSON files—one per day and per protocol—with IPv4/IPv6 splits, filtered counters, feed readership, and hashes for long URLs.
=> https://stats.foo.zone stats.foo.zone dashboard
=> gemini://stats.foo.zone stats.foo.zone capsule stats

### Aggregation and output

Those gz files land in `stats/`. From there `Foostats::Replicator` can pull matching files from the partner host (fishfinger or blowfish) so the view covers both servers, `Foostats::Merger` combines them into daily summaries, and `Foostats::Reporter` rebuilds Gemtext and HTML reports in `out_gmi/` and `out_html/`. Daily pages list request counts, feed readers, and the long tail of URLs, while the HTML mirror serves people who browse with a web browser only. Foostats also rebuilds the rolling 30-day summary and front-page index so the capsule and website always show fresh headline numbers. A simple `Justfile` keeps the workflow repeatable (`just parse`, `just report`, `just lint`), and the `t/` directory contains TAP tests that feed synthetic logs through the parser, merger, and reporter. That test suite is the safety net for any refactor.

### Command-line entry points

`foostats_main` is the command entry point. `--parse-logs` refreshes the gz files, `--replicate` runs the cross-host sync, and `--report` rebuilds the dashboards. `--all` performs everything in one go. Defaults point to `/var/www/htdocs/buetow.org/self/foostats` for data, `/var/gemini/stats.foo.zone` for Gemtext output, and `/var/www/htdocs/gemtexter/stats.foo.zone` for HTML output. Replication always forces the three most recent days across HTTPS and leaves older files untouched to save bandwidth. `fooodds.txt` is a plain text list of substrings; blank lines or `#` comments are ignored, and any other entry blocks a request when the URI contains it, which makes it quick to shut down scanners while keeping the rules in version control. Audit lines go to `/var/log/fooodds`. The `Justfile` even has a `gather-fooodds` task that collects suspicious paths from remote logs so new patterns can be added quickly. The full source lives on Codeberg at https://codeberg.org/snonux/foostats, including the Justfile, TAP tests, and the evolving `fooodds.txt` pattern list for review.
=> https://codeberg.org/snonux/foostats foostats on Codeberg

## Packages as real blocks

### Scoped packages

Recent Perl versions allow the block form `package Foo { ... }`. Foostats uses it for every package. Imports stay local to the block, helper subs do not leak into the global symbol table, and configuration happens where the code needs it.

### Configuration inside packages

`Foostats::Filter` loads its odds list with `FileHelper::read_lines` inside the block, and `Foostats::Reporter` keeps Gemtext and HTML helpers together. This matches the advice in *Perl New Features* and made the file read more like a structured document than a stack of `package` statements.

## Postfix deref keeps data structures tidy

### Clear dereferencing

The script handles nested hashes and arrays. Postfix dereferencing (`$hash->%*`, `$array->@*`) keeps that readable.

### Simpler merge loops

Loops like `$stats->{page_ips}->{urls}->%*` or `$merge{$key}->{$_}->%*` show which level of the structure is in play. The merger updates host and URL statistics without building temporary arrays, and the reporter code mirrors the layout of the final tables. Before postfix deref, the same code relied on braces within braces and was hard to review.

## Lexical subs promote local reasoning

### Helpers that stay local

Lexical subroutines keep helpers close to the code that needs them. In `Foostats::Logreader::parse_web_logs`, functions such as `my sub parse_date` and `my sub open_file` live only inside that scope.

### Small diffs when adding features

When support for the Gemini relay logs was added, the new helper subs sat next to their logic, the diff stayed small, and the tests confirmed that the HTTP parsing path did not change. Older versions used package-level helper subs, which made it easy to create accidental dependencies.

## Ref aliasing makes intent explicit

### Shared data on purpose

Ref aliasing is enabled with `use feature qw(refaliasing)` and helps communicate intent. The filter starts with `\my $uri_path = \$event->{uri_path}` so any later modification touches the original event.

### Stable aggregation buckets

The aggregator aliases `$self->{stats}{$date_key}` before updating counters so the structure stays in place. Combined with subroutine signatures, this makes it obvious when a piece of data is shared instead of copied and prevents silent bugs.

## Persistent state without globals

### Rate limiting state

`state` variables store run-specific state without using package globals. `state %blocked` remembers IP hashes that already triggered the odd-request filter, and `state $last_time` and `state %count` track how many requests an IP makes in the same second. Hash and array state variables have been supported since `state` arrived in Perl 5.10, so this code simply takes advantage of that long-standing capability.

### Deduplicated logging

`state %dedup` keeps the log output to one warning per URI. Early versions used global hashes for the same tasks and produced inconsistent results during tests. Switching to `state` removed those edge cases.

## Subroutine signatures clarify every call site

### Contracts in the code

Subroutine signatures are active throughout foostats. Constructors declare `sub new ($class, $odds_file, $log_path)`, callbacks expose `sub ($event)`, and helper subs list the values they expect.

### Safer CLI and callbacks

There is no need to scroll up for the first `shift @_`. The main function rejects stray arguments with a clear message, and contributors have to document new parameters when they extend `Foostats::Reporter::report`.

## Defined-or assignment keeps defaults obvious

### Defaults without boilerplate

The operator `//=` keeps configuration and counters simple. Environment variables may be missing when cron runs the script, so `//=`, combined with signatures, sets defaults without warnings.

### Shared idiom across modules

The same pattern seeds host hashes, tallies odds counters, and keeps the replicator retry count grounded. It avoids `unless defined` blocks or ternary expressions that existed before.

## `say` is the ergonomic logging voice

### Short logging statements

`say` became the default once the script switched to `use v5.38;`. Log messages such as “Processing $path” or “Writing report to $report_path” now end with a newline automatically.

### Readable progress output

Diagnostic output inside lexical subs can use `say` without worrying about concatenation. When foostats rebuilds a month of reports, the sequence of log lines reads like a progress indicator that humans can follow.

## Ecosystem momentum

### Builtins and booleans

The script also uses other modern additions that do not always get headlines. `use builtin qw(true false);` together with `experimental::builtin` gives predictable boolean values.

### Tooling and tests

The TAP tests in `t/` run with the same interpreter as the live capsule. The `Justfile` provides `just lint` (running `perl -c` plus tidyall) and `just test`, so style and unit tests stay part of the routine. Perl’s toolchain rewards that kind of consistent care.

### Dependencies

Foostats expects Perl 5.38 with modern modules: core pieces like Time::Piece and Getopt::Long accompany packaged modules such as Digest::SHA3, PerlIO::gzip, JSON, String::Util, LWP::UserAgent, and HTML::Entities. On OpenBSD I install them with `doas pkg_add p5-Digest-SHA3 p5-PerlIO-gzip p5-JSON p5-String-Util p5-LWP-Protocol-https p5-HTML-Parser perltidy`.

## Why this matters beyond foostats

These features keep a large log processor maintainable while it parses, filters, aggregates, replicates, and reports across both HTTP and Gemini traffic. They let me upgrade foostats a bit at a time without breaking the deployment. Perl still embraces TIMTOWTDI, but the defaults are more sensible now, so the focus stays on delivering the statistics people expect. That is the same strength that pushed Perl back into the TIOBE top ten, and it is why I continue to rely on it for daily operations.

=> ../ Back to the main site
