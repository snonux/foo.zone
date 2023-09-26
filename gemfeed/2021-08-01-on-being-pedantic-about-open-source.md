# On being Pedantic about Open-Source

> Published at 2021-08-01T10:37:58+03:00; Updated at 2023-01-23

```
                                           __
                               _____....--' .'
                     ___...---'._ o      -`(
           ___...---'            \   .--.  `\
 ___...---'                      |   \   \ `|
|                                |o o |  |  |
|                                 \___'.-`.  '.
|                                      |   `---'
'^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^' LGB - Art by lgbearrd
```                     

I believe that it is essential to always have free and open-source alternatives to any kind of closed-source proprietary software available to choose from. But there are a couple of points you need to take into consideration. 

## The costs of open-source

One benefit of using open-source software is that it doesn't cost anything, right? That's correct in many cases. However, in some cases you still need to spend a significant amount of time configuring the software to work for you. It will be more expensive to use open-source software than proprietary commercial one if you aren't careful. 

Not to say that I haven't seen the same effect with commercial software where people had to, after buying it, put a bunch of effort to make it work due to the lack of quality or due to high complexity. But that's either bad luck or bad decision-making. Most commercial providers  I have worked with try to make it work for you, so you also will buy other products and services from them later on and don't lose you as a happy customer.

## Commercial providers

Producers of commercial software want to earn money after all. This is to grow their businesses and also to be able to pay their employees, who also need to care for their families. Employees build up their careers, build houses, and are proud of their accomplishments in the company.

So per se, commercial software is not a bad thing. Right? At least, commercial closed-source software is not a bad thing in its heart. Unfortunately, some companies have to keep their software closed-source to not lose their competitive edge over other competitors. 

## Earning on open-source

There are also companies that earn on open-source software. All the code they write is free for download and use, but you, as a customer, could pay for service and support if you are not an expert and can't manage it by yourself. 

I like this approach, as you can balance the effort and costs the way it suits you best, and in doubt, you can audit the source code. Are you already an expert? Perfect, you don't need to buy additional support for the software. Everything can be set up by yourself, given that you have the time and priority.

Also, once an open-source project reached a certain size, it is unlikely to be abandoned one day. As long as at least one person is willing to be the open-source maintainer, the project won't die. Whereas commercial providers can decide from today to tomorrow to retire software or go bankrupt (unless you purchase Microsoft Word, I don't believe it will die anytime soon). 

## Open-source organizations and individual contributors

Besides corporations, millions of individual open-source contributors write free and open-source software not for money but for pleasure. Often, they are organized in non-profit organizations, working together to reach a common goal (it is worth mentioning that there are also many professionals, payed by large corporations, working full-time for non-profit open-source projects in order to push the features and reach the goals of the corporations). Sometimes, people don't agree on the project goal, so it gets forked, which can be a good thing. The more diversity, the better, as this is where competition and innovation happens. Also, the end user will end up with more choices. 

These open-source projects are of a very high quality standard and are rock-solid, if not better, alternatives to proprietary counterparts. If the project isn't backed by a large corporation already, you should donate to these open-source organizations and/or individual contributors. I have donated to some projects I use personally. Do you learn a foreign language and use Anki flashcards? It's entirely free and open-source, and they happily accept donations ensuring future maintenance and development.

## Lesser known projects and the charm of clunkiness

Looking at the smaller, lesser-known open-source projects (not talking about established open-source projects like FreeBSD and Linux): You can't, however, expect the software to be perfect and bug-free. After all, most of the code is written for pleasure and fun in the developers' free time. Besides the developer himself, you might be the only user of the project. The software may be a bit clunky to use, and probably bugs are lurking around, and it might only work for a very specific use case.

Clunkiness can be charmful, though. And it can also encourage you to contribute code to make it better. There is a lot of such code in personal GitHub and GitLab repositories. The quality of such small open-source projects varies drastically. Many hobbyist programmers see programming as an art and put tons of effort into their projects. Others upload broken crap, which is dangerous to use. So have a look at the code before you use it!

## The security aspect

One of the main conceptions about open-source software is that it is more secure than closed-source software because everybody can read and fix the code. Is that actually true? You can only be sure when you audit the code by yourself. If you are like me, you won't have time to audit all the open-source software you use. It's impossible to audit more than 100 million lines of Linux kernel code. Static code analysis tools come in handy here, but they still require humans to look at the results.

