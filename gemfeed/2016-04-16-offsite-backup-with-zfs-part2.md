# Offsite backup with ZFS (Part 2)

> Published at 2016-04-16T22:43:42+01:00

```
 ________________
|# :           : #|
|  : ZFS/GELI  :  |________________ 
|  :   Offsite : |# :           : #|
|  :  Backup 1 : |  : ZFS/GELI  :  |
|  :___________: |  :   Offsite :  |
|     _________  |  :  Backup 2 :  |
|    | __      | |  :___________:  |
|    ||  |     | |     _________   |
\____||__|_____|_|    | __      |  |
                 |    ||  |     |  |
                 \____||__|_____|__|
```

[Offsite backup with ZFS Part 1](./2016-04-03-offsite-backup-with-zfs.md)  
[Offsite backup with ZFS Part 2 (you are reading this atm.)](./2016-04-16-offsite-backup-with-zfs-part2.md)  

I enhanced the procedure a bit. From now on, I have two external 2TB USB hard drives. Both are set up precisely the same way. To decrease the probability that both drives will not fail simultaneously, they are of different brands. One drive is kept at a secret location. The other one is held at home, right next to my HP MicroServer.

Whenever I update the offsite backup, I am doing it to the drive, which is kept locally. Afterwards, I bring it to the secret location, swap the drives, and bring the other back home. This ensures that I will always have an offsite backup available at a different location than my home - even while updating one copy of it.

Furthermore, I added scrubbing ("zpool scrub...") to the script. It ensures that the file system is consistent and that there are no bad blocks on the disk and the file system. To increase the reliability, I also run a "zfs set copies=2 zroot". That setting is also synchronized to the offsite ZFS pool. ZFS stores every data block to disk twice now. Yes, it consumes twice as much disk space, making it better fault-tolerant against hardware errors (e.g. only individual disk sectors going bad). 

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
