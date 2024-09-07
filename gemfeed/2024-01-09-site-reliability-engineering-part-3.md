# Site Reliability Engineering - Part 3: On-Call Culture

> Published at 2024-01-09T18:35:48+02:00

Welcome to Part 3 of my Site Reliability Engineering (SRE) series. I'm currently working as a Site Reliability Engineer, and I’m here to share what SRE is all about in this blog series.

[2023-08-18 Site Reliability Engineering - Part 1: SRE and Organizational Culture](./2023-08-18-site-reliability-engineering-part-1.md)  
[2023-11-19 Site Reliability Engineering - Part 2: Operational Balance](./2023-11-19-site-reliability-engineering-part-2.md)  
[2024-01-09 Site Reliability Engineering - Part 3: On-Call Culture (You are currently reading this)](./2024-01-09-site-reliability-engineering-part-3.md)  
[2024-09-07 Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers](./2024-09-07-site-reliability-engineering-part-4.md)  

```
                    ..--""""----..                 
                 .-"   ..--""""--.j-.              
              .-"   .-"        .--.""--..          
           .-"   .-"       ..--"-. \/    ;         
        .-"   .-"_.--..--""  ..--'  "-.  :         
      .'    .'  /  `. \..--"" __ _     \ ;         
     :.__.-"    \  /        .' ( )"-.   Y          
     ;           ;:        ( )     ( ).  \         
   .':          /::       :            \  \        
 .'.-"\._   _.-" ; ;      ( )    .-.  ( )  \       
  "    `."""  .j"  :      :      \  ;    ;  \      
    bug /"""""/     ;      ( )    "" :.( )   \     
       /\    /      :       \         \`.:  _ \    
      :  `. /        ;       `( )     (\/ :" \ \   
       \   `.        :         "-.(_)_.'   t-'  ;  
        \    `.       ;                    ..--":  
         `.    `.     :              ..--""     :  
           `.    "-.   ;       ..--""           ;  
             `.     "-.:_..--""            ..--"   
               `.      :             ..--""        
                 "-.   :       ..--""              
                    "-.;_..--""                    

```

## Putting Well-being First

Site Reliability Engineering is all about keeping systems reliable, but we often forget how important the human side is. A healthy on-call culture is just as crucial as any technical fix. The well-being of the engineers really matters.

First off, a healthy on-call rotation is about more than just handling incidents. It's about creating a supportive ecosystem. This means cutting down on pain points, offering mentorship, quickly iterating on processes, and making sure engineers have the right tools. But there's a catch—engineers need to be willing to learn. Especially in on-call rotations where SREs work with Software Engineers or QA Engineers, it can be tough to get everyone motivated. QA Engineers want to test, Software Engineers want to build new features; they don’t want to deal with production issues. This can be really frustrating for the SREs trying to mentor them.

Plus, measuring a good on-call experience isn't always clear-cut. You might think fewer pages mean a better on-call setup—and yeah, no one wants to get paged after hours—but it's not just about the number of pages. Trust, ownership, accountability, and solid communication are what really matter.

A key part is giving feedback about the on-call experience to keep learning and improving. If alerts are mostly noise, they need to be tweaked or even ditched. If alerts are helpful, can we automate the repetitive tasks? If there are knowledge gaps, is the documentation lacking? Regular retrospectives ensure that the systems get better over time and the on-call experience improves for the engineers.

Getting new team members ready for on-call duties is super important for keeping systems reliable and efficient. This means giving them the knowledge, tools, and support they need to handle incidents with confidence. It starts with a rundown of the system architecture and common issues, then training on monitoring tools, alerting systems, and incident response protocols. Watching experienced on-call engineers in action can provide some hands-on learning. Too often, though, new engineers get thrown into the deep end without proper onboarding because the more experienced engineers are too busy dealing with ongoing production issues.

A culture where everyone's always on and alert can cause burnout. Engineers need to know their limits, take breaks, and ask for help when they need it. This isn't just about personal health; a burnt-out engineer can drag down the whole team and the systems they manage. A good on-call culture keeps systems running while making sure engineers are happy, healthy, and supported. Experienced engineers should take the time to mentor juniors, but junior engineers should also stay engaged, investigate issues, and learn new things on their own.

For junior engineers, it's tempting to always ask the experts for help whenever something goes wrong. While that might seem reasonable, constantly handing out solutions doesn't scale—there are endless ways for production systems to break. So, every engineer needs to learn how to debug, troubleshoot, and resolve incidents on their own. The experts should be there for guidance and can step in when a junior gets really stuck, but they also need to give space for less experienced engineers to grow and learn.

A blameless on-call culture is essential for creating a safe and collaborative environment where engineers can handle incidents without worrying about getting blamed. It recognizes that mistakes are just part of learning and innovating. When people know they won’t be punished for errors, they’re more likely to talk openly about what went wrong, which helps the whole team learn and improve. Plus, a blameless culture boosts psychological safety, job satisfaction, and reduces burnout, keeping everyone committed and engaged.

Mistakes are gonna happen, which is why having a blameless on-call culture is so important.

Continue with the fourth part of this series:

[2024-09-07 Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers](./2024-09-07-site-reliability-engineering-part-4.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
