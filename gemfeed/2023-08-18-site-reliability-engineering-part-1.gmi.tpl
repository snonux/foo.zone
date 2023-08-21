# Site Reliability Engineering - Part 1: SRE and Organizational Culture

> Published at 2023-08-18T22:43:47+03:00

The universe of Site Reliability Engineering (SRE) is like an intricate tapestry woven with diverse technology, culture, and personal grit threads. Site Reliability Engineering is one of the most demanding jobs. With all the facets, it's impossible to get bored. There is always a new challenge to master, and there is always a new technology to tinker with. It's not just technical; it's also about communication, collaboration and teamwork. I am currently employed as a Principal Site Reliability Engineer and will try to share what SRE is about in this blog series.

<< template::inline::index site-reliability-engineering-part

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

At the heart of SRE lies the proactive mindset of "prevention over cure." Traditional IT models focused predominantly on reactive solutions, but SRE mandates a shift towards foresight. By adopting Service Level Indicators (SLIs) and Service Level Objectives (SLOs), teams are equipped with clear metrics and goals that guide them toward ensuring reliability and user satisfaction. They reflect an organisational culture prioritising user experience and constant system alignment with user needs. 

Another defining SRE idea concept the "error budget." This ingenious framework accepts that no system is flawless. Failures are inevitable. However, instead of being punitive, the culture here is to accept, learn, and iterate. By providing teams with a "budget" for errors, organisations create an environment where innovation is encouraged, and failures are viewed as learning opportunities.

But SRE isn't just about technology and metrics; it's deeply human. It challenges the "hero culture" that plagues many IT teams. While individual heroics might occasionally save the day, a sustainable model requires collective expertise. An SRE culture recognises that heroes achieve their best within teams, negating the need for a hero-centric environment. This philosophy promotes a balanced on-call experience, emphasising the importance of trust, ownership, effective communication, and collaboration as cornerstones of team success. I personally have fallen into the hero trap, and know it's unsustainable to be the only go-to person for every problem.

Additionally, the SRE model requires good documentation. However, it's essential ensuring that this documentation undergoes the same quality checks as code, reinforcing effective onboarding, training and communication.

Organisations might face a significant challenge when adopting SRE. Some might feel SRE principles counter their goals. They might prioritise feature rollouts over reliability or view SRE practices as cumbersome. Hence, creating an SRE culture often demands patient explanations and showcasing benefits, such as increased release velocity and improved user experience.

Monitoring and observability form another SRE aspect, emphasising the need for high-quality tools to query and analyse data. This ties back to the cultural emphasis on continuous learning and adaptability. SREs, by nature, need to be curious, ready to delve into anomalies, and keen on adopting new tools and practices. 

The success of SRE within any organisation depends on the broader acceptance of its principles. It demands a move away from siloed operations, where SRE acts as a bandage on flawed systems, to a model where reliability is everyone's responsibility.

In essence, the integration of SRE principles transcends technical practices. It paves the way for a shift in organisational culture that values proactive prevention, continuous learning, collaboration, and transparent communication. The successful melding of SRE and corporate culture promises not just reliable systems but also a robust, resilient, and progressive work environment.

Organisations with the implementation of SLIs, SLOs and error budgets are already advanced in their SRE journey. It takes a lot of communication, convincing, and patience until that point is reached.

Continue with the second part of this series:

<< template::inline::index site-reliability-engineering-part-2

E-Mail your comments to paul at buetow.org :-)

=> ../ Back to the main site
