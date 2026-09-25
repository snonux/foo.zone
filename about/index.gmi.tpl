<< template::dynamic
# About

* Name: Paul Buetow
* Father, Husband, Computer tinkerer, Yogi, Science fiction lover, cat owner
* Born in: Germany, currently living in: Sofia, Bulgaria
* Profession: Computerist -  Solving problems with computers that we wouldn't have without them
* Current job: Site Reliability Engineer
* Education: Diplom-Informatiker (FH) (Diploma from a German University of Applied Sciences,  before they had international Bachelor and Masters programs)
* E-Mail: `paul@nospam.buetow.org`

=> ./paul.jpg Paul Buetow

<< template::inline::toc

## Now

Stuff I'm currently up to:

<< # Append every not yet completed Taskwarrior task tagged +now as a bullet, oldest first, so the list stays current without editing this file. That is why the page is marked template::dynamic (always regenerated; task changes don't alter this file's mtime). Newlines in descriptions are collapsed to keep one bullet per task.
<< task rc.verbose=nothing +now -COMPLETED -DELETED export | jq -r 'sort_by(.entry)[] | "* " + (.description | gsub("\\s+"; " "))'

## My sites

=> ../ My blog here at foo.zone
=> https://irregular.ninja irregular.ninja - My street photography site (warn: multiple MBs, it's photos after all)
=> https://snonux.foo snonux.foo - My microblog (may be sometimes offline since it runs on my home LAN on Raspberry Pi's)

## Show me the code

=> ./showcase.gmi Project showcase
=> https://github.com/snonux github.com/snonux - My GitHub page
=> https://codeberg.org/snonux codeberg.org/snonux - My Codeberg page (Codeberg LLM policies apply)

## Social Media and Communities

=> https://fosstodon.org/@snonux @snonux@fosstodon.org - Me at Mastodon
=> https://www.linkedin.com/in/paul-buetow-b4857270/ My LinkedIn profile

## Books I've read

=> ./resources.gmi Resources, Technical Books, Podcasts, Courses and Guides I recommend
=> ./novels.gmi Novels I've read

## My gadgets and wishlist

=> ./gadgets.gmi Gadgets I already own
=> ./wishlist.gmi Gadgets I still want

That's all for now...

=> ../ Back to the main site
