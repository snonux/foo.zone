# Site Reliability Engineering - Part 2: Operational Balance in SRE

> Published at 2023-08-19T00:18:18+03:00

This is the second part of my Site Reliability Engineering (SRE) series. I am currently employed as a Principal Site Reliability Engineer and will try to share what SRE is about in this blog series.

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

## Operational Balance in SRE: Finding the Equilibrium in Reliability and Velocity

Site Reliability Engineering has established itself as more than just a set of best practices or methodologies. Instead, it stands as a beacon of operational excellence, which guides engineering teams through the turbulent waters of modern software development and system management.

In the universe of software production, two fundamental forces are often at odds: The drive for rapid feature release (velocity) and the need for system reliability. Traditionally, the faster teams moved, the more risk was introduced into systems. SRE offers a approach to mitigate these conflicting drives through concepts like error budgets and SLIs/SLOs. These mechanisms offer a tangible metric, allowing teams to quantify how much they can push changes while ensuring they don't compromise system health. Thus, the error budget becomes a balancing act, where teams weigh the trade-offs between innovation and reliability.

An important part of this balance is the dichotomy between operations and coding. According to SRE principles, an engineer should ideally spend an equal amount of time on operations work and coding - 50% on each. This isn't just a random metric; it's a reflection of the value SRE places on both maintaining operational excellence and progressing forward with innovations. This balance ensures that while SREs are solving today's problems, they are also preparing for tomorrow's challenges. 

However, not all operational tasks are equal. SRE differentiates between "ops work" and "toil". While ops work is integral to system maintenance and can provide value, toil represents repetitive, mundane tasks which offer little value in the long run. Recognising and minimising toil is crucial. A culture that allows engineers to drown in toil stifles innovation and growth. Hence, an organisation's approach to toil indicates its operational health and commitment to balance.

A cornerstone of achieving operational balance lies in the tools and processes SREs use. Effective monitoring, observability tools, and ensuring that tools can handle high cardinality data are foundational. These aren't just technical requisites but reflective of an organisational culture prioritising proactive problem-solving. By having systems that effectively flag potential issues before they escalate, SREs can maintain the balance between system stability and forward momentum.

Moreover, operational balance isn't just a technological or process challenge; it's a human one. The health of on-call engineers is as crucial as the health of the services they manage. On-call postmortems, continuous feedback loops, and recognising gaps (be it tooling, operational expertise, or resources) ensure that the human elements of operations are noticed. 

In conclusion, operational balance in SRE isn't static thing but an ongoing journey. It requires organisations to constantly evaluate their practices, tools, and, most importantly, their culture. By achieving this balance, organisations can ensure that they have time for innovation while maintaining the robustness and reliability of their systems, resulting in sustainable long-term success.

That all sounds very romantic. The truth is, it's brutal to archive the perfect balance. No system will ever be perfect. But at least we should aim for it!

Continue with the third part of this series:

<< template::inline::index site-reliability-engineering-part-3

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
