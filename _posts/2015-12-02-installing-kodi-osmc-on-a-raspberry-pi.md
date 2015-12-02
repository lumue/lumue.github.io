---
layout : layout
title :  Installing kodi on a raspberry pi
tags :
 - kodi
 - osmc
 - linux
 - sysadmin
 - raspberry pi
        
---

# Installing kodi on a raspberry pi

Howto install an image of the [osmc](https://osmc.tv/) [kodi](http://kodi.tv) distribution on a raspberry pi using linux.

## download image

Download the osmc distribution image for raspberry pi and unzip it:

    curl http://download.osmc.tv/installers/diskimages/OSMC_TGT_rbp1_20151129.img.gz
    gunzip OSMC_TGT_vero1_20151129.img.gz

The exact filename for the current image can be found [here](http://osmc.tv/download)

## copy image to sd card

This is the short version. More detailed instructions on howto create a bootable sd card from a disk image can be found [here](https://www.raspberrypi.org/documentation/installation/installing-images/linux.md).
Find out the device name of your sdcard (usually /dev/mmcblk0) and unmount it (if mounted)

    sudo umount /dev/mmcblk0p1

Copy the downloaded image to your sdcard and sync it.

    sudo dd bs=4M if=OSMC_TGT_rbp1_20151129.img of=/dev/mmcblk0 && sync


## done

insert the sdcard in your raspberry, and boot into osmc.


