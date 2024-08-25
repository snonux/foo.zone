# Projects I currently don't have time for

> Published at 2024-05-03T16:23:03+03:00

```
Art by Laura Brown

.'`~~~~~~~~~~~`'.
(  .'11 12 1'.  )
|  :10 \    2:  |
|  :9   @-> 3:  |
|  :8       4;  |
'. '..7 6 5..' .'
 ~-------------~  ldb

```

## Table of Contents

* [⇢ Projects I currently don't have time for](#projects-i-currently-don-t-have-time-for)
* [⇢ ⇢ Introduction](#introduction)
* [⇢ ⇢ Hardware projects I don't have time for](#hardware-projects-i-don-t-have-time-for)
* [⇢ ⇢ ⇢ I use Arch, btw!](#i-use-arch-btw)
* [⇢ ⇢ ⇢ OpenBSD home router](#openbsd-home-router)
* [⇢ ⇢ ⇢ Pi-Hole server](#pi-hole-server)
* [⇢ ⇢ ⇢ Infodash](#infodash)
* [⇢ ⇢ ⇢ Reading station](#reading-station)
* [⇢ ⇢ ⇢ Retro station](#retro-station)
* [⇢ ⇢ ⇢ Sound server](#sound-server)
* [⇢ ⇢ ⇢ Project Freekat](#project-freekat)
* [⇢ ⇢ Programming projects I don't have time for](#programming-projects-i-don-t-have-time-for)
* [⇢ ⇢ ⇢ CLI-HIVE](#cli-hive)
* [⇢ ⇢ ⇢ Enhanced KISS home photo albums](#enhanced-kiss-home-photo-albums)
* [⇢ ⇢ ⇢ KISS file sync server with end-to-end encryption](#kiss-file-sync-server-with-end-to-end-encryption)
* [⇢ ⇢ ⇢ A language that compiles to `bash`](#a-language-that-compiles-to-bash)
* [⇢ ⇢ ⇢ A language that compiles to `sed`](#a-language-that-compiles-to-sed)
* [⇢ ⇢ ⇢ Renovate VS-Sim](#renovate-vs-sim)
* [⇢ ⇢ ⇢ KISS ticketing system](#kiss-ticketing-system)
* [⇢ ⇢ ⇢ A domain-specific language (DSL) for work](#a-domain-specific-language-dsl-for-work)
* [⇢ ⇢ Self-hosting projects I don't have time for](#self-hosting-projects-i-don-t-have-time-for)
* [⇢ ⇢ ⇢ My own Matrix server](#my-own-matrix-server)
* [⇢ ⇢ ⇢ Ampache music server](#ampache-music-server)
* [⇢ ⇢ ⇢ Librum eBook reader](#librum-ebook-reader)
* [⇢ ⇢ ⇢ Memos - Note-taking service](#memos---note-taking-service)
* [⇢ ⇢ ⇢ Bepasty server](#bepasty-server)
* [⇢ ⇢ Books I don't have time to read](#books-i-don-t-have-time-to-read)
* [⇢ ⇢ ⇢ Fluent Python](#fluent-python)
* [⇢ ⇢ ⇢ Programming Ruby](#programming-ruby)
* [⇢ ⇢ ⇢ Peter F. Hamilton science fiction books](#peter-f-hamilton-science-fiction-books)
* [⇢ ⇢ New websites I don't have time for](#new-websites-i-don-t-have-time-for)
* [⇢ ⇢ ⇢ Create a "Why Raku Rox" site](#create-a-why-raku-rox-site)
* [⇢ ⇢ Research projects I don't have time for](#research-projects-i-don-t-have-time-for)
* [⇢ ⇢ ⇢ Project secure](#project-secure)
* [⇢ ⇢ ⇢ CPU utilisation is all wrong](#cpu-utilisation-is-all-wrong)

## Introduction

Over the years, I have collected many ideas for my personal projects and noted them down. I am currently in the process of cleaning up all my notes and reviewing those ideas. I don’t have time for the ones listed here and won’t have any soon due to other commitments and personal projects. So, in order to "get rid of them" from my notes folder, I decided to simply put them in this blog post so that those ideas don't get lost. Maybe I will pick up one or another idea someday in the future, but for now, they are all put on ice in favor of other personal projects or family time.

## Hardware projects I don't have time for

### I use Arch, btw!

The idea was to build the ultimate Arch Linux setup on an old ThinkPad X200 booting with the open-source LibreBoot firmware, complete with a tiling window manager, dmenu, and all the elite tools. This is mainly for fun, as I am pretty happy (and productive) with my Fedora Linux setup. I ran EndeavourOS (close enough to Arch) on an old ThinkPad for a while, but then I switched back to Fedora because the rolling releases were annoying (there were too many updates).

### OpenBSD home router

In my student days, I operated a 486DX PC with OpenBSD as my home DSL internet router. I bought the setup from my brother back then. The router's hostname was `fishbone`, and it performed very well until it became too slow for larger broadband bandwidth after a few years of use.

I had the idea to revive this concept, implement `fishbone2`, and place it in front of my proprietary ISP router to add an extra layer of security and control in my home LAN. It would serve as the default gateway for all of my devices, including a Wi-Fi access point, would run a DNS server, Pi-hole proxy, VPN client, and DynDNS client. I would also implement high availability using OpenBSD's CARP protocol.

[https://openbsdrouterguide.net](https://openbsdrouterguide.net)  
[https://pi-hole.net/](https://pi-hole.net/)  
[https://www.OpenBSD.org](https://www.OpenBSD.org)  
[https://www.OpenBSD.org/faq/pf/carp.html](https://www.OpenBSD.org/faq/pf/carp.html)  

However, I am putting this on hold as I have opted for an OpenWRT-based solution, which was much quicker to set up and runs well enough.

[https://OpenWRT.org/](https://OpenWRT.org/)  

### Pi-Hole server

Install Pi-hole on one of my Pis or run it in a container on Freekat. For now, I am putting this on hold as the primary use for this would be ad-blocking, and I am avoiding surfing ad-heavy sites anyway. So there's no significant use for me personally at the moment.

[https://pi-hole.net/](https://pi-hole.net/)  

### Infodash

The idea was to implement my smart info screen using purely open-source software. It would display information such as the health status of my personal infrastructure, my current work tracker balance (I track how much I work to prevent overworking), and my sports balance (I track my workouts to stay within my quotas for general health). The information would be displayed on a small screen in my home office, on my Pine watch, or remotely from any terminal window.

I don't have this, and I haven't missed having it, so I guess it would have been nice to have it but not provide any value other than the "fun of tinkering."

### Reading station

I wanted to create the most comfortable setup possible for reading digital notes, articles, and books. This would include a comfy armchair, a silent barebone PC or Raspberry Pi computer running either Linux or *BSD, and an e-Ink display mounted on a flexible arm/stand. There would also be a small table for my paper journal for occasional note-taking. There are a bunch of open-source software available for PDF and ePub reading. It would have been neat, but I am currently using the most straightforward solution: a Kobo Elipsa 2E, which I can use on my sofa.

### Retro station

I had an idea to build a computer infused with retro elements. It wouldn't use actual retro hardware but would look and feel like a retro machine. I would call this machine HAL or Retron.

I would use an old ThinkPad laptop placed on a horizontal stand, running NetBSD, and attaching a keyboard from ModelFkeyboards. I use WindowMaker as a window manager and run terminal applications through Retro Term. For the monitor, I would use an older (black) EIZO model with large bezels.

[https://www.NetBSD.org](https://www.NetBSD.org)  
[https://www.modelfkeyboards.com](https://www.modelfkeyboards.com)  
[https://github.com/Swordfish90/cool-retro-term)](https://github.com/Swordfish90/cool-retro-term))  

The computer would occasionally be used to surf the Gemini space, take notes, blog, or do light coding. However, I have abandoned the project for now because there isn't enough space in my apartment, as my daughter will have a room for herself.

### Sound server

My idea involved using a barebone mini PC running FreeBSD with the Navidrome sound server software. I could remotely connect to it from my phone, workstation/laptop to listen to my music collection. The storage would be based on ZFS with at least two drives for redundancy. The app would run in a Linux Docker container under FreeBSD via Bhyve.

[https://github.com/navidrome/navidrome](https://github.com/navidrome/navidrome)  
[https://wiki.freebsd.org/bhyve](https://wiki.freebsd.org/bhyve)  

### Project Freekat

My idea involved purchasing the Meerkat mini PC from System76 and installing FreeBSD. Like the sound-server idea (see previous idea), it would run Linux Docker through Bhyve. I would self-host a bunch of applications on it:

* Wallabag
* Ankidroid
* Miniflux & Postgres
* Audiobookshelf
* ...

All of this would be within my LAN, but the services would also be accessible from the internet through either Wireguard or SSH reverse tunnels to one of my OpenBSD VMs, for example:

* `wallabag.awesome.buetow.org`
* `ankidroid.awesome.buetow.org`
* `miniflux.awesome.buetow.org`
* `audiobookshelf.awesome.buetow.org`
* ...

I am abandoning this project for now, as I am currently hosting my apps on AWS ECS Fargate under `*.cool.buetow.org`, which is "good enough" for the time being and also offers the benefit of learning to use AWS and Terraform, knowledge that can be applied at work.

[My personal AWS setup](./2024-02-04-from-babylon5.buetow.org-to-.cloud.md)  

## Programming projects I don't have time for

### CLI-HIVE

This was a pet project idea that my brother and I had. The concept was to collect all shell history of all servers at work in a central place, apply ML/AI, and return suggestions for commands to type or allow a fuzzy search on all the commands in the history. The recommendations for the commands on a server could be context-based (e.g., past occurrences on the same server type). 

You could decide whether to share your command history with others so they would receive better suggestions depending on which server they are on, or you could keep all the history private and secure. The plan was to add hooks into zsh and bash shells so that all commands typed would be pushed to the central location for data mining.

### Enhanced KISS home photo albums

I don't use third-party cloud providers such as Google Photos to store/archive my photos. Instead, they are all on a ZFS volume on my home NAS, with regular offsite backups taken. Thus, my project would involve implementing the features I miss most or finding a solution simple enough to host on my LAN:

* A feature I miss presents me with a random day from the past and some photos from that day. This project would randomly select a day and generate a photo album for me to view and reminisce about memories.
* Another feature I miss is the ability to automatically deduplicate all the photos, as I am sure there are tons of duplicates on my NAS.
* Auto-enhancing the photos (perhaps using ImageMagick?)
* I already have a simple `photoalbum.sh` script that generates an album based on an input directory. However, it would be great also to have a timeline feature to enable browsing through different dates.

[KISS static web photo albums with `photoalbum.sh`](./2023-10-29-kiss-static-web-photo-albums-with-photoalbum.sh.md)  

### KISS file sync server with end-to-end encryption

I aimed to have a simple server to which I could sync notes and other documents, ensuring that the data is fully end-to-end encrypted. This way, only the clients could decrypt the data, while an encrypted copy of all the data would be stored on the server side. There are a few solutions (e.g., NextCloud), but they are bloated or complex to set up. 

I currently use Syncthing for encrypted file sync across all my devices; however, the data is not end-to-end encrypted. It's a good-enough setup, though, as my Syncthing server is in my home LAN on an encrypted file system.

[https://syncthing.net](https://syncthing.net)  

I also had the idea of using this as a pet project for work and naming it `Cryptolake`, utilizing post-quantum-safe encryption algorithms and a distributed data store.

### A language that compiles to `bash`

I had an idea to implement a higher-level language with strong typing that could be compiled into native Bash code. This would make all resulting Bash scripts more robust and secure by default. The project would involve developing a parser, lexer, and a Bash code generator. I planned to implement this in Go.

I had previously implemented a tiny scripting language called Fype (For Your Program Execution), which could have served as inspiration.

[The Fype Programming Language](./2010-05-09-the-fype-programming-language.md)  

### A language that compiles to `sed`

This is similar to the previous idea, but the difference is that the language would compile into a sed script. Sed has many features, but the brief syntax makes scripts challenging to read. The higher-level language would mimic sed but in a form that is easier for humans to read.

### Renovate VS-Sim

VS-Sim is an open-source simulator programmed in Java for distributed systems. VS-Sim stands for "Verteilte Systeme Simulator," the German translation for "Distributed Systems Simulator." The VS-Sim project was my diploma thesis at Aachen University of Applied Sciences.

[https://codeberg.org/snonux/vs-sim](https://codeberg.org/snonux/vs-sim)  

The ideas I had was:

* Translate the project into English.
* Modernise the Java codebase to be compatible with the latest JDK.
* Make it compile to native binaries using GraalVM.
* Distribute the project using AppImages.

I have put this project on hold for now, as I want to do more things in Go and fewer in Java in my personal time.

### KISS ticketing system

My idea was to program a KISS (Keep It Simple, Stupid) ticketing system for my personal use. However, I am abandoning this project because I now use the excellent Taskwarrior software. You can learn more about it at:

[https://taskwarrior.org/](https://taskwarrior.org/)  

### A domain-specific language (DSL) for work

At work, an internal service allocates storage space for our customers on our storage clusters. It automates many tasks, but many tweaks are accessible through APIs. I had the idea to implement a Ruby-based DSL that would make using all those APIs for ad-hoc changes effortless, e.g.:

```ruby
Cluster :UK, :uk01 do
  Customer.C1A1.segments.volumes.each do |volume|
    puts volume.usage_stats
    volume.move_off! if volume.over_subscribed?
  end
end
```

I am abandoning this project because my workplace has stopped the annual pet project competition, and I have other more important projects to work on at the moment.

[Creative universe (Work pet project contests)](./2022-04-10-creative-universe.md)  

## Self-hosting projects I don't have time for

### My own Matrix server

I value privacy. It would be great to run my own Matrix server for communication within my family. I have yet to have time to look into this more closely.

[https://matrix.org](https://matrix.org)  

### Ampache music server

Ampache is an open-source music streaming server that allows you to host and manage your music collection online, accessible via a web interface. Setting it up involves configuring a web server, installing Ampache, and organising your music files, which can be time-consuming. 

### Librum eBook reader

Librum is a self-hostable e-book reader that allows users to manage and read their e-book collection from a web interface. Designed to be a self-contained platform where users can upload, organise, and access their e-books, Librum emphasises privacy and control over one's digital library.

[https://github.com/Librum-Reader/Librum](https://github.com/Librum-Reader/Librum)  

I am using my Kobo devices or my laptop to read these kinds of things for now.

### Memos - Note-taking service

Memos is a note-taking service that simplifies and streamlines information capture and organisation. It focuses on providing users with a minimalistic and intuitive interface, aiming to enhance productivity without the clutter commonly associated with more complex note-taking apps.

[https://www.usememos.com](https://www.usememos.com)  

I am abandoning this idea for now, as I am currently using plain Markdown files for notes and syncing them with Syncthing across my devices.

### Bepasty server

Bepasty is like a Pastebin for all kinds of files (text, image, audio, video, documents, binary, etc.). It seems very neat, but I only share a little nowadays. When I do, I upload files via SCP to one of my OpenBSD VMs and serve them via vanilla httpd there, keeping it KISS.

[https://github.com/bepasty/bepasty-server](https://github.com/bepasty/bepasty-server)  

## Books I don't have time to read

### Fluent Python

I consider myself an advanced programmer in Ruby, Bash, and Perl. However, Python seems to be ubiquitous nowadays, and most of my colleagues prefer Python over any other languages. Thus, it makes sense for me to also learn and use Python. After conducting some research, "Fluent Python" appears to be the best book for this purpose.

I don't have time to read this book at the moment, as I am focusing more on Go (Golang) and I know just enough Python to get by (e.g., for code reviews). Additionally, there are still enough colleagues around who can review my Ruby or Bash code.

### Programming Ruby

I've read a couple of Ruby books already, but "Programming Ruby," which covers up to Ruby 3.2, was just recently released. I would like to read this to deepen my Ruby knowledge further and to revisit some concepts that I may have forgotten.

As stated in this blog post, I am currently more eager to focus on Go, so I've put the Ruby book on hold. Additionally, there wouldn't be enough colleagues who could "understand" my advanced Ruby skills anyway, as most of them are either Java developers or SREs who don't code a lot.

### Peter F. Hamilton science fiction books

I am a big fan of science fiction, but my reading list is currently too long anyway. So, I've put the Hamilton books on the back burner for now. You can see all the novels I've read here:

[https://paul.buetow.org/novels.html](https://paul.buetow.org/novels.html)  
[gemini://paul.buetow.org/novels.gmi](gemini://paul.buetow.org/novels.gmi)  


## New websites I don't have time for

### Create a "Why Raku Rox" site

The website "Why Raku Rox" would showcase the unique features and benefits of the Raku programming language and highlight why it is an exceptional choice for developers. Raku, originally known as Perl 6, is a dynamic, expressive language designed for flexible and powerful software development.

This would be similar to the "Why OpenBSD rocks" site:

[https://why-openbsd.rocks](https://why-openbsd.rocks)  
[https://raku.org](https://raku.org)  

I am not working on this for now, as I currently don’t even have time to program in Raku.

## Research projects I don't have time for

### Project secure

For work: Implement a PoC that dumps Java heaps to extract secrets from memory. Based on the findings, write a Java program that encrypts secrets in the kernel using the `memfd_secret()` syscall to make it even more secure.

[https://lwn.net/Articles/865256/](https://lwn.net/Articles/865256/)  

Due to other priorities, I am putting this on hold for now. The software we have built is pretty damn secure already!

### CPU utilisation is all wrong

This research project, based on Brendan Gregg's blog post, could potentially significantly impact my work.

[https://brendangregg.com/blog/2017-05-09/cpu-utilization-is-wrong.html](https://brendangregg.com/blog/2017-05-09/cpu-utilization-is-wrong.html)  

The research project would involve setting up dashboards that display actual CPU usage and the cycles versus waiting time for memory access.

E-Mail your comments to `paul@nospam.buetow.org` :-)

Related and maybe interesting:

[Sweating the small stuff - Tiny projects of mine](./2022-06-15-sweating-the-small-stuff.md)  

[Back to the main site](../)  
