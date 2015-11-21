---
layout : layout
title :  LAN Traffic monitoring with dd-wrt
tags:
 - linux
 - network
 - monitoring
 - dd-wrt
 - sysadmin
update : 2015-11-22 00:00:00
---

# LAN Traffic monitoring with dd-wrt

## My setup
I use an ancient wrt54 running dd-wrt to keep our home devices connected. it has no fancy gbit interfaces or super fast wlan, but aside from the occasional dhcpd crash, it is really a reliable little box. 
i think i have used it for over 9 years now.  
first with external antennas to connect to the residential community wlan, later when i switched to a dsl land line, i started to use it as my home router and wifi accesspoint..

![Linksys WRT-54G](/assets/wrt54.jpg)

The firmware i am using is [dd-wrt](www.dd-wrt.com).  
connected to its lan interfaces is a dsl router, my media center, PCs and network storage.  
the wlan interface is used as an AP for mobile devices.

##The Plan!
Whats missing is a tool that lets me "see" what is going on inside my home lan and wlan. who is talking to whom, which machine uses how much bandwidth, etc.   
since the wrt54 is the only device which is connected to lan and wlan, this is where the capturing tool will run. 
for data collection and crunching i plan to use ntop on another box.

## How to do it

### Setting up the RFlow probe
The probing can be activated in dd-wrt's web console. The RFlow section is located under services and looks like this:

![RFlow configuration via dd-wrt web console](/assets/dd-wrt-admin-rflow-section.png)

*Server ip* refers to the ntop host.   
*Port* can be any available port on the ntop box.AFAIR there are a few standard ports, and 9996 is apparently one of them.

Save the settings, and the router setup should be complete. easy!

### ntop

#### Installation

```
lm@voyager3:~$ sudo apt-get install ntop*
```

The installation routine asks for a *network interface* to listen on. "none" since the network traffic will be probed somewhere else. next you have to choose a *password* for ntops webinterface.

The designated ntop host is a box running ubuntu 14.04. i use apt-get to install all packages ntop. and again no errors, faults or exception. not even a lowly warning.
almost to easy to blog :D but its not done until its in production as they say.  
next is setting up ntop.

#### Setup

ntop configuration is done in a webui. note that we are doing linux sysadmin stuff, and yet no config file has been touched and no kernel module has been compiled!  
personally, i dont like all this userfriendliness. kids these days.
 
the url is ``http://<ntop-host>:3000``.  

to listen for data from the router on port 9996, ntop requires the configuration of a NetFlow Device. 
 
![the NetFlow Device configuration is located under Plugins/NetFlow/Configure](/assets/ntop-plugin-menu.png)

the NetFlow Device configuration is located under Plugins/NetFlow/Configure.

The first three attributes were all i had to change:

![the NetFlow Device configuration form](/assets/ntop-netflow-configuration.png)

*NetFlow Device* is a name for the device, i used the routers hostname.  
*Local Collector UDP Port* the port we want ntop to listen on. it has to be the same as setup for the rflow probe.  
*Virtual NetFlow Interface Network Address* ip and netmask of the box hosting the rflow probe.  


The last step is switching the nic ntop collects data on to the netflow device.It should be selectable in the admin menu:

![the NetFlow Device configuration form](/assets/ntop-switch-nic.png)


And its done! Data is streaming in and the statistics are filling up.


