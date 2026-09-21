# KISS server monitoring with Gogios

> Published at 2023-06-01T21:10:17+03:00

Gogios is a minimalistic and easy-to-use monitoring tool I programmed in Google Go designed specifically for small-scale self-hosted servers and virtual machines. The primary purpose of Gogios is to monitor my personal server infrastructure for `foo.zone`, my MTAs, my authoritative DNS servers, my NextCloud, Wallabag and Anki sync server installations, etc.

It runs standard Nagios check plugins and is meant for a handful of hosts. In theory, Gogios scales to a couple of thousand checks, though. You can clone it from GitHub here:

=> https://github.com/snonux/gogios

=> ./kiss-server-monitoring-with-gogios/gogios-small.png Gogios logo

<< template::inline::toc

```
    _____________________________    ____________________________
   /                             \  /                            \
  |    _______________________    ||    ______________________    |
  |   /                       \   ||   /                      \   |
  |   | # Alerts with status c|   ||   | # Unhandled alerts:  |   |
  |   | hanged:               |   ||   |                      |   |
  |   |                       |   ||   | CRITICAL: Check Pizza|   |
  |   | OK->CRITICAL: Check Pi|   ||   | : Late delivery      |   |
  |   | zza: Late delivery    |   ||   |                      |   |
  |   |                       |   ||   | WARNING: Check Thirst|   |
  |   |                       |   ||   | : OutofKombuchaExcept|   |
  |   \_______________________/   ||   \______________________/   |
  |  /|\ GOGIOS MONITOR 1    _    ||  /|\ GOGIOS MONITOR 2   _    |
   \_____________________________/  \____________________________/
     !_________________________!      !________________________!

------------------------------------------------
ASCII art was modified by Paul Buetow
The original can be found at
https://asciiart.website/index.php?art=objects/computers
```

## Motivation

I have used Nagios, Icinga, Prometheus and OpsGenie before. For personal use, they all come with way more than I need. Contact groups, host groups, check clustering, and the requirement of operating a DBMS and a WebUI added complexity and bloat to my monitoring setup.

My primary goal was to have a single email address for notifications and a simple mechanism to periodically execute standard Nagios check scripts and notify me of any state changes. I wanted the most minimalistic monitoring solution possible but wasn't satisfied with the available options.

So I wrote Gogios. I chose Go as it comes, in my opinion, with the best balance of ease of use and performance.

## Features

* Runs standard Nagios check plugins, so all existing plugins work.
* Small and easy to set up.
* Check timeout and concurrency are configurable.
* A check can depend on another check, e.g. don't run the HTTP check when the host isn't pingable.
* Retries and retry intervals are configurable per check.
* Sends an E-Mail when a check changes its state.
* Runs periodically from CRON.

## Example alert

This is an example alert report received via E-Mail. Whereas, `[C:2 W:0 U:0 OK:51]` means that we've got two alerts in status critical, 0 warnings, 0 unknowns and 51 OKs.

```
Subject: GOGIOS Report [C:2 W:0 U:0 OK:51]

This is the recent Gogios report!

# Alerts with status changed:

OK->CRITICAL: Check ICMP4 vulcan.buetow.org: Check command timed out
OK->CRITICAL: Check ICMP6 vulcan.buetow.org: Check command timed out

# Unhandled alerts:

CRITICAL: Check ICMP4 vulcan.buetow.org: Check command timed out
CRITICAL: Check ICMP6 vulcan.buetow.org: Check command timed out

Have a nice day!
```

## Installation

### Compiling and installing Gogios

This document is primarily written for OpenBSD, but applying the corresponding steps to any Unix-like (e.g. Linux-based) operating system should be easy. On systems other than OpenBSD, you may always have to replace `does` with the `sudo` command and replace the `/usr/local/bin` path with `/usr/bin`.

To compile and install Gogios on OpenBSD, follow these steps:

```shell
git clone https://github.com/snonux/gogios.git
cd gogios
go build -o gogios cmd/gogios/main.go
doas cp gogios /usr/local/bin/gogios
doas chmod 755 /usr/local/bin/gogios
```

You can use cross-compilation if you want to compile Gogios for OpenBSD on a Linux system without installing the Go compiler on OpenBSD. Follow these steps:

```shell
export GOOS=openbsd
export GOARCH=amd64
go build -o gogios cmd/gogios/main.go
```

On your OpenBSD system, copy the binary to `/usr/local/bin/gogios` and set the correct permissions as described in the previous section. All steps described here you could automate with your configuration management system of choice. I use Rexify, the friendly configuration management system, to automate the installation, but that is out of the scope of this document.

=> https://www.rexify.org

### Setting up user, group and directories

Gogios should run as its own system user. On OpenBSD, create the `_gogios` user and group like this:

```shell
doas adduser -group _gogios -batch _gogios
doas usermod -d /var/run/gogios _gogios
doas mkdir -p /var/run/gogios
doas chown _gogios:_gogios /var/run/gogios
doas chmod 750 /var/run/gogios
```

### Installing monitoring plugins

Gogios relies on external Nagios or Icinga monitoring plugin scripts. On OpenBSD, install the `monitoring-plugins` package:

```shell
doas pkg_add monitoring-plugins
doas pkg_add nrpe # If you want to execute checks remotely via NRPE.
```

Once the installation is complete, you can find the monitoring plugins in the `/usr/local/libexec/nagios` directory, which then can be configured to be used in `gogios.json`.

## Configuration

### MTA

Gogios requires a local Mail Transfer Agent (MTA) such as Postfix or OpenBSD SMTPD running on the same server where the CRON job (see about the CRON job further below) is executed.

