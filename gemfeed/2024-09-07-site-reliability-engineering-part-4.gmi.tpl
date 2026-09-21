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

This time, I want to share some tips on how to onboard software engineers, QA engineers, and Site Reliability Engineers (SREs) to the primary on-call rotation. Onboarding used to take around half a year (depending on the infrastructure). With some structure, we got it down to six weeks per person.

## The Tier-1 on-call rotation

Tier-1 covers over 80% of the common on-call cases. That's where new on-call engineers start.

### Why Tier-1?

* Every on-call engineer should be familiar with the Tier-1 tasks.
* It's kept simple on purpose so that new engineers aren't overwhelmed.
* Every alert links to a runbook.

## From 6 months to 6 weeks

This is how we did it:

Knowledge transfer (KT) sessions: More than 10 of them, all recorded, from the basics to some advanced topics. New engineers can re-watch them whenever they need a refresher.

Shadowing: Each new engineer shadows two on-call weeks. They see real incidents being handled, which you can't learn from reading docs.

Runbooks: We wrote 64 of them (probably more than 100 by the time you read this), composable like Lego bricks. Each covers one scenario step by step. The alerts link to the Confluence docs and from there to the runbooks (well, there are always exceptions to the rule...).

Result: New starters handle around 80% of the common issues on their own after 6 weeks at the company.

Feedback: We update the documentation regularly based on what the new engineers tell us.

## The tiers

Let’s briefly touch on the Tier levels:

* Tier 1: Easy and foundational tasks. Perfect for getting new engineers started. This covers around 80% of all on-call cases we face. This is what we trained on.
* Tier 2: Slightly more complex, requiring more background knowledge. We trained on some of the topics but not all.
* Tier 3: Requires a good understanding of the platform/architecture. Likely needs KT sessions with domain experts.
* Tier DE (Domain Expert): Requires a domain expert.

### Growing into Higher Tiers

From Tier-1, engineers naturally grow into Tier-2 and beyond. The important part is that engineers stay curious and keep learning during on-call.

## Keeping Runbooks Up to Date

It is important that runbooks are not a "project to be finished"; runbooks have to be maintained and updated over time. Sections may change, new runbooks need to be added, and old ones can be deleted. So the acceptance criteria of an on-call shift would not just be reacting to alerts and incidents, but also reviewing and updating the current runbooks.

## Conclusion

That's how we got onboarding down from six months to six weeks: KT sessions, shadowing, runbooks and a feedback loop.

Continue with the fifth part of this series:

<< template::inline::index site-reliability-engineering-part-5

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
