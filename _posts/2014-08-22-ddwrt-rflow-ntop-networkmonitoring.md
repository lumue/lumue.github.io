---
layout : layout
title :  LAN Traffic monitoring with dd-wrt
---

#LAN Traffic monitoring with dd-wrt

##My setup
i use an ancient wrt54 running dd-wrt to keep our home devices connected. it has no fancy gbit interfaces or super fast wlan, but aside from the occasional dhcpd crash, it is really a reliable little box. 
i think i have used it for over 9 years now. first with external antennas to connect to the residential community wlan, later when i switched to a dsl land line, as my home router.

![Linksys WRT-54G](/assets/wrt54.jpg)

the firmware i am using is [dd-wrt](www.dd-wrt.com).  
connected to its lan interfaces is a dsl router, my media center, PCs and network storage.  
the wlan interface is used as an AP for mobile devices.

##The Plan!
whats missing is a tool that lets me "see" what is going on inside my home lan and wlan. who is talking to whom, which machine uses how much bandwidth, etc.   
since the wrt is the only device which is connected to lan and wlan, this is where the capturing tool will run. 
for analysis i plan to use ntop on another box.

##How to do it

###Setting up the RFlow probe 
The probing can activated in dd-wrt's web console. The RFlow section is located under services and looks like this:

![RFlow configuration via dd-wrt web console](/assets/dd-wrt-admin-rflow-section.png)



