# Perl New Features and Foostats

Perl just reached rank 10 in the TIOBE index. That headline matches my day-to-day reality because I keep developing the foostats script for simple analytics of my personal websites and Gemini capsules (e.g. `foo.zone`), and almost every Perl release adds new features which make life better. The book *Perl New Features* by brian d foy documents the changes well; this post shows how those features look in a real program that runs every morning for my stats generation.

Even though nowadays I code more in Go and Ruby, I stuck with Perl for foostats for three simple reasons:

* I wanted an excuse to explore the newer features of my first programming love.
* Perl ships with OpenBSD (the operating system on which my sites run) by default
* It really does live up to its Practical Extraction and Report Language (that's where the name Perl means) for this kind of log grinding I did with foostats.

[Perl re-enters the top ten](https://developers.slashdot.org/story/25/09/14/0134239/is-perl-the-worlds-10th-most-popular-programming-language)  
[Perl New Features by Joshua McAdams and brian d foy](https://perlschool.com/books/perl-new-features/)  

## Table of Contents

* [⇢ Perl New Features and Foostats](#perl-new-features-and-foostats)
* [⇢ ⇢ Inside foostats](#inside-foostats)
* [⇢ ⇢ ⇢ Log pipeline](#log-pipeline)
* [⇢ ⇢ ⇢ Aggregation and output](#aggregation-and-output)
* [⇢ ⇢ ⇢ Command-line entry points](#command-line-entry-points)
* [⇢ ⇢ Packages as real blocks](#packages-as-real-blocks)
* [⇢ ⇢ ⇢ Scoped packages](#scoped-packages)
* [⇢ ⇢ Postfix deref keeps data structures tidy](#postfix-deref-keeps-data-structures-tidy)
* [⇢ ⇢ ⇢ Clear dereferencing](#clear-dereferencing)
* [⇢ ⇢ ⇢ Simpler merge loops](#simpler-merge-loops)
* [⇢ ⇢ Lexical subs promote local reasoning](#lexical-subs-promote-local-reasoning)
* [⇢ ⇢ ⇢ Helpers that stay local](#helpers-that-stay-local)
* [⇢ ⇢ Ref aliasing makes intent explicit](#ref-aliasing-makes-intent-explicit)
* [⇢ ⇢ ⇢ Shared data on purpose](#shared-data-on-purpose)
* [⇢ ⇢ Persistent state without globals](#persistent-state-without-globals)
* [⇢ ⇢ ⇢ Rate limiting state](#rate-limiting-state)
* [⇢ ⇢ ⇢ Deduplicated logging](#deduplicated-logging)
* [⇢ ⇢ Subroutine signatures clarify every call site](#subroutine-signatures-clarify-every-call-site)
* [⇢ ⇢ ⇢ "normal" subroutine signatures now](#normal-subroutine-signatures-now)
* [⇢ ⇢ Defined-or assignment keeps defaults obvious](#defined-or-assignment-keeps-defaults-obvious)
* [⇢ ⇢ ⇢ Defaults without boilerplate](#defaults-without-boilerplate)
* [⇢ ⇢ `say` is the default voice now](#say-is-the-default-voice-now)
* [⇢ ⇢ Cleanup with `defer`](#cleanup-with-defer)
* [⇢ ⇢ Builtins and booleans](#builtins-and-booleans)
* [⇢ ⇢ Conclusion](#conclusion)

## Inside foostats

Foostats is simply a log file analyser.

### Log pipeline

A cron job starts Foostats, reads OpenBSD httpd and relayd access logs, and produces the numbers published at `https://stats.foo.zone` and `gemini://stats.foo.zone`. The dashboards are humble because traffic on my sites is still light, yet the trends are interesting for spotting patterns. The script is opinionated, and I will probably be the only one ever using it for my own sites. However, the code demonstrates how Perl's newer features help keep a small script like this exciting and fun!

On OpenBSD, I've configured the job via the `daily.local` on both servers (`fishfinger` and `blowfish`):

```sh
fishfinger$ grep foostats /etc/daily.local
perl /usr/local/bin/foostats.pl --parse-logs --replicate --report
```

Internally, `Foostats::Logreader` parses each line of the log files `/var/log/daemon*` and `/var/www/logs/access_log*`, turns timestamps into YYYYMMDD/HHMMSS values, hashes IP addresses with SHA3 (for anonymisation), and hands a normalised event to `Foostats::Filter`. The filter compares the URI against entries in `fooodds.txt`, tracks how many times an IP address requests within the exact second, and drops anything suspicious (e.g., from web crawlers or malicious attackers). Valid events reach `Foostats::Aggregator`, which counts requests per protocol, records unique visitors for the Gemtext and Atom feeds, and remembers page-level IP sets. `Foostats::FileOutputter` writes the result as gzipped JSON files—one per day and per protocol—with IPv4/IPv6 splits, filtered counters, feed readership, and hashes for long URLs.

### Aggregation and output

Foostats also merges the stats from both hosts, master and standby. For the master-standby setup description, read:

[KISS high-availability with OpenBSD](./2024-04-01-KISS-high-availability-with-OpenBSD.md)  

Those gz files land in `stats/`. From there, `Foostats::Replicator` can pull matching files from the partner host (`fishfinger` or `blowfish`) so the view covers both servers, `Foostats::Merger` combines them into daily summaries, and `Foostats::Reporter` rebuilds Gemtext and HTML reports.

[https://blowfish.buetow.org/foostats/](https://blowfish.buetow.org/foostats/)  
[https://fishfinger.buetow.org/foostats/](https://fishfinger.buetow.org/foostats/)  

These are the 30-day reports generated:

[stats.foo.zone Gemini capsule dashboard](gemini://stats.foo.zone)  
[stats.foo.zone HTTP dashboard](https://stats.foo.zone)  

### Command-line entry points

`foostats_main` is the command entry point. `--parse-logs` refreshes the gz files, `--replicate` runs the cross-host sync, and `--report` rebuilds the HTML and Gemini report pages. `--all` performs everything in one go. Defaults point to `/var/www/htdocs/buetow.org/self/foostats` for data, `/var/gemini/stats.foo.zone` for Gemtext output, and `/var/www/htdocs/gemtexter/stats.foo.zone` for HTML output. Replication always forces the three most recent days worth of the data across HTTPS and leaves older files untouched to save bandwidth.

`fooodds.txt` is a plain text list of substrings of URLs to be blocked, making it quick to shut down web crawlers. Foostats also detects rapid requests (an indicator of excessive crawling) and blocks the IP. Audit lines are written to `/var/log/fooodds`, which can later be reviewed for false positives (I do this around once a month). The `Justfile` even has a `gather-fooodds` task that collects suspicious paths from remote logs so new patterns can be added quickly.

The complete source lives on Codeberg here:

[foostats on Codeberg](https://codeberg.org/snonux/foostats)  

Now let's go to some new Perl features:  

## Packages as real blocks

### Scoped packages

Recent Perl versions allow the block form `package Foo { ... }`. Foostats uses it for every package. Imports stay local to the block, helper subs do not leak into the global symbol table, and configuration happens where the code needs it.

## Postfix deref keeps data structures tidy

### Clear dereferencing

The script handles nested hashes and arrays. Postfix dereferencing (`$hash->%*`, `$array->@*`) keeps that readable.

### Simpler merge loops

Loops like `$stats->{page_ips}->{urls}->%*` or `$merge{$key}->{$_}->%*` show which level of the structure is in play. The merger updates host and URL statistics without building temporary arrays, and the reporter code mirrors the layout of the final tables. Before postfix deref, the same code relied on braces within braces and was harder to read.

## Lexical subs promote local reasoning

### Helpers that stay local

Lexical subroutines keep helpers close to the code that needs them. In `Foostats::Logreader::parse_web_logs`, functions such as `my sub parse_date` and `my sub open_file` live only inside that scope.

## Ref aliasing makes intent explicit

### Shared data on purpose

Ref aliasing is enabled with `use feature qw(refaliasing)` and helps communicate intent more clearly. The filter starts with `\my $uri_path = \$event->{uri_path}` so any later modification touches the original event.

The aggregator aliases `$self->{stats}{$date_key}` before updating counters, so the structure remains intact. Combined with subroutine signatures, this makes it obvious when a piece of data is shared instead of copied, preventing silent bugs.

## Persistent state without globals

A Perl state variable is declared with `state $var` and retains its value between calls to the enclosing subroutine. Foostats uses that for rate limiting and deduplicated logging.

### Rate limiting state

`state` variables store run-specific state without using package globals. `state %blocked` remembers IP hashes that already triggered the odd-request filter, and `state $last_time` and `state %count` track how many requests an IP makes in the exact second. Hash and array state variables have been supported since `state` arrived in Perl 5.10, so this code takes advantage of that long-standing capability. However, what's new is that hashes can now also be state variables.

### Deduplicated logging

`state %dedup` keeps the log output to one warning per URI. Early versions utilised global hashes for the same tasks, producing inconsistent results during tests. Switching to `state` removed those edge cases.

## Subroutine signatures clarify every call site

Perl now supports subroutine signatures like other modern languages do. Foostats uses them everywhere.

### "normal" subroutine signatures now

Subroutine signatures are active throughout foostats. Constructors declare `sub new ($class, $odds_file, $log_path)`, anonymous callbacks expose `sub ($event)`, and helper subs list the values they expect.

## Defined-or assignment keeps defaults obvious

### Defaults without boilerplate

The operator `//=` keeps configuration and counters simple. Environment variables may be missing when cron runs the script, so `//=`, combined with signatures, sets defaults without warnings. 

## `say` is the default voice now

`say` became the default once the script switched to `use v5.38;`. Log messages such as "Processing $path" or "Writing report to $report_path". It adds a newline to every message printed, comparable to Ruby's `put`.

## Cleanup with `defer`

Even though not used in Foostats, this (borrowed from Go?) feature is neat to have in Perl now.

The `defer` block (`use feature 'defer"`) schedules a piece of code to run when the current scope exits, regardless of how it exits (e.g. normal return, exception). This is perfect for ensuring resources, such as file handles, are closed. `Foostats::Logreader` uses it to make sure log files are always closed, even if parsing fails mid-way.

```perl
use feature qw(defer);

sub parse_log_file {
    my ($path) = @_;
    open my $fh, '<', $path or die "Cannot open $path: $!";
    defer { close $fh };

    while (my $line = <$fh>) {
        # ... parsing logic that might throw an exception ...
    }
    # $fh is automatically closed here
}
```

This pattern replaces manual `close` calls in every exit path of the subroutine and is more robust than relying solely on object destructors.

## Builtins and booleans

The script also utilises other modern additions that often go unnoticed. `use builtin qw(true false);` combined with `experimental::builtin` provides more real boolean values.

## Conclusion

I want to code more in Perl again. The newer features make it a joy to write small scripts like Foostats. If you haven't looked at Perl in a while, give it another try! The main thing which holds me back from writing more Perl is the lack of good tooling. For example, there is no proper LSP and tree sitter support available, which would work as well as for Go and Ruby.

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other related posts are:

[2023-05-01 Unveiling `guprecords.raku`: Global Uptime Records with Raku](./2023-05-01-unveiling-guprecords:-uptime-records-with-raku.md)  
[2022-05-27 Perl is still a great choice](./2022-05-27-perl-is-still-a-great-choice.md)  
[2011-05-07 Perl Daemon (Service Framework)](./2011-05-07-perl-daemon-service-framework.md)  
[2008-06-26 Perl Poetry](./2008-06-26-perl-poetry.md)  

[Back to the main site](../)  
