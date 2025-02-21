# Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers

> Published at 2024-09-07T16:27:58+03:00

Welcome to Part 4 of my Site Reliability Engineering (SRE) series. I'm currently working as a Site Reliability Engineer, and I’m here to share what SRE is all about in this blog series.

<< template::inline::index site-reliability-engineering-part

```
       __..._   _...__
  _..-"      `Y`      "-._
  \ Once upon |           /
  \\  a time..|          //
  \\\         |         ///
   \\\ _..---.|.---.._ ///
jgs \\`_..---.Y.---.._`//	
```

This time, I want to share some tips on how to onboard software engineers, QA engineers, and Site Reliability Engineers (SREs) to the primary on-call rotation. Traditionally, onboarding might take half a year (depending on the complexity of the infrastructure), but with a bit of strategy and structured sessions, we've managed to reduce it to just six weeks per person. Let's dive in!

## Setting the Scene: Tier-1 On-Call Rotation

First things first, let's talk about Tier-1. This is where the magic begins. Tier-1 covers over 80% of the common on-call cases and is the perfect breeding ground for new on-call engineers to get their feet wet. It's designed to be manageable training ground.

### Why Tier-1?

* Easy to Understand: Every on-call engineer should be familiar with Tier-1 tasks. 
* Training Ground: This is where engineers start their on-call career. It's purposefully kept simple so that it's not overwhelming right off the bat.
* Runbook/recipe driven: Every alert is attached to a comprehensive runbook, making it easy for every engineer to follow.

## Onboarding Process: From 6 Months to 6 Weeks

So how did we cut down the onboarding time so drastically? Here’s the breakdown of our process:

Knowledge Transfer (KT) Sessions: We kicked things off with more than 10 KT sessions, complete with video recordings. These sessions are comprehensive and cover everything from the basics to some more advanced topics. The recorded sessions mean that new engineers can revisit them anytime they need a refresher.

Shadowing Sessions: Each new engineer undergoes two on-call week shadowing sessions. This hands-on experience is invaluable. They get to see real-time incident handling and resolution, gaining practical knowledge that's hard to get from just reading docs.

Comprehensive Runbooks: We created 64 runbooks (by the time writing this probably more than 100) that are composable like Lego bricks. Each runbook covers a specific scenario and guides the engineer step-by-step to resolution. Pairing these with monitoring alerts linked directly to Confluence docs, and from there to the respective runbooks, ensures every alert can be navigated with ease (well, there are always exceptions to the rule...).

Self-Sufficiency & Confidence Building:  With all these resources at their fingertips, our on-call engineers become self-sufficient for most of the common issues they'll face (new starters can now handle around 80% of the most common issue after 6 weeks they had joined the company). This boosts their confidence and ensures they can handle Tier-1 incidents independently.

Documentation and Feedback Loop: Continuous improvement is key. We regularly update our documentation based on feedback from the engineers. This makes our process even more robust and user-friendly.

## It's All About the Tiers

Let’s briefly touch on the Tier levels:

* Tier 1: Easy and foundational tasks. Perfect for getting new engineers started. This covers around 80% of all on-call cases we face. This is what we trained on.
* Tier 2: Slightly more complex, requiring more background knowledge. We trained on some of the topics but not all.
* Tier 3: Requires a good understanding of the platform/architecture. Likely needs KT sessions with domain experts.
* Tier DE (Domain Expert): The heavy hitters. Domain experts are required for these tasks. 

### Growing into Higher Tiers

From Tier-1, engineers naturally grow into Tier-2 and beyond. The structured training and gradual increase in complexity help ensure a smooth transition as they gain experience and confidence. The key here is that engineers stay curous and engaged in the on-call, so that they always keep learning.

## Keeping Runbooks Up to Date

It is important that runbooks are not a "project to be finished"; runbooks have to be maintained and updated over time. Sections may change, new runbooks need to be added, and old ones can be deleted. So the acceptance criteria of an on-call shift would not just be reacting to alerts and incidents, but also reviewing and updating the current runbooks.

## Conclusion

By structuring the onboarding process with KT sessions, shadowing, comprehensive runbooks, and a feedback loop, we've been able to fast-track the process from six months to just six weeks. This not only prepares our engineers for the on-call rotation quicker but also ensures they're confident and capable when handling incidents.

If you're looking to optimize your on-call onboarding process, these strategies could be your ticket to a more efficient and effective transition. Happy on-calling!

=> ../ Back to the main site
