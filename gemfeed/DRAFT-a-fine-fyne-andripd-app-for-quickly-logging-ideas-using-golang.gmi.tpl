# A fine Fyne Andorid app for quickly logging ideas using Go

I am an ideas person. I find myself frequently somewhere on the streets with an Idea in my head but no journal paper noting it down. 

I have tried many notes app for my Phone. Most of them either don't do what I want, are proprietary software, or are too complicated to use with too many features. I was never into mobile app development, as I dislike the complexity of the developer toolchains and I also don't want to use Android Studio and also I don't want to use Java or Kotlin. I want to use a language I know and like for mobile app development.

Enter QuickLogger – a compact GUI Android (well, cross-platform due to Fyne) app that I've crafted using Go and the nifty Fyne framework. With Fyne, the app can also be compiled easily to an Android APK. This little tool is designed for those spontaneous moments, allowing me to log my thoughts as plain text files on my Android phone quickly. No fancy file formats. Just plain text!

There's no need to navigate through complex menus or deal with sync issues. I jot down my idea, and QuickLogger saves it to a plain text file in a designated local folder on my phone. There is one text file per note. Once logged, the file can't be edited anymore (keeps it simple). If I want to correct or change a note, I simply write a new one. My notes are always pretty small (usually one short sentence each) so there isn't the need of an edit functionality.

With Syncthing, the note files are then synchronised to my home computer to my `~/Notes` directory. From there, a Raku script is adding it to my Taskwarrior DB so that I can process them at a later time (e.g. take action on that one Idea I had). That then will delete the original note file on my computer and also (through Syncthing) on my phone.

=> https://syncthing.net

Quicklogger's user interface is as minimal as it gets. When I launch QuickLogger, I'm greeted with a simple window where I can type a plain text. Hit the "Log text" button, and voilà – the input is timestamped and saved as a file in my chosen directory. If I need to change the directory, the "Preferences" button brings up a window where you can make your tweaks and get back to logging.

For the code-savvy folks out there, QuickLogger is a neat example of what you can achieve with Go and Fyne. It's a testament to building functional, cross-platform apps without getting bogged down in the nitty-gritty of platform-specific details. 

I guess my Android apps will never be polished, but they will get the job done, and this exactly how I want them.

=> https://codeberg.org/snonux/quicklogger

I hope this will inspire you to write your own small mobile apps in Go using the awesome Fyne framework! 

E-Mail your comments to `paul@nospam.buetow.org` :-)


build.sh + android NDK download

installing the app via syncthing

problem with the logo (manual build, link to github issue)

Other Go posts are:

<< template::inline::index golang

=> ../ Back to the main site
