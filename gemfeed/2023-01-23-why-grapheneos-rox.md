# Why GrapheneOS rox

> Published at 2023-01-23T15:31:52+02:00

```
Art by Joan Stark
               _.===========================._
            .'`  .-  - __- - - -- --__--- -.  `'.
        __ / ,'`     _|--|_________|--|_     `'. \
      /'--| ;    _.'\ |  '         '  | /'._    ; |
     //   | |_.-' .-'.'      ___      '.'-. '-._| |
    (\)   \"` _.-` /     .-'`_ `'-.     \ `-._ `"/
    (\)    `-'    |    .' .-'" "'-. '.    |    `-`
   (\)            |   / .'(3)(2)(1)'. \   |
   (\)            |  / / (4) .-.     \ \  |
   (\)            |  | |(5) (   )'==,J |  |
  (\)             |  \ \ (6) '-' (0) / /  |
 (\)              |   \ '.(7)(8)(9).' /   |
 (\)           ___|    '. '-.._..-' .'    |
 (\)          /.--|      '-._____.-'      |
  (\)        (\)  |\_  _  __   _   __  __/|
 (\)        (\)   |                       |
(\)_._._.__(\)    |                       |
 (\\\\jgs\\\)      '.___________________.'
  '-'-'-'--'
```

In 2021 I wrote "On Being Pedantic about Open-Source", and there was a section "What about mobile?" where I expressed the dilemma about the necessity of using proprietary mobile operating systems. With GrapheneOS, I found my perfect solution for personal mobile phone use. 

[On Being Pedantic about Open-Source](./2021-08-01-on-being-pedantic-about-open-source.md)  

What is GrapheneOS?

> GrapheneOS is a privacy and security-focused mobile OS with Android app compatibility developed as a non-profit open-source project. It's focused on the research and development of privacy and security technologies, including substantial improvements to sandboxing, exploits mitigations and the permission model.

GrapheneOS is an independent Android distribution based on the Android Open Source Project (AOSP) but hardened in multiple ways. Other independent Android distributions, like LineageOS, are also based on AOSP, but GrapheneOS takes it further so that it can be my daily driver on my phone.

[https://GrapheneOS.org](https://GrapheneOS.org)  
[https://LineageOS.org](https://LineageOS.org)  

## User Profiles

GrapheneOS allows configuring up to 32 user profiles (including a guest profile) on a single phone. A profile is a completely different environment within the phone, and it is possible to switch between them instantly. Sessions of a profile can continue running in the background or be fully terminated. Each profile can have completely different settings and different applications installed.

I use my default profile with primarily open-source applications installed, which I trust. I use another profile for banking (PayPal, various proprietary bank apps, Amazon store app, etc.) and another profile for various Google services (which I try to avoid, but I have to use once in a while). Furthermore, I have configured a profile for Social Media use (that one isn't in my default profile, as otherwise I am tempted to scroll social media all the time, which I try to avoid and only want to do intentionally when switching to the corresponding profile!).

The neat thing about the profiles is that some can run a sandboxed version of Google Play (see later in this post), while others don't. So some profiles can entirely operate without any Google Play, and only some profiles (to which I rarely switch) have Google Play enabled. 

You notice how much longer (multiple days) your phone can be on a single charge when Google Play Services isn't running in the background. This tells a lot about the background activities and indicates that using Google Play shouldn't be the norm.

## Proxying some of the Google offerings 

There's also the case that I am using an app from the Google Play store (as the app isn't available from F-Droid), which doesn't require Google Play Services to run in the background. Here's where I use the Aurora Android store. The Aurora store can be installed through F-Droid. Aurora acts as an anonymous proxy from your phone to the Google Play Store and lets you install apps from there. No Google credentials are required for that!

[https://f-droid.org](https://f-droid.org)  

There's a similar solution for watching videos on YouTube. You can use the NewPipe app (also from F-Droid), which acts as an anonymous proxy for watching videos from YouTube. So there isn't any need to install the official YouTube app, and there isn't any need to login to your Google account. What's so bad about the official app? You don't know which data it is sending about you to Google, so it is a privacy concern. 

## Google Play Sandboxing 

Before switching to GrapheneOS, I had been using LineageOS on one of my phones for a couple of years. Still, I always had to have a secondary personal phone with all of these proprietary apps which (partially) only work with Google Play on the phone (e.g. Banking, Navigation, various travel apps from various Airlines, etc.) somewhere around as I didn't install Google Play on my LineageOS phone due to privacy concerns and only installed apps from the F-Droid store on it. When travelling, I always had to carry around a second phone with Google Play on it, as without it; life would become inconvenient pretty soon. 

With GrapheneOS, it is different. Here, I do not just have a separate user profile, "Google", for various Google apps where Google Play runs, but Google Play also runs in a sandbox!!!

> GrapheneOS has a compatibility layer providing the option to install and use the official releases of Google Play in the standard app sandbox. Google Play receives no special access or privileges on GrapheneOS instead of bypassing the app sandbox and receiving a massive amount of highly privileged access. Instead, the compatibility layer teaches it how to work within the full app sandbox. It also isn't used as a backend for the OS services as it would be elsewhere since GrapheneOS doesn't use Google Play even when it's installed.

When I need to access Google Play, I can switch to the "Google" profile. Even there, Google is sandboxed to the absolute minimum permissions required to be operational, which gives additional privacy protection.

The sad truth is that Google Maps is still the best navigation app. When driving unknown routes, I can switch to my Google profile to use Google Maps. I don't need to do that when going streets I know about, but it is crucial (for me) to have Google Maps around when driving to a new destination.

Also, Google Translate and Google Lens are still the best translation apps I know. I just recently relocated to another country, where I am still learning the language, so Google Lens has been proven very helpful on various occasions by ad-hoc translating text into English or German for me.

The same applies to banking. Many banking apps require Google Play to be available (It might be even more secure to only use banking apps from the Google Play store due to official support and security updates). I rarely need to access my mobile banking app, but once in a while, I need to. As you have guessed by now, I can switch to my banking profile (with Google Play enabled), do what I need to do, and then terminate the session and go back to my default profile, and then my life can go on :-). 

It is great to have the flexibility to use any proprietary Android app when needed. That only applies to around 1% of my phone usage time, but you often don't always know when you need "that one app now". So it's perfect that it's covered with the phone you always have with you. 

## The camera and the cloud 

I really want my phone to shoot good looking pictures, so that I can later upload them to the Irregular Ninja:

[https://irregular.ninja](https://irregular.ninja)  

The stock camera app of the OASP could be better. Photos usually look washed out, and the app lacks features. With GrapheneOS, there are two options:

* Use the official Google camera app with sandboxed Google Play Services running. You will get the full Google experience here.
* Or, just use the default GrapheneOS camera app.

The GrapheneOS camera app is much better than the stock OASP camera app. I have been comparing the photo quality of my Pixel phone under LineageOS and GrapheneOS, and the differences are pronounced. I didn't compare the quality with the official Google camera app, but I have seen some comparison videos and the differences seem like they aren't groundbreaking. 

For automatic backups of my photos, I am relying on a self-hosted instance of NextCloud (with a client app available via F-Droid). So there isn't any need to rely on any Google apps and services (Google Play Photos or Google Camera app) anymore, and that's great!

[https://nextcloud.com](https://nextcloud.com)  

I also use NextCloud to synchronize my notes (NextCloud Notes), my RSS news feeds (NextCloud News) and contacts (DAVx5). All apps required are available in the F-Droid store.

## Fine granular permissions

Another great thing about GrapheneOS is that, besides putting your apps into different profiles, you can also restrict network access and configure storage scopes per app individually.

For example, let's say you are installing that one proprietary app from the Google Play Store through the Aurora store, and then you want to ensure that the app doesn't send data "home" through the internet. Nothing is easier to do than that. Just remove network access permissions from that only app.

The app also wants to store and read some data from your phone (e.g. it could be a proprietary app for enhancing photos, and therefore storage access to a photo folder would be required). In GrapheneOS, you can configure a storage scope for that particular app, e.g. only read and write from one folder but still forbid access to all other folders on your phone.

## Termux

Termux can be installed on any Android phone through F-Droid, so it doesn't need to be a GrapheneOS phone. But I have to mention Termux here as it significantly adds value to my phone experience. 

> Termux is an Android terminal emulator and Linux environment app that works directly with no rooting or setup required. A minimal base system is installed automatically - additional packages are available using the APT package manager.

[https://termux.dev](https://termux.dev)  

In short, Termux is an entire Linux environment running on your Android phone. Just pair your phone with a Bluetooth keyboard, and you will have the whole Linux experience. I am only using terminal Linux applications with Termux, though. What makes it especially great is that I could write on a new blog post (in Neovim through Termux on my phone) or do some coding whilst travelling (e.g. during a flight), or look up my passwords or some other personal documents (through my terminal-based password manager). All changes I commit to Git can be synced to the server with a simple `git push` once online (e.g. after the plane landed) again.

There are Pixel phones with a screen size of 6", and that's decent enough for occasional use like that, and everything (the phone, the BT keyboard, maybe an external battery pack) all fit nicely in a small travel pocket.

## So, why not use a pure Linux phone?

Strictly speaking, an Android phone is a Linux phone, but it's heavily modified and customized. For me, a "pure" Linux phone is a more streamlined Linux kernel running in a distribution like Ubuntu Touch or Mobian. 

A pure Linux phone, e.g. with Ubuntu Touch installed, e.g. on a PinePhone, Fairphone, the Librem 5 or the Volla phone, is very appealing to me. And they would also provide an even better Linux experience than Termux does. Some support running LineageOS within an Anbox, enabling you to run various proprietary Android apps occasionally within Linux.

[Ubuntu Touch](https://ubuntu-touch.io/)  
[More Linux distributions for mobile devices ](https://en.wikipedia.org/wiki/Linux_for_mobile_devices)  

But here, Google Play would not be sandboxed; you could not configure individual network permissions and storage scopes like in GrapheneOS. Pure Linux-compatible phones usually come with a crappy camera, and the battery life is generally pretty bad (only a few hours). Also, no big tech company pushes the development of Linux phones. Everything relies on hobbyists, whereas multiple big tech companies put a lot of effort into the Android project, and a lot of code also goes into the Android Open-Source project.  

Currently, pure Linux phones are only a nice toy to tinker with but are still not ready (will they ever?) to be the daily driver. SailfishOS may be an exception; I played around with it in the past. It is pretty usable, but it's not an option for me as it is partial a proprietary operating system.

[SailfishOS](https://sailfishos.org)  

## Small GrapheneOS downsides 

Sometimes, switching a profile to use a different app is annoying, and you can't copy and paste from the system clipboard from one profile to another. But that's a small price I am willing to pay!

Another thing is that GrapheneOS can only run on Google Pixel phones, whereas LineageOS can be installed on a much larger variety of hardware. But on the other hand, GrapheneOS works very well on Pixel phones. The GrapheneOS team can concentrate their development efforts on a smaller set of hardware which then improves the software's quality (best example: The camera app).

And, of course, GrapheneOS is an open-source project. This is a good thing; however, on the other side, nobody can guarantee that the OS will not break or will not damage your phone. You have to trust the GrapheneOS project and donate to the project so they can keep up with the great work. But I rather trust the GrapheneOS team than big tech. 

E-Mail your comments to hi@paul.cyou :-)

[Back to the main site](../)  