Security bugs in open-source projects are exposed to the public and fixed quickly, while we don't know exactly what happens to security bugs in closed-source ones. Still, hackers and security specialists can find them through reverse engineering and penetration testing. Overall, thinking of security, In my opinion it is still better to prefer open-source software because the more significant the project, the higher the probability that security bugs are found and fixed as more parties are looking into it. Furthermore, provided you have the necessary resources, you could still deduct an audit by yourself. The latter especially happens when companies with its own security and penetration testing departments are evaluating the use of open-source. This is something not every company can afford though.

## Always watch out for open-source alternatives

Do you need Microsoft Word? Why don't you just use the Vim text editor or GNU Emacs to write your letters? If that's too nerdy, you can still use open-source alternatives such as AbiWord or LibreOffice. Larger organizations have the tendency to standardize the software their employees have to use. Unfortunately, as Microsoft Word is the de-facto standard text processing program, most companies prefer Word over LibreOffice. Same with Microsoft Excel vs LibreOffice Calc or other spreadsheet alternatives like Gnumeric. I don't know why that is; please....

E-Mail your comments to `paul@nospam.buetow.org` :-)

I only use free and open-source operating systems on my personal Laptops, Desktop PCs and servers (FreeBSD and Linux based ones). Most of the programs and apps I use on them are free and open-source as well, and I am comfortable with it for over twenty years. Exceptions are the BIOSes and some firmwares of my devices. I also use Skype as most of my friends and family are using it. They are, unfortunately, proprietary software still. But I will be looking into Matrix as a Skype alternative when I have time. There are also open BIOS alternatives, but they usually don't work on my devices.

## What about mobile?

> Update 2023-01-21: Check out my newer post about GrapheneOS, which solves some of my dilemmas

[Why GrapheneOS Rox](./2023-01-23-why-grapheneos-rox.md)  

I struggle to go 100% open-source on my Smartphone. I use a Samsung phone with the stock Android as provided by Samsung. I love the device as it is large enough to use as a portable reading and note-taking device, and it can also take decent pictures. As a cloud backup solution, I have my own NextCloud server (open-source). Android is mainly open-source software, but many closed parts are still included. I replaced most of the standard apps with free and open-source variants from the F-Droid store though.

I could get a LineageOS based phone to get rid of the proprietary Android parts (I tried that out a couple of times in the past). But then a couple of convenient apps, such as Google Maps or Banking or Skype or the E-Ticket apps of various Airlines, various review apps when searching for restaurants, Audible (I think Audible offers an excellent service), etc., won't work anymore. The proprietary Google Maps is still the best maps app, even though there are open alternatives available. It's not that I couldn't live without these apps, but they make life a lot more convenient.

## Know the alternatives

Thinking about alternative solutions is always a good idea. My advice is never to be entirely dependant on any proprietary software. Before you decide to use proprietary software, try to find alternatives in the open-source world. You might need to invest some time playing around with the options available. Maybe they are good enough for you, or maybe not.

If you still want to use proprietary software, use it with caution. Have a look at the recent change at Google Photos: For a long time, "high quality" photos could be uploaded there quota-less for free. However, Google recently changed the model so that people exceeding a quota have to start paying for the extra space consumed. I am not against Google's decision, but it shows you that a provider can always change its direction. So you can't entirely rely on these. I repeat myself: Don't fully rely on anything proprietary, but you might still use proprietary software or services for your own convenience.

## You can't control it all

The biggest problem I have with going 100% open-source is actually time. You can't control all the software you use or might be using in the future. You have only a finite amount of time available in your life. So you have to decide what's more important: Investigate and use an open-source alternative of every program and app you have installed, or rather spend quality time with your family and have a nice walk in the park or go to a sports class or cook a nice meal? You can't control it all in today's world of tech, not as a user and even not as a tech worker. There's a great blog post worth reading: 

