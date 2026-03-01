# Working with an SRE Interview

> Published at 2025-01-15T00:16:04+02:00

I have been interviewed by Florian Buetow on `cracking-ai-engineering.com` about what it's like working with a Site Reliability Engineer from the point of view of a Software Engineer, Data Scientist, and AI Engineer.

=> https://www.cracking-ai-engineering.com/writing/2025/01/12/working-with-an-sre-interview/ See original interview here
=> https://www.cracking-ai-engineering.com Cracking AI Engineering

Below, I am posting the interview here on my blog as well.

<< template::inline::toc

## Preamble 

In this insightful interview, Paul Bütow, a Principal Site Reliability Engineer at Mimecast, shares over a decade of experience in the field. Paul highlights the role of an Embedded SRE, emphasizing the importance of automation, observability, and effective incident management. We also focused on the key question of how you can work effectively with an SRE weather you are an individual contributor or a manager, a software engineer or data scientist. And how you can learn more about site reliability engineering.

## Introducing Paul

Hi Paul, please introduce yourself briefly to the audience. Who are you, what do you do for a living, and where do you work?

> My name is Paul Bütow, I work at Mimecast, and I’m a Principal Site Reliability Engineer there. I’ve been with Mimecast for almost ten years now. The company specializes in email security, including things like archiving, phishing detection, malware protection, and spam filtering.

You mentioned that you’re an ‘Embedded SRE.’ What does that mean exactly?

> It means that I’m directly part of the software engineering team, not in a separate Ops department. I ensure that nothing is deployed manually, and everything runs through automation. I also set up monitoring and observability. These are two distinct aspects: monitoring alerts us when something breaks, while observability helps us identify trends. I also create runbooks so we know what to do when specific incidents occur frequently.

> Infrastructure SREs on the other hand handle the foundational setup, like providing the Kubernetes cluster itself or ensuring the operating systems are installed. They don't work on the application directly but ensure the base infrastructure is there for others to use. This works well when a company has multiple teams that need shared infrastructure.

## How did you get started?

How did your interest in Linux or FreeBSD start?

> It began during my school days. We had a PC with DOS at home, and I eventually bought Suse Linux 5.3. Shortly after, I discovered FreeBSD because I liked its handbook so much. I wanted to understand exactly how everything worked, so I also tried Linux from Scratch. That involves installing every package manually to gain a better understanding of operating systems.

=> https://www.FreeBSD.org
=> https://linuxfromscratch.org/

And after school, you pursued computer science, correct?

> Exactly. I wasn’t sure at first whether I wanted to be a software developer or a system administrator. I applied for both and eventually accepted an offer as a Linux system administrator. This was before 'SRE' became a buzzword, but much of what I did back then-automation, infrastructure as code, monitoring-is now considered part of the typical SRE role.

## Roles and Career Progression

Tell us about how you joined Mimecast. When did you fully embrace the SRE role?

> I started as a Linux sysadmin at 1&1. I managed an ad server farm with hundreds of systems and later handled load balancers. Together with an architect, we managed F5 load balancers distributing around 2,000 services, including for portals like web.de and GMX. I also led the operations team technically for a while before moving to London to join Mimecast.

> At Mimecast, the job title was explicitly 'Site Reliability Engineer.' The biggest difference was that I was no longer in a separate Ops department but embedded directly within the storage and search backend team. I loved that because we could plan features together-from automation to measurability and observability. Mimecast also operates thousands of physical servers for email archiving, which was fascinating since I already had experience with large distributed systems at 1&1. It was the right step for me because it allowed me to work close to the code while remaining hands-on with infrastructure.

What are the differences between SRE, DevOps, SysAdmin, and Architects?

> SREs are like the next step after SysAdmins. A SysAdmin might manually install servers, replace disks, or use simple scripts for automation, while SREs use infrastructure as code and focus on reliability through SLIs, SLOs, and automation. DevOps isn’t really a job-it’s more of a way of working, where developers are involved in operations tasks like setting up CI/CD pipelines or on-call shifts. Architects focus on designing systems and infrastructures, such as load balancers or distributed systems, working alongside SREs to ensure the systems meet the reliability and scalability requirements. The specific responsibilities of each role depend on the company, and there is often overlap. 

What are the most important reliability lessons you’ve learned so far?

* Don’t leave SRE aspects as an afterthought. It’s much better to discuss automation, monitoring, SLIs, and SLOs early on. Traditional sysadmins often installed systems manually, but today, we do everything via infrastructure as code-using tools like Terraform or Puppet.
* I also distinguish between monitoring and observability. Monitoring tells us, 'The server is down, alarm!' Observability dives deeper, showing trends like increasing latency so we can act proactively.
* SLI, SLO, and SLA are core elements. We focus on what users actually experience-for example, how quickly an email is sent-and set our goals accordingly.
* Runbooks are also crucial. When something goes wrong at night, you don’t want to start from scratch. A runbook outlines how to debug and resolve specific problems, saving time and reducing downtime.

## Anecdotes and Best Practices

Runbooks sound very practical. Can you explain how they’re used day-to-day?

> Runbooks are essentially guides for handling specific incidents. For instance, if a service won’t start, the runbook will specify where the logs are and which commands to use. Observability takes it a step further, helping us spot changes early-like rising error rates or latency-so we can address issues before they escalate.

