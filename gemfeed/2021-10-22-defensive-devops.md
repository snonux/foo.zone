# Defensive DevOps

```
                                                            c=====e
                                                               H
      ____________                                         _,,_H__
     (__((__((___()                                       //|     |
    (__((__((___()()_____________________________________// |ACME |
   (__((__((___()()()------------------------------------'  |_____|
                           ASCII Art by Clyde Watson
```

> Published by Paul Buetow 2021-10-22

I have seen many different setups and infrastructures during my carreer. My roles always included front-line ad-hoc fire fighting production issues. This often involves identifying and fixing these under time pressure, without the comfort of 2-week-long SCRUM sprints and without an exhaustive QA process. I also wrote a lot of code (Bash, Ruby, Perl, Go, and a little Java), and I followed the typical software development process, but that did not always apply to critical production issues.

Unfortunately, no system is 100% reliable, and you can never be prepared for a subset of the possible problem-space. IT infrastructures can be complex. Not even mentioning Kubernetes yet, a Microservice-based infrastructure can complicate things even further. You can take care of 99% of all potential problems by following all DevOps best practices. Those best practices are not the subject of this blog post; this post is about the sub 1% of the issues arising from nowhere you can't be prepared for. 

Is there a software bug in a production, even though the software passed QA (after all, it is challenging to reproduce production behaviour in an artificial testing environment) and the software didn't show any issues running in production until a special case came up just now after it got deployed to production a week ago? Are there multiple hardware failure happening which causes loss of service redundancy or data inaccessibility? Is the automation of external customers connected to our infrastructure putting unexpectedly extra pressure on your grid, driving higher latencies and putting the SLAs at risk? You bet the solution is: Sysadmins, SREs and DevOps Engineers to the rescue. 

You agree that fixing production issues this way is not proactive but rather reactive. I prefer to call it defensive, though, as you "defend" your system against a production issue. But, at the same time, you have to take a cautious (defensive) approach to fix it, as you don't want to make things worse. 

Over time, I have compiled a list of fire-fighting automation strategies, which I would like to share here. 

## Meet Defensive DevOps

Defensive DevOps is a term I invented by myself. I define it this way:

* It is the practice of automating production issues away ASAP as they appear. 
* For rapid development, ignore most of the CI and QA best practices.
* Ignore the SCRUM process (if your team does SCRUM), as it will take too long to implement a solution. 
* Be extremely careful (defensive) executing any fixing code in production, taking all failure scenarios into consideration and always have a rollback plan at hand. 
* Still deliver a high-quality solution so that no customer will ever notice that there was an issue in the first place.

That sounds a bit crazy, but this is, unfortunately, in rare occasions the reality. As the question is not whether production issues will happen, the question is WHEN they will happen. Every large provider, such as Google, Netflix, and so on, suffered significant outages before, and I firmly believe that their engineers know what they are doing. But you can prepare for the unexpected only to a certain degree.

## Don't fully automate from the beginning

Do you have to solve problem X? The best solution would be to fully automate it away, correct? No, the best way is to fix problem X manually first. Does the problem appear on one server or on thousand servers? The scale does not matter here. The point is that you should fix the problem at least once manually, so you understand the problem and how to solve it before implementing automation around it.

You should also have a short meeting with your team. Every person may has a different perspective and can give valuable input for determining the best strategy. But, again, keep the session short and efficient. Focus on the facts. After all, you are the domain expert and you probably know what you are doing.

Once you understand the problem, fix it on a different server again. This time maybe write a small program or script. Semi-automate the process, but don't fully automate it yet. Start the semi-automated solution manually on a couple of more servers and observe the result. You want to gain more confidence that this really solved the problem. This can take a couple of hours manually running it over and over again. During that process, you will improve your script iteratively.

## Develop code directly on production systems

You have to develop code directly on a production system. This sounds a bit controversial, but you want to get a working solution ASAP, and there is a very high chance that you can't reproduce problem X in a development or QA environment. Or at least it will consume significant effort and time to reproduce the problem, and by the time your code is ready, it's already too late. So the most practical solution is to directly develop your solution against a production system with the problem at hand. 

You might not have your full-featured IDE available on a production system, but a text editor, such as Vim (or Neovim), is sufficient for writing scripts. Some editors allow you to edit files remotely. With Vim you can accomplish it with "vim scp://SERVER///path/to/file.sh". Every time you save the file, it will be automatically uploaded via SCP to the server. From there, you can execute it directly. This comes with the additional benefits of still having access to all the Vim plugins installed locally, which you might not have installed on any production machines. This approach also removes any network delays you might experience when running your editor directly on a remote machine. 

Unfortunately, it will be a bit more complicated when you rely on code reviews (e.g. in a FIPS environment). Pair-programming could be the solution here.

### Don't make it worse

You want to triple-check that your script is not damaging your system even further. You might introduce a bug to the code, so there should always be a way to roll back any permanent change it causes. You have to program it in a defensive style:

