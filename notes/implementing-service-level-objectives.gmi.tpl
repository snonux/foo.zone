# "Implementing Service Level Objectives" book notes

These are my personal book notes of Alex Hidalgo's "Implementing Service Level Objectives: A Pratical Guide to SLIs, SLOs, and Error Budgets" They are for myself, but I hope they might be useful to you too.

<< template::inline::toc

## Introduction

Service Level Objectives (SLOs) are a fundamental component in ensuring service reliability, enhancing engineering effectiveness, and aligning organizational goals. Below is a comprehensive guide to understanding and implementing SLOs, focusing on the critical documentation required and the three phases of SLO implementation.

## Importance of Documentation

Documentation Support: Strong documentation is essential in supporting both you and your organization throughout the SLO implementation process. It provides clarity and guidance, making the transition smoother and more efficient.

## Implementation Phases

### The Three Phases of SLO Implementation

* 1. Define the SLO
* 2. Collect the SLOs
* 3. Use the SLO

### Phase 1: Defining SLOs

Strategy Document:

Create a one-page strategy document. This document is vital in the initial 'crawl' phase, outlining what you are trying to achieve, why, and how. It should be concise, allowing anyone to read it in less than ten minutes. It's crucial to get this document right, as it answers:

* What will we get out of creating SLOs?
* How will SLOs improve service reliability?
* How will it help engineering teams?
* Ensure the document is reviewed and signed off by leadership to garner support.

SLO Definition Document:

Draft a two-page document providing a high-level definition of SLOs, including examples of effective ones. This should guide engineers by making SLO implementation accessible and generate interest without overwhelming them with volumes of information.

FAQ Document:

Compile a FAQ document to address anticipated questions as teams begin their SLO journey. Example questions include:

* What if my user is another service? Do I still need to care about SLOs?
* What if my service's dependencies don't have SLOs?
* How many SLOs should a service have? How many SLIs?

### Phase 2: Collecting SLIs

Instrumentation Guide:

Once the high-level SLO definition is clear, provide a detailed guide on how to instrument services to collect SLIs. Be specific and include examples from your organization's monitoring platforms. Address scenarios like collecting latency data, using percentiles, and instrumenting different types of services. Offer code snippets to facilitate the instrumentation process.

### Phase 3: Utilizing SLOs

Use Case Documentation:
 
* Document any existing SLO implementations to provide a concrete example for early adopters. 
* Define where all related artifacts will be stored (e.g., a wiki paired with a code repository).
* Ensure these resources are easily discoverable and navigable by users.

## Best Practices

Quality Documentation:

* Ensure all documentation undergoes the same quality control process as code.
* Structured and discoverable documentation is critical for successful implementation across engineering organizations.

This systematic approach to SLO implementation, supported by robust documentation, will help your organization effectively adopt SLOs and improve overall service reliability.
Other book notes of mine are:

<< template::inline::rindex book-notes

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