To check that mail delivery works, send yourself a test E-Mail:

```
echo 'This is a test email from OpenBSD.' | mail -s 'Test Email' your-email@example.com
```

If it doesn't arrive, check the MTA logs.

### Configuring Gogios

To configure Gogios, create a JSON configuration file (e.g., `/etc/gogios.json`). Here's an example configuration:

```json
{
  "EmailTo": "paul@dev.buetow.org",
  "EmailFrom": "gogios@buetow.org",
  "CheckTimeoutS": 10,
  "CheckConcurrency": 2,
  "StateDir": "/var/run/gogios",
  "Checks": {
    "Check ICMP4 www.foo.zone": {
      "Plugin": "/usr/local/libexec/nagios/check_ping",
      "Args": [ "-H", "www.foo.zone", "-4", "-w", "50,10%", "-c", "100,15%" ],
      "Retries": 3,
      "RetryInterval": 10
    },
    "Check ICMP6 www.foo.zone": {
      "Plugin": "/usr/local/libexec/nagios/check_ping",
      "Args": [ "-H", "www.foo.zone", "-6", "-w", "50,10%", "-c", "100,15%" ],
      "Retries": 3,
      "RetryInterval": 10
    },
    "www.foo.zone HTTP IPv4": {
      "Plugin": "/usr/local/libexec/nagios/check_http",
      "Args": ["www.foo.zone", "-4"],
      "DependsOn": ["Check ICMP4 www.foo.zone"]
    },
    "www.foo.zone HTTP IPv6": {
      "Plugin": "/usr/local/libexec/nagios/check_http",
      "Args": ["www.foo.zone", "-6"],
      "DependsOn": ["Check ICMP6 www.foo.zone"]
    }
    "Check NRPE Disk Usage foo.zone": {
      "Plugin": "/usr/local/libexec/nagios/check_nrpe",
      "Args": ["-H", "foo.zone", "-c", "check_disk", "-p", "5666", "-4"]
    }
  }
}
```

* `EmailTo`: Where the notifications go.
* `EmailFrom`: The sender address.
* `CheckTimeoutS`: Check timeout in seconds.
* `CheckConcurrency`: How many checks run in parallel.
* `StateDir`: Specifies the directory where Gogios stores its persistent state in a `state.json` file. 
* `Checks`: Defines a list of checks to be performed, each with a unique name, plugin path, and arguments.

Adjust the configuration file according to your needs, specifying the checks you want Gogios to perform.

If you want to execute checks only when another check succeeded (status OK), use `DependsOn`. In the example above, the HTTP checks won't run when the hosts aren't pingable. They will show up as `UNKNOWN` in the report.

`Retries` and `RetryInterval` are optional check configuration parameters. In case of failure, Gogios will retry `Retries` times each `RetryInterval` seconds.

For remote checks, use the `check_nrpe` plugin. You also need to have the NRPE server set up correctly on the target host (out of scope for this document).

The `state.json` file mentioned above keeps track of the monitoring state and check results between Gogios runs, enabling Gogios only to send email notifications when there are changes in the check status.

## Running Gogios

Now it is time to give it a first run. On OpenBSD, do:

```shell
doas -u _gogios /usr/local/bin/gogios -cfg /etc/gogios.json
```

To run Gogios via CRON on OpenBSD as the `gogios` user and check all services once per minute, follow these steps:

Type `doas crontab -e -u _gogios` and press Enter to open the crontab file for the `_gogios` user for editing and add the following lines to the crontab file:

```
*/5 8-22 * * * /usr/local/bin/gogios -cfg /etc/gogios.json
0 7 * * * /usr/local/bin/gogios -renotify -cfg /etc/gogios.json
```

Gogios is now configured to run every five minutes from 8 am to 10 pm via CRON as the `_gogios` user. It will execute the checks and send monitoring status whenever a check status changes via email according to your configuration. Also, Gogios will run once at 7 am every morning and re-notify all unhandled alerts as a reminder.

### High-availability

To create a high-availability Gogios setup, you can install Gogios on two servers that will monitor each other using the NRPE (Nagios Remote Plugin Executor) plugin. By running Gogios in alternate CRON intervals on both servers, you can ensure that even if one server goes down, the other will continue monitoring your infrastructure and sending notifications.

* Install Gogios on both servers following the compilation and installation instructions provided earlier.
* Install the NRPE server (out of scope for this document) and plugin on both servers. This plugin allows you to execute Nagios check scripts on remote hosts.
* Configure Gogios on both servers to monitor each other using the NRPE plugin. Add a check to the Gogios configuration file (`/etc/gogios.json`) on both servers that uses the NRPE plugin to execute a check script on the other server. For example, if you have Server A and Server B, the configuration on Server A should include a check for Server B, and vice versa.
* Set up alternate CRON intervals on both servers. Configure the CRON job on Server A to run Gogios at minutes 0, 10, 20, ..., and on Server B to run at minutes 5, 15, 25, ...
* Gogios doesn't support clustering. So it means when both servers are up, unhandled alerts will be notified via E-Mail twice; from each server once. That's the trade-off for simplicity.

There are plans to make it possible to execute certain checks only on certain nodes (e.g. on elected leader or master nodes). This is still in progress (check out my Gorum Git project).

## Conclusion

That's Gogios. I use it to run around 500 checks on my personal servers, and I am very happy with it.

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other KISS-related posts are:

<< template::inline::rindex kiss simple-and-stupid

=> ../ Back to the main site