When should you decide to put something into a runbook, and when is it unnecessary?

> If an issue happens frequently, it should be documented in a runbook so that anyone, even someone new, can follow the steps to fix it. The idea is that 90% of the common incidents should be covered. For example, if a service is down, the runbook would specify where to find logs, which commands to check, and what actions to take. On the other hand, rare or complex issues, where the resolution depends heavily on context or varies each time, don’t make sense to include in detail. For those, it’s better to focus on general troubleshooting steps. 

How do you search for and find the correct runbooks?

> Runbooks should be linked directly in the alert you receive. For example, if you get an alert about a service not running, the alert will have a link to the runbook that tells you what to check, like logs or commands to run. Runbooks are best stored in an internal wiki, so if you don’t find the link in the alert, you know where to search. The important thing is that runbooks are easy to find and up to date because that’s what makes them useful during incidents. 

Do you have an interesting war story you can share with us?

> Sure. At 1&1, we had a proprietary ad server software that ran a SQL query during startup. The query got slower over time, eventually timing out and preventing the server from starting. Since we couldn’t access the source code, we searched the binary for the SQL and patched it. By pinpointing the issue, a developer was able to adjust the SQL. This collaboration between sysadmin and developer perspectives highlights the value of SRE work.

## Working with Different Teams

You’re embedded in a team-how does collaboration with developers work practically?

> We plan everything together from the start. If there’s a new feature, we discuss infrastructure, automated deployments, and monitoring right away. Developers are experts in the code, and I bring the infrastructure expertise. This avoids unpleasant surprises before going live.

How about working with data scientists or ML engineers? Are there differences?

> The principles are the same. ML models also need to be deployed and monitored. You deal with monitoring, resource allocation, and identifying performance drops. Whether it’s a microservice or an ML job, at the end of the day, it’s all running on servers or clusters that must remain stable.

What about working with managers or the FinOps team?

> We often discuss costs, especially in the cloud, where scaling up resources is easy. It’s crucial to know our metrics: do we have enough capacity? Do we need all instances? Or is the CPU only at 5% utilization? This data helps managers decide whether the budget is sufficient or if optimizations are needed.

Do you have practical tips for working with SREs?

> Yes, I have a few:

* Early involvement: Include SREs from the beginning in your project.
* Runbooks & documentation: Document recurring errors.
* Try first: Try to understand the issue yourself before immediately asking the SRE.
* Basic infra knowledge: Kubernetes and Terraform aren’t magic. Some basic understanding helps every developer.

## Using AI Tools

Let’s talk about AI. How do you use it in your daily work?

> For boilerplate code, like Terraform snippets, I often use ChatGPT. It saves time, although I always review and adjust the output. Log analysis is another exciting application. Instead of manually going through millions of lines, AI can summarize key outliers or errors.

Do you think AI could largely replace SREs or significantly change the role?

> I see AI as an additional tool. SRE requires a deep understanding of how distributed systems work internally. While AI can assist with routine tasks or quickly detect anomalies, human expertise is indispensable for complex issues.

## SRE Learning Resources

What resources would you recommend for learning about SRE?

> The Google SRE book is a classic, though a bit dry. I really like 'Seeking SRE,' as it offers various perspectives on SRE, with many practical stories from different companies.

=> https://sre.google/books/
=> https://www.oreilly.com/library/view/seeking-sre/9781491978856 Seeking SRE

Do you have a podcast recommendation?

> The Google SRE prodcast is quite interesting. It offers insights into how Google approaches SRE, along with perspectives from external guests.

=> https://sre.google/prodcast/

## Blogging

You also have a blog. What motivates you to write regularly?

> Writing helps me learn the most. It also serves as a personal reference. Sometimes I look up how I solved a problem a year ago. And of course, others tackling similar projects might find inspiration in my posts.

What do you blog about?

> Mostly technical topics I find exciting, like homelab projects, Kubernetes, or book summaries on IT and productivity. It’s a personal blog, so I write about what I enjoy.

## Wrap-up

To wrap up, what are three things every team should keep in mind for stability?

> First, maintain runbooks and documentation to avoid chaos at night. Second, automate everything-manual installs in production are risky. Third, define SLIs, SLOs, and SLAs early so everyone knows what we’re monitoring and guaranteeing.

Is there a motto or mindset that particularly inspires you as an SRE?

> "Keep it simple and stupid"-KISS. Not everything has to be overly complex. And always stay curious. I’m still fascinated by how systems work under the hood.

Where can people find you online?

> You can find links to my socials on my website paul.buetow.org
> I regularly post articles and link to everything else I’m working on outside of work.

=> https://paul.buetow.org

Thank you very much for your time and this insightful interview into the world of site reliability engineering

> My pleasure, this was fun.

## Closing comments

Dear reader, I hope this conversation with Paul Bütow provided an exciting peak into the world of Site Reliability Engineering. Whether you’re a software developer, data scientist, ML engineer, or manager, reliable systems are always a team effort. Hopefully, you’ve taken some insights or tips from Paul’s experiences for your own team or next project. Thanks for joining us, and best of luck refining your own SRE practices!

E-Mail your comments to `paul@nospam.buetow.org` or contact Florian via the Cracking AI Engineering :-)

=> ../ Back to the main site
