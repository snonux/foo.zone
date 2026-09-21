# Site Reliability Engineering - Part 2: Operational Balance

> Published at 2023-11-19T00:18:18+03:00

This is the second part of my Site Reliability Engineering (SRE) series. I am currently employed as a Site Reliability Engineer and will try to share what SRE is about in this blog series.

<< template::inline::index site-reliability-engineering-part

```
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣾⠿⠿⠿⠶⠾⠿⠿⣿⣿⣿⣿⣿⣿⠿⠿⠶⠶⠿⠿⠿⣷⠀⠀⠀⠀
⠀⠀⠀⣸⢿⣆⠀⠀⠀⠀⠀⠀⠀⠙⢿⡿⠉⠀⠀⠀⠀⠀⠀⠀⣸⣿⡆⠀⠀⠀
⠀⠀⢠⡟⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⣾⣧⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀⢻⡄⠀⠀
⠀⢀⣾⠃⠀⠀⢿⡄⠀⠀⠀⠀⠀⢠⣿⣿⡀⠀⠀⠀⠀⠀⢠⡿⠀⠀⠘⣷⡀⠀
⠀⣼⣏⣀⣀⣀⣈⣿⡀⠀⠀⠀⠀⣸⣿⣿⡇⠀⠀⠀⠀⢀⣿⣃⣀⣀⣀⣸⣧⠀
⠀⢻⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⡿⠀
⠀⠀⠉⠛⠛⠛⠋⠁⠀⠀⠀⠀⢸⣿⣿⣿⣿⡆⠀⠀⠀⠀⠈⠙⠛⠛⠛⠉⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠴⠶⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠶⠦⠀⠀
```

## Balancing reliability and speed

Two forces clash in software production: shipping features fast (velocity) and keeping the system reliable. Traditionally, moving faster meant more risk. SRE balances the two with error budgets and SLIs/SLOs. They tell a team how much they can push changes before it hurts the service.

Balance also means juggling operations and coding. Ideally, an SRE splits the time 50/50 between the two. Otherwise, you're only ever fighting today's fires and never get to the work which prevents tomorrow's.

But not all operations tasks are the same. SRE makes a clear distinction between "ops work" and "toil." Ops work is essential for maintaining systems and adds value, while toil is the repetitive, boring stuff that doesn't. Toil has to be recognized and reduced, otherwise engineers drown in it and nothing new gets built. How an organization handles toil says a lot about its health.

Good monitoring and observability tooling is essential, especially when there's a lot of data. When you can spot issues early, you can keep things stable while still moving forward.

And it's about people. The well-being of the on-call engineers matters as much as the health of the services. Postmortems after incidents and regular feedback about gaps in tools, skills or resources are how the human side gets looked after.

That all sounds pretty idealistic. The reality is that getting the perfect balance is really tough. No system is ever going to be perfect. But hey, we should still strive for it!

Continue with the third part of this series:

<< template::inline::index site-reliability-engineering-part-3

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