* Make sure that all that your script does is logged to a file. Best, when it's a Bash script, use "set -x". This makes the script print all commands as they are executed. Always write the output to a file. This helps to verify that your script is working as intended. The log output should always include timestamps for each significant operation performed.
* Make sure that no command executed by your script is failing. You should use "set -e" in your script, which makes the whole script terminate immediately if a command in it exits with a non-zero status. This will save you from apparent errors, e.g. trying to move files to a non-existent directory or trying to operate on a non-existent file. 
* Your script should never delete any files. If solving problem X involves deleting files, don't delete them but rename or move them to a separate directory so that these can be recovered just in case. 
* When you rename/move files around, always add a timestamp to a directory or the end of the file name (e.g. with "mv FILE FILE.$(date +%s"). This ensures that a backup never gets overwritten by another backup during a subsequential run of your script. Alternatively, before renaming a file, check whether the destination file already exists or not. 
* When solving problem X involves manipulating files in place, be ultra-cautious. Best try to avoid in-place file manipulation. But if you really have to, you should, if disk space permits, always create a backup of the file first. Depending on the particular case, you might add a timestamp to the backup or only keep the very first initial backup of a file.
* You should implement a "--dry" switch in your script. When you run the script in dry mode, it won't manipulate anything on the system, but it would only print out what it would do. Always run your script in dry mode before running it for real. 

Furthermore, when you write Bash script, always run the tool ShellSheck (https://shellshock.io/) on it. This helps to catch many potential issues before applying it in production. 

## Test your code

You probably won't have time for writing unit tests. But what you can do is to pedantically test your code manually. But you have to do the testing on a production machine. So how can you test your code in production without causing more damage? 

Your script should be idempotent. This means you can run it infinite times in a row, and you will always get the same result. For example, in the first run of the script, a file A get's renamed to A.backup. The second time you run the script, it attempts to do the same, but it recognises that A has already been renamed to A.backup and then it is skipping that step. This is very helpful for manually testing, as it means that you can re-run the script every time you extended it. You should dry-run the script at least once before running it for real. You can apply the same principle for almost all features you add to the code.  

You may also want to inject manual negative testing into your script. For example, you want to run a particular function F in your script but only if a certain pre-condition is met, and you want to ensure that the code branching works as expected. The pre-condition check could be pretty complex (e.g. N log messages containing a specific warning string are found in the applications logs, but only on the cluster leader server). You can flip the switch directly in the code manually (e.g. run F only, when the pre-condition isn't met) and then perform a dry run of the script and study the output. Once done, flip the switch back to its correct configuration. For double insurance, test the same on a different server type (e.g. on a follower and not on a leader system).

By following these principles, you test every line of code while you are developing on it. 

## Automation

At one point, you will be tired of manually running your script and also confident enough to automate it. You could deploy it with a configuration management system such as puppet Puppet and schedule a periodic execution via cron, a systemd timer or even a separate background daemon process. You have to be extremely careful here. The more you automate, the more damage you can cause. You don't want to automate it on all servers involved at once, but you want to slowly ramp up the automation. 

First, automate it only on one single server and monitor the result closely. At first, only automate running the script in dry mode. Also, don't forget that you still should log everything that the script is doing. Once everything looks fine, you can automate the script on the canary server for real. It shouldn't be a disaster if something goes wrong as usually systems are designed in a HA fashion, where the same data is still at least on another server available. In the worst-case scenario, you could recover data from there or from the local backup files your script created.

Now, you can add a handful more canary servers to the automation. You should keep close attention to what the automation is doing. You could use a tool like DTail for distributed log file following. At this point, you could also think of deploying a monitoring check (e.g. Icinga) to see whether your script is not terminating abnormally or logging warnings or errors.

[DTail - The distributed log tail program](./2021-04-22-dtail-the-distributed-log-tail-program.md)  

From there, you could automate the solution on more and more servers. Best, ramp up the automation to a handful of systems, and later to a whole line of servers (e.g. all secondary servers of a given cluster). And afterwards, automate it on all servers.

Remember, whenever something goes wrong, you will have plenty of logs and backup files available. The disaster recovery would involve extending your script to take care of that too or writing a new script for rolling back the backups. 

## Out of office hours

If possible, don't deploy any automation shortly before out of office hours, such as in the evening, before holidays or weekends. The only exception would be that you, or someone else, will be available to monitor the automation out of office hours. If it is a critical issue, someone, for example, the on-call person, could take over. Or ask your boss to work now but to take off another day to compensate.

You should add an easy off-switch to your automation so that everyone from your team knows how to pause it if something goes wrong in order to adjust the automation accordingly. Of course, you should still follow all the principles mentioned in this blog post when making any changes. 

## Retrospective

For every major incident, you need to follow up with an incident retrospective. A blame-free, detailed description of exactly what went wrong to cause the incident, along with a list of steps to take to prevent a similar incident from occurring again in the future.

This usually means creating one or more tickets, which will be dealt with soon. Once the permanent fix is deployed, you can remove your ad-hoc automation and monitoring around it and focus on your regular work again.

E-Mail me your comments to snonux@snonux.de!

[Go back to the main site](../)  