[https://unixsheikh.com/articles/how-to-stay-sane-in-todays-world-of-tech.html](https://unixsheikh.com/articles/how-to-stay-sane-in-todays-world-of-tech.html)  

## The middle way

Regarding my personal Smartphone dilemma: I guess the middle way is to use two phones: 

* Have a secondary, proprietary Android phone with Google Play store (or an Apple iPhone if this is more your thing) and all its benefits for occasional use. Use the proprietary phone only with intention. Such a phone implies some risks regarding your privacy. If you aren't careful, app providers will collect your personal data for building a digital profile of you, which gets used for online advertisement and other things. This doesn't only applies to the Smartphone, this also applies to some proprietary software (including cloud services such as Google Photos) you use on your home computer or websites you visit (I am looking at you, Facebook, Twitter and friends). Try to disable all tracking features on such a phone. It's not a guarantee that nobody will be collecting data from you anymore, but you should take at least the chance. Cal Newport once mentioned that you should not use privacy concerning apps as much anyway and instead spend more time on things which matter.
* Have a primary phone, entirely based on free and open-source software. There will be probably no app collecting your personal data. Try to use the primary phone for all of your everyday activities and fall back to the proprietary phone only for particular use cases. Once there is decent hardware (with a decent camera) running Linux (such as Mobian, for example) available, I will consider a purchase. The only 3rd party which then will still be able to track you will be your network provider. You could start your own phone network, but that seems overkill. There is already the Pinephone and the Librem 5 running a real Linux (Android is Linux based, but it doesn't count as a real Linux for me). Still, I want to wait a bit longer for better hardware to be available (I want to have a good camera always with me).
* You could also add a tertiary phone to the mix, which you only use for work and nothing else. That one will be very likely a proprietary phone too. You only have to keep this one around when you are working or when you are on-call.

I have been playing with other smartphone OS alternatives, especially with MeeGo (which has died already) and SailfishOS, too. Security and privacy seem to be significantly improved compared to an Android. As a matter of fact, I bought a cheap and used Sony Xperia XA2 last year and installed SailfishOS on it. It's a nice toy, but it's still not the holy open-source grail as there are also proprietary parts in SailfishOS. Platforms such as Mobian, Ubuntu Touch and Plasma Mobile are more compelling to me. People must explore alternatives to Android and Apple here, as otherwise, you won't own any gadgets anymore:

[https://news.slashdot.org/story/21/07/10/0120236/by-2030-you-wont-own-any-gadgets](https://news.slashdot.org/story/21/07/10/0120236/by-2030-you-wont-own-any-gadgets)  

Anyhow, any gadgets, including your phone, should be a tool you use. Don't let the phone use you!

## The downside of being a nobody

Be aware that it might be to your disadvantage if you manage to go completely under cover without anyone collecting data from you. Suppose you are a nobody on the web (no social media profiles, no tracking history, etc.). In that case, you aren't behaving like the mass, and therefore you are suspicious. So it might be even a good thing to leave your marks here and there once in a while. You aren't hiding anything anyway, correct? Just be mindful what you are sharing about yourself. I share personal things very rarely on Facebook for example. And I only share a small subset of my personal life on my personal homepage and this blog and on all of my social media accounts. Nobody is interested in what I have for breakfast anyway I guess. Write me an E-Mail if you are interested in what I am having for breakfast.

## Mobile open-source OSes are still evolving

You might have noticed that I wrote a lot about Smartphones in this article. The reason is that free and open-source software for Smartphones is still evolving. In contrast, for Laptops and Desktop PCs, it's already there. There is no reason to use proprietary operating systems such as Windows or macOS on your computers unless your employer forces you to use one of these. Why would they force you? It has to do with standardization again. The IT department only can manage so many platforms. It wouldn't be manageable by IT if every employee would install their own Linux distribution or one of the *BSDs. That might work for small startups but not for larger companies, especially not for a security-focused companies.

I would love a standardized Linux at work, though. Dell and Lenovo also officially support Linux on their notebooks. The culprit may be knowledgeable IT staff maintaining and giving support to the Desktop Linux users. Not all colleagues are Linux geeks like you and me. I am using macOS for work, but I am not an Apple expert. Occasionally I have to contact IT support regarding some issues I have. I don't use the macOS GUI a lot; I mainly live in the terminal so I can run the same tools I also use on Linux.

## Conclusion

Should you be pedantic about open-source software? It depends. It depends on your fundamental values and how much time you are ready to invest. Open-source software is not just free as in money, but also free as in freedom. You will gain back complete control of your personal data. Unfortunately, installing ready proprietary apps from the Play Store is much more convenient than building up a trustworthy open-source-based infrastructure by yourself. As a guideline, use proprietary software and services with caution. Be mindful about your choices and where you leave your digital fingerprints. In doubt, think less is more. Do you really need this new shiny app? What benefit does it provide to you? Probably you don't really need that shiny new app.

You have better chances when you know how to manage your own server and install and manage alternatives to the big cloud providers by yourself. I have the advantage that I have work experience as a Linux Systems Administrator here. I mentioned NextCloud already. I use NextCloud for online photo and file storage, contact and calendar sync and as an RSS news feed server. You could do the same with your own E-Mail server, you can also host your own website and blog. I also mentioned Matrix as a Skype alternative (which could also be an alternative to WhatsApp, Skype, Telegram, Viber, ...). I don't know a lot about Matrix yet, but it seems to be a very neat alternative. I am ready to invest time in it as one of my future personal pet projects. Not only because I think it's better, but also because for fun and as a hobby. But this doesn't mean that I invest *all* of my personal free time in it.

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
