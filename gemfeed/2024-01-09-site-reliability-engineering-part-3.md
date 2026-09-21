# Site Reliability Engineering - Part 3: On-Call Culture

> Published at 2024-01-09T18:35:48+02:00

Welcome to Part 3 of my Site Reliability Engineering (SRE) series. I'm currently working as a Site Reliability Engineer, and I’m here to share what SRE is all about in this blog series.

[2023-08-18 Site Reliability Engineering - Part 1: SRE and Organizational Culture](./2023-08-18-site-reliability-engineering-part-1.md)  
[2023-11-19 Site Reliability Engineering - Part 2: Operational Balance](./2023-11-19-site-reliability-engineering-part-2.md)  
[2024-01-09 Site Reliability Engineering - Part 3: On-Call Culture (You are currently reading this)](./2024-01-09-site-reliability-engineering-part-3.md)  
[2024-09-07 Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers](./2024-09-07-site-reliability-engineering-part-4.md)  
[2026-03-01 Site Reliability Engineering - Part 5: System Design, Incidents, and Learning](./2026-03-01-site-reliability-engineering-part-5.md)  

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

Site Reliability Engineering is all about keeping systems reliable, but we often forget how important the human side is. A healthy on-call culture matters as much as any technical fix.

A healthy on-call rotation is more than handling incidents. It needs mentorship, fewer pain points, processes that get fixed quickly, and the right tools. But engineers also need to be willing to learn. Especially in on-call rotations where SREs work with Software Engineers or QA Engineers, it can be tough to get everyone motivated. QA Engineers want to test, Software Engineers want to build new features; they don’t want to deal with production issues. This can be really frustrating for the SREs trying to mentor them.

Measuring a good on-call experience isn't easy. Fewer pages is nice (nobody wants to get paged after hours), but the number of pages alone doesn't tell you much. Trust, ownership and good communication matter more.

A key part is giving feedback about the on-call experience to keep learning and improving. If alerts are mostly noise, they need to be tweaked or even ditched. If alerts are helpful, can we automate the repetitive tasks? If there are knowledge gaps, is the documentation lacking? Regular retrospectives help here.

New team members need proper onboarding before they go on-call. Start with a rundown of the system architecture and the common issues, then the monitoring and alerting tools and how incidents are handled. Shadowing an experienced on-call engineer for a while helps a lot. Too often, though, new engineers get thrown into the deep end without proper onboarding because the more experienced engineers are too busy dealing with ongoing production issues.

A culture where everyone's always on and alert can cause burnout. Engineers need to know their limits, take breaks, and ask for help when they need it. A burnt-out engineer drags down the whole team and the systems they manage. Experienced engineers should take the time to mentor juniors, but junior engineers should also stay engaged, investigate issues, and learn new things on their own.

For junior engineers, it's tempting to always ask the experts for help whenever something goes wrong. But handing out solutions all the time doesn't scale. There are endless ways for production systems to break. So, every engineer needs to learn how to debug, troubleshoot, and resolve incidents on their own. The experts should be there for guidance and can step in when a junior gets really stuck, but they also need to give space for less experienced engineers to grow and learn.

On-call must be blameless. Mistakes happen, and they are part of learning. When people know they won't be punished for errors, they talk openly about what went wrong, and the whole team learns from it.

Continue with the fourth part of this series:

[2024-09-07 Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers](./2024-09-07-site-reliability-engineering-part-4.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
