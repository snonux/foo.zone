# Installing DTail on OpenBSD

> Published at 2022-10-30T11:03:19+02:00

```
       ,_---~~~~~----._
 _,,_,*^____      _____``*g*\"*,
/ __/ /'     ^.  /      \ ^@q   f
 @f   |       |  |       |  0 _/
\`/   \~__((@/ __ \__((@/    \
 |           _l__l_           I    <--- The Go Gopher
 }          [______]           I
 ]            | | |            |
 ]             ~ ~             |
 |                            |
  |                           |
  |                           |       A       ;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~|~~~,--,-/ \---,-/|~~,~~~~~~~~~~~~~~~~~~~~~~~~~~~
                           _|\,'. /|      /|   `/|-.
                       \`.'    /|      ,            `;.
                      ,'\   A     A         A   A _ /| `.;
                    ,/  _              A       _  / _   /|  ;
                   /\  / \   ,  ,           A  /    /     `/|
                  /_| | _ \         ,     ,             ,/  \
                 // | |/ `.\  ,-      ,       ,   ,/ ,/      \/
                 / @| |@  / /'   \  \      ,              >  /|    ,--.
                |\_/   \_/ /      |  |           ,  ,/        \  ./' __:..
                |  __ __  |       |  | .--.  ,         >  >   |-'   /     `
              ,/| /  '  \ |       |  |     \      ,           |    /
             /  |<--.__,->|       |  | .    `.        >  >    /   (
            /_,' \\  ^  /  \     /  /   `.    >--            /^\   |
                  \\___/    \   /  /      \__'     \   \   \/   \  |
                   `.   |/          ,  ,                  /`\    \  )
                     \  '  |/    ,       V    \          /        `-\
 OpenBSD Puffy --->   `|/  '  V      V           \    \.'            \_
                       '`-.       V       V        \./'\
                           `|/-.      \ /   \ /,---`\         kat
                            /   `._____V_____V'
                                       '     '
```

This will be a quick blog post, as I am busy with my personal life now. I have relocated to a different country and am still busy arranging things. So bear with me :-)

 In this post, I want to give a quick overview (or how-to) about installing DTail on OpenBSD, as the official documentation only covers Red Hat and Fedora Linux! And this blog post will also be used as my reference!

