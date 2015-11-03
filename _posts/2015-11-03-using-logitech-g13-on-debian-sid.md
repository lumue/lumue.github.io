---
layout : layout
title :  Using a Logitech G13 gaming keypad on debian sid
tags:
 - linux
---

# Using a Logitech G13 gaming keypad on debian sid

## checkout and build

go to [https://github.com/ecraven/g13](https://github.com/ecraven/g13), checkout their repo and follow the installation instructions.
    
    git clone https://github.com/ecraven/g13.git
    cd g13
    make

## installation

copy the ``g13d`` binary to ``/usr/bin/`` or make it otherwise accesible on your path.

    sudo cp g13d /usr/bin/g13d

create a file containing your bindings

create a directory ``/etc/g13.d`` and put your bindings in a file named ``/etc/g13.d/default.bind``

my bindings file looks like this:

    bind G1 KEY_F1
    bind G2 KEY_F2
    bind G3 KEY_F3
    bind G4 KEY_F4
    bind G5 KEY_F5
    bind G6 KEY_F6
    bind G7 KEY_F7
    bind G8 KEY_1 
    bind G9 KEY_2
    bind G10 KEY_3
    bind G11 KEY_4
    bind G12 KEY_5
    bind G13 KEY_6
    bind G14 KEY_7
    bind G15 KEY_8
    bind G16 KEY_9
    bind G17 KEY_0
    bind G18 KEY_F8
    bind G19 KEY_F9
    bind G20 KEY_F10
    bind G21 KEY_F11
    bind G22 KEY_TAB
    bind DOWN KEY_LEFTALT