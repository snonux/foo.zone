# Site Reliability Engineering - Part 1: SRE and Organizational Culture

> Published at 2023-08-18T22:43:47+03:00

Being a Site Reliability Engineer (SRE) is like stepping into a lively, ever-evolving universe. The world of SRE mixes together different tech, a unique culture, and a whole lot of determination. It’s one of the toughest but most exciting jobs out there. There's zero chance of getting bored because there's always a fresh challenge to tackle and new technology to play around with. It's not just about the tech side of things either; it's heavily rooted in communication, collaboration, and teamwork. As someone currently working as an SRE, I’m here to break it all down for you in this blog series. Let's dive into what SRE is really all about!

[2023-08-18 Site Reliability Engineering - Part 1: SRE and Organizational Culture (You are currently reading this)](./2023-08-18-site-reliability-engineering-part-1.md)  
[2023-11-19 Site Reliability Engineering - Part 2: Operational Balance in SRE](./2023-11-19-site-reliability-engineering-part-2.md)  
[2024-01-09 Site Reliability Engineering - Part 3: On-Call Culture and the Human Aspect](./2024-01-09-site-reliability-engineering-part-3.md)  

```
▓▓▓▓░░                                                                                  
                                                                                          
DC on fire:
                                                                                          
                ▓▓                                    ▓▓                ▓▓                
      ░░  ░░    ▓▓▓▓                  ██                  ░░            ▓▓▓▓        ▓▓    
    ▓▓░░░░  ░░  ▓▓▓▓                              ▓▓░░                  ▓▓▓▓              
    ░░░░      ▓▓▓▓▓▓        ▓▓      ▓▓            ▓▓                  ▓▓▓▓▓▓      ▓▓      
    ▓▓░░    ▓▓▒▒▒▒▓▓▓▓    ▓▓        ▓▓▓▓        ▓▓▓▓▓▓              ▓▓▒▒▒▒▓▓▓▓    ▓▓▓▓    
  ██▓▓      ▓▓▒▒░░▒▒▓▓  ▓▓██      ▓▓▓▓▓▓        ▓▓▒▒▓▓              ▓▓▒▒░░▒▒▓▓  ██▓▓▓▓    
  ▓▓▓▓██  ▓▓▒▒░░░░▒▒▓▓  ▓▓▓▓      ▓▓▒▒▒▒▓▓    ▓▓▒▒░░▒▒▓▓██▓▓      ▓▓▒▒░░░░▒▒▓▓  ▓▓▒▒▒▒▓▓  
  ▓▓▒▒▒▒▓▓▓▓▒▒░░▒▒▓▓▓▓▓▓▒▒▒▒▓▓  ▓▓▓▓░░▒▒▓▓    ▓▓▒▒░░▒▒▓▓▒▒▒▒▓▓    ▓▓▒▒░░▒▒▓▓▓▓▓▓▓▓░░▒▒▓▓  
  ▒▒░░▒▒▓▓▓▓▒▒░░▒▒▓▓▓▓▒▒░░▒▒▓▓  ▓▓▒▒░░▒▒▓▓    ▓▓░░░░▒▒▒▒░░░░▒▒██████▒▒░░▒▒██▓▓▓▓▒▒░░▒▒▓▓██
  ░░░░▒▒▓▓▒▒░░▒▒▓▓▓▓▓▓▒▒░░▒▒▓▓██▒▒░░░░▒▒▓▓  ▓▓▒▒░░▒▒▓▓▒▒▒▒░░▒▒▓▓▓▓▒▒░░▒▒▓▓▓▓▓▓▒▒░░░░▒▒▓▓▓▓
  ░░░░▒▒▓▓▒▒░░░░▓▓██▒▒░░░░▒▒▓▓██▒▒░░░░▒▒██▓▓▓▓▒▒░░▒▒▓▓▓▓▒▒░░░░▒▒▓▓▒▒░░░░██▓▓▓▓▒▒░░░░▒▒████
  ▒▒░░▒▒▓▓▓▓░░░░▒▒▓▓▒▒▒▒░░░░▒▒▓▓▓▓▒▒░░░░▒▒▓▓▓▓▒▒░░░░▒▒▓▓▒▒░░▒▒▓▓▓▓▓▓░░░░▒▒▓▓▓▓▓▓▒▒░░░░▒▒▓▓
  ▒▒░░▒▒▓▓▒▒▒▒░░▒▒██▒▒▒▒░░▒▒▒▒██▒▒▒▒░░░░░░▒▒▓▓▒▒░░░░▒▒▒▒░░░░▒▒████▒▒▒▒░░▒▒██▓▓▒▒▒▒░░░░░░▒▒
  ░░░░░░▒▒░░░░░░░░▒▒▒▒▒▒░░░░▒▒▒▒▒▒░░░░░░░░▒▒▒▒░░░░░░▒▒▒▒░░░░░░▒▒▒▒░░░░░░░░▒▒▒▒▒▒░░░░░░░░▒▒
  ░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░
```

