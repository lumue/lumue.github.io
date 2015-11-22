---
layout : post
title :  running ntopng on ubuntu 14.04
tags:
 - linux
 - network
 - monitoring
 - sysadmin
update : 2015-11-22 00:00:00
---

# running ntopng on ubuntu 14.04

## starting nprobe

``
sudo nprobe --zmq tcp://*:5556 -i none -n none -b 2 -3 9996 -G
``

## starting ntopng

``
sudo ntopng -i tcp://127.0.0.1:5556 -e -F
``