[https://dtail.dev](https://dtail.dev)  

I am using Rexify for my OpenBSD automation. Check out the following article covering my Rex setup in a little bit more detail:

[Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  

I will also mention some relevant `Rexfile` snippets in this post!

## Compile it

First of all, DTail needs to be downloaded and compiled. For that, `git`, `go`, and `gmake` are required:

```
$ doas pkg_add git go gmake
```

I am happy that the Go Programming Language is readily available in the OpenBSD packaging system. Once the dependencies got installed, clone DTail and compile it:

```
$ mkdir git
$ cd git
$ git clone https://github.com/mimecast/dtail
$ cd dtail
$ gmake 
```

You can verify the version by running the following command:

```
$ ./dtail --version
 DTail  4.1.0  Protocol 4.1  Have a lot of fun!
$ file dtail
 dtail: ELF 64-bit LSB executable, x86-64, version 1
```

Now, there isn't any need anymore to keep `git`, `go` and `gmake`, so they can be deinstalled now:

```
$ doas pkg_delete git go gmake
```

One day I shall create an official OpenBSD port for DTail.

## Install it

Installing the binaries is now just a matter of copying them to `/usr/local/bin` as follows:

```
$ for bin in dserver dcat dgrep dmap dtail dtailhealth; do
  doas cp -p $bin /usr/local/bin/$bin
  doas chown root:wheel /usr/local/bin/$bin
done
```

Also, we will be creating the `_dserver` service user:

```
$ doas adduser -class nologin -group _dserver -batch _dserver
$ doas usermod -d /var/run/dserver/ _dserver
```

The OpenBSD init script is created from scratch (not part of the official DTail project). Run the following to install the bespoke script:

```
$ cat <<'END' | doas tee /etc/rc.d/dserver
#!/bin/ksh

daemon="/usr/local/bin/dserver"
daemon_flags="-cfg /etc/dserver/dtail.json"
daemon_user="_dserver"

. /etc/rc.d/rc.subr

rc_reload=NO

rc_pre() {
    install -d -o _dserver /var/log/dserver
    install -d -o _dserver /var/run/dserver/cache
}

rc_cmd $1 &
END
$ doas chmod 755 /etc/rc.d/dserver
```

### Rexification

This is the task for setting it up via Rex. Note the `. . . .`, that's a placeholder which we will fill up more and more during this blog post:

```
desc 'Setup DTail';
task 'dtail', group => 'frontends',
   sub {
      my $restart = FALSE;

      file '/etc/rc.d/dserver':
        content => template('./etc/rc.d/dserver.tpl'),
        owner => 'root',
        group => 'wheel',
        mode => '755',
        on_change => sub { $restart = TRUE };

        .
        .
        .
        .

      service 'dserver' => 'restart' if $restart;
      service 'dserver', ensure => 'started';
   };
```

## Configure it

Now, DTail is fully installed but still needs to be configured. Grab the default config file from GitHub ...

```
$ doas mkdir /etc/dserver
$ curl https://raw.githubusercontent.com/mimecast/dtail/master/samples/dtail.json.sample |
    doas tee /etc/dserver/dtail.json
```

... and then edit it and adjust `LogDir` in the `Common` section to `/var/log/dserver`. The result will look like this:

```
  "Common": {
    "LogDir": "/var/log/dserver",
    "Logger": "Fout",
    "LogRotation": "Daily",
    "CacheDir": "cache",
    "SSHPort": 2222,
    "LogLevel": "Info"
  }
```

### Rexification

That's as simple as adding the following to the Rex task:

```
file '/etc/dserver',
  ensure => 'directory';

file '/etc/dserver/dtail.json',
  content => template('./etc/dserver/dtail.json.tpl'),
  owner => 'root',
  group => 'wheel',
  mode => '755',
  on_change => sub { $restart = TRUE };
```

## Update the key cache for it

DTail relies on SSH for secure authentication and communication. However, the system user `_dserver` has no permission to read the SSH public keys from the user's home directories, so the DTail server also checks for available public keys in an alternative path `/var/run/dserver/cache`. 

The following script, populating the DTail server key cache, can be run periodically via `CRON`:

```
$ cat <<'END' | doas tee /usr/local/bin/dserver-update-key-cache.sh
#!/bin/ksh

CACHEDIR=/var/run/dserver/cache
DSERVER_USER=_dserver
DSERVER_GROUP=_dserver

echo 'Updating SSH key cache'

ls /home/ | while read remoteuser; do
    keysfile=/home/$remoteuser/.ssh/authorized_keys

    if [ -f $keysfile ]; then
        cachefile=$CACHEDIR/$remoteuser.authorized_keys
        echo "Caching $keysfile -> $cachefile"

        cp $keysfile $cachefile
        chown $DSERVER_USER:$DSERVER_GROUP $cachefile
        chmod 600 $cachefile
    fi
done

# Cleanup obsolete public SSH keys
find $CACHEDIR -name \*.authorized_keys -type f |
while read cachefile; do
    remoteuser=$(basename $cachefile | cut -d. -f1)
    keysfile=/home/$remoteuser/.ssh/authorized_keys

    if [ ! -f $keysfile ]; then
        echo 'Deleting obsolete cache file $cachefile'
        rm $cachefile
    fi
done

echo 'All set...'
END
$ doas chmod 500 /usr/local/bin/dserver-update-key-cache.sh
```

Note that the script above is a slight variation of the official DTail script. The official DTail one is a `bash` script, but on OpenBSD, there's `ksh`. I run it once daily by adding it to the `daily.local`:

```
$ echo /usr/local/bin/dserver-update-key-cache.sh | doas tee -a /etc/daily.local
/usr/local/bin/dserver-update-key-cache.sh
```

### Rexification

That's done by adding ...

```
file '/usr/local/bin/dserver-update-key-cache.sh',
  content => template('./scripts/dserver-update-key-cache.sh.tpl'),
  owner => 'root',
  group => 'wheel',
  mode => '500';

append_if_no_such_line '/etc/daily.local', '/usr/local/bin/dserver-update-key-cache.sh';
```

... to the Rex task!

## Start it

Now, it's time to enable and start the DTail server:

```
$ sudo rcctl enable dserver
$ sudo rcctl start dserver
$ tail -f /var/log/dserver/*.log
INFO|1022-090634|Starting scheduled job runner after 2s
INFO|1022-090634|Starting continuous job runner after 2s
INFO|1022-090644|24204|stats.go:53|2|11|7|||MAPREDUCE:STATS|currentConnections=0|lifetimeConnections=0
INFO|1022-090654|24204|stats.go:53|2|11|7|||MAPREDUCE:STATS|currentConnections=0|lifetimeConnections=0
INFO|1022-090719|Starting server|DTail 4.1.0 Protocol 4.1 Have a lot of fun!
INFO|1022-090719|Generating private server RSA host key
INFO|1022-090719|Starting server
INFO|1022-090719|Binding server|0.0.0.0:2222
INFO|1022-090719|Starting scheduled job runner after 2s
INFO|1022-090719|Starting continuous job runner after 2s
INFO|1022-090729|86050|stats.go:53|2|11|7|||MAPREDUCE:STATS|currentConnections=0|lifetimeConnections=0
INFO|1022-090739|86050|stats.go:53|2|11|7|||MAPREDUCE:STATS|currentConnections=0|lifetimeConnect
.
.
.
Ctr+C
```

As we don't want to wait until tomorrow, let's populate the key cache manually:

```
$ doas /usr/local/bin/dserver-update-key-cache.sh
Updating SSH key cache
Caching /home/_dserver/.ssh/authorized_keys -> /var/cache/dserver/_dserver.authorized_keys
Caching /home/admin/.ssh/authorized_keys -> /var/cache/dserver/admin.authorized_keys
Caching /home/failunderd/.ssh/authorized_keys -> /var/cache/dserver/failunderd.authorized_keys
Caching /home/git/.ssh/authorized_keys -> /var/cache/dserver/git.authorized_keys
Caching /home/paul/.ssh/authorized_keys -> /var/cache/dserver/paul.authorized_keys
Caching /home/rex/.ssh/authorized_keys -> /var/cache/dserver/rex.authorized_keys
All set...
```

## Use it

The DTail server is now ready to serve connections. You can use any DTail commands, such as `dtail`, `dgrep`, `dmap`, `dcat`, `dtailhealth`, to do so. Checkout out all the usage examples on the official DTail page.

I have installed DTail server this way on my personal OpenBSD frontends `blowfish`, and `fishfinger`, and the following command connects as user `rex` to both machines and greps the file `/etc/fstab` for the string `local`:

```
❯ ./dgrep -user rex -servers blowfish.buetow.org,fishfinger.buetow.org --regex local /etc/fstab
CLIENT|earth|WARN|Encountered unknown host|{blowfish.buetow.org:2222 0xc0000a00f0 0xc0000a61e0 [blowfish.buetow.org]:2222 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9ZnF/LAk14SgqCzk38yENVTNfqibcluMTuKx1u53cKSp2xwHWzy0Ni5smFPpJDIQQljQEJl14ZdXvhhjp1kKHxJ79ubqRtIXBlC0PhlnP8Kd+mVLLHYpH9VO4rnaSfHE1kBjWkI7U6lLc6ks4flgAgGTS5Bb7pLAjwdWg794GWcnRh6kSUEQd3SftANqQLgCunDcP2Vc4KR9R78zBmEzXH/OPzl/ANgNA6wWO2OoKKy2VrjwVAab6FW15h3Lr6rYIw3KztpG+UMmEj5ReexIjXi/jUptdnUFWspvAmzIl6kwzzF8ExVyT9D75JRuHvmxXKKjyJRxqb8UnSh2JD4JN [23.88.35.144]:2222 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9ZnF/LAk14SgqCzk38yENVTNfqibcluMTuKx1u53cKSp2xwHWzy0Ni5smFPpJDIQQljQEJl14ZdXvhhjp1kKHxJ79ubqRtIXBlC0PhlnP8Kd+mVLLHYpH9VO4rnaSfHE1kBjWkI7U6lLc6ks4flgAgGTS5Bb7pLAjwdWg794GWcnRh6kSUEQd3SftANqQLgCunDcP2Vc4KR9R78zBmEzXH/OPzl/ANgNA6wWO2OoKKy2VrjwVAab6FW15h3Lr6rYIw3KztpG+UMmEj5ReexIjXi/jUptdnUFWspvAmzIl6kwzzF8ExVyT9D75JRuHvmxXKKjyJRxqb8UnSh2JD4JN 0xc0000a2180}
CLIENT|earth|WARN|Encountered unknown host|{fishfinger.buetow.org:2222 0xc0000a0150 0xc000460110 [fishfinger.buetow.org]:2222 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNiikdL7+tWSN0rCaw1tOd9aQgeUFgb830V9ejkyJ5h93PKLCWZSMMCtiabc1aUeUZR//rZjcPHFLuLq/YC+Y3naYtGd6j8qVrcfG8jy3gCbs4tV9SZ9qd5E24mtYqYdGlee6JN6kEWhJxFkEwPfNlG+YAr3KC8lvEAE2JdWvaZavqsqMvHZtAX3b25WCBf2HGkyLZ+d9cnimRUOt+/+353BQFCEct/2mhMVlkr4I23CY6Tsufx0vtxx25nbFdZias6wmhxaE9p3LiWXygPWGU5iZ4RSQSImQz4zyOc9rnJeP1rwGk0OWDJhdKNXuf0kIPdzMfwxv2otgY32/DJj6L [46.23.94.99]:2222 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNiikdL7+tWSN0rCaw1tOd9aQgeUFgb830V9ejkyJ5h93PKLCWZSMMCtiabc1aUeUZR//rZjcPHFLuLq/YC+Y3naYtGd6j8qVrcfG8jy3gCbs4tV9SZ9qd5E24mtYqYdGlee6JN6kEWhJxFkEwPfNlG+YAr3KC8lvEAE2JdWvaZavqsqMvHZtAX3b25WCBf2HGkyLZ+d9cnimRUOt+/+353BQFCEct/2mhMVlkr4I23CY6Tsufx0vtxx25nbFdZias6wmhxaE9p3LiWXygPWGU5iZ4RSQSImQz4zyOc9rnJeP1rwGk0OWDJhdKNXuf0kIPdzMfwxv2otgY32/DJj6L 0xc0000a2240}
Encountered 2 unknown hosts: 'blowfish.buetow.org:2222,fishfinger.buetow.org:2222'
Do you want to trust these hosts?? (y=yes,a=all,n=no,d=details): a
CLIENT|earth|INFO|STATS:STATS|cgocalls=11|cpu=8|connected=2|servers=2|connected%=100|new=2|throttle=0|goroutines=19
CLIENT|earth|INFO|Added hosts to known hosts file|/home/paul/.ssh/known_hosts
REMOTE|blowfish|100|7|fstab|31bfd9d9a6788844.h /usr/local ffs rw,wxallowed,nodev 1 2
REMOTE|fishfinger|100|7|fstab|093f510ec5c0f512.h /usr/local ffs rw,wxallowed,nodev 1 2
```

Running it the second time, and given that you trusted the keys the first time, it won't prompt you for the host keys anymore:

```
❯ ./dgrep -user rex -servers blowfish.buetow.org,fishfinger.buetow.org --regex local /etc/fstab
REMOTE|blowfish|100|7|fstab|31bfd9d9a6788844.h /usr/local ffs rw,wxallowed,nodev 1 2
REMOTE|fishfinger|100|7|fstab|093f510ec5c0f512.h /usr/local ffs rw,wxallowed,nodev 1 2
```

## Conclusions

It's a bit of manual work, but it's ok on this small scale! I shall invest time in creating an official OpenBSD port, though. That would render most of the manual steps obsolete, as outlined in this post!

Check out the following for more information:

[https://dtail.dev](https://dtail.dev)  
[https://github.com/mimecast/dtail](https://github.com/mimecast/dtail)  
[https://www.rexify.org](https://www.rexify.org)  

Other related posts are:

[2022-10-30 Installing DTail on OpenBSD (You are currently reading this)](./2022-10-30-installing-dtail-on-openbsd.md)  
[2022-03-06 The release of DTail 4.0.0](./2022-03-06-the-release-of-dtail-4.0.0.md)  
[2021-04-22 DTail - The distributed log tail program](./2021-04-22-dtail-the-distributed-log-tail-program.md)  

E-Mail your comments to hi@foo.zone :-)

[Back to the main site](../)  