## SRE and Organizational Culture: Navigating the Nexus

At the core of SRE is the principle of "prevention over cure." Unlike traditional IT setups that mostly react to problems, SRE focuses on spotting issues before they happen. This proactive approach involves using Service Level Indicators (SLIs) and Service Level Objectives (SLOs). These tools give teams specific metrics and targets to aim for, helping them keep systems reliable and users happy. It's all about creating a culture that prioritizes user experience and makes sure everything runs smoothly to meet their needs.

Another key concept in SRE is the "error budget." It’s a clever approach that recognizes no system is perfect and that failures will happen. Instead of punishing mistakes, SRE culture embraces them as chances to learn and improve. The idea is to give teams a "budget" for errors, creating a space where innovation can thrive and failures are simply seen as lessons learned.

SRE isn't just about tech and metrics; it's also about people. It tackles the "hero culture" that often ends up burning out IT teams. Sure, having a hero swoop in to save the day can be great, but relying on that all the time just isn’t sustainable. Instead, SRE focuses on collective expertise and teamwork. It recognizes that heroes are at their best within a solid team, making the need for constant heroics unnecessary. This way of thinking promotes a balanced on-call experience and highlights trust, ownership, good communication, and collaboration as key to success. I've been there myself, falling into the hero trap, and I know firsthand that it's just not feasible to be the go-to person for every problem that comes up.

Also, the SRE model puts a big emphasis on good documentation. It's not enough to just have docs; they need to be top-notch and go through the same quality checks as code. This really helps with onboarding new team members, training, and keeping everyone on the same page.

Adopting SRE can be a big challenge for some organizations. They might think the SRE approach goes against their goals, like preferring to roll out new features quickly rather than focusing on reliability, or seeing SRE practices as too much hassle. Building an SRE culture often means taking the time to explain things patiently and showing the benefits, like faster release cycles and a better user experience.

Monitoring and observability are also big parts of SRE, highlighting the need for top-notch tools to query and analyze data. This aligns with the SRE focus on continuous learning and being adaptable. SREs naturally need to be curious, ready to dive into any strange issues, and always open to picking up new tools and practices.

For SRE to really work in any organization, everyone needs to buy into its principles. It's about moving away from working in isolated silos and relying on SRE to just patch things up. Instead, it’s about making reliability a shared responsibility across the whole team.

In short, bringing SRE principles into the mix goes beyond just the technical stuff. It helps shift the whole organizational culture to value things like preventing issues before they happen, always learning, working together, and being open with communication. When SRE and corporate culture blend well, you end up with not just reliable systems but also a strong, resilient, and forward-thinking workplace.

Organizations that have SLIs, SLOs, and error budgets in place are already pretty far along in their SRE journey. Getting there takes a lot of communication, convincing people, and patience.

Continue with the second part of this series:

[2023-11-19 Site Reliability Engineering - Part 2: Operational Balance in SRE](./2023-11-19-site-reliability-engineering-part-2.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
