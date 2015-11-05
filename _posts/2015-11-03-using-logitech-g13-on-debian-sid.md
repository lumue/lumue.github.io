---
layout : layout
title :  Using a Logitech G13 gaming keypad on debian sid
tags:
 - linux
 - gaming
---

# Using a Logitech G13 gaming keypad on debian sid

This is a short HOWTO on setting up g13d as a systemd controlled service on debian linux.  
If you just want to use your g13 and dont care about how it is done, fair enough: I compiled what is described here into a bunch of shell scripts ready to checkout and execute for you from [here](https://github.com/lumue/g13d-service).

## checkout and build

go to [https://github.com/ecraven/g13](https://github.com/ecraven/g13), checkout their repo and follow the installation instructions.
    
    git clone https://github.com/ecraven/g13.git
    cd g13
    make

## installation


copy the ``g13d`` binary to ``/usr/bin/g13d`` or make it otherwise accesible on your path.

    sudo cp g13d /usr/bin/g13d && sudo chmod a+x /usr/bin/g13d
    
create a start script g13d-run to init the bindings and start g13d and put it in ``/usr/bin``

    sudo touch /usr/bin/g13d-run && sudo chmod a+x/usr/bing13d-run
    
open the file and paste the following script:

    #!/usr/bin/env bash
    G13D_WORK="/tmp/g13d"
    
    if [ -d G13D_WORK ]
    then
        echo "using existing $G13D_WORK as working directory ..."
    else
        echo "creating $G13D_WORK as working directory ..."
        mkdir "$G13D_WORK"
    fi
    
    cd "$G13D_WORK"
    cat /etc/g13d.d/default.bind >> /tmp/g13-0
    /usr/bin/g13d
    
### setup systemd service
    
create a start script for the service named ``g13d-service`` and save it in ``/etc/init.d``

    sudo touch /etc/init.d/g13d-service && sudo chmod a+x /etc/init.d/g13d-service
    
open the file and paste the following script:

    #!/bin/bash
    G13D_HOME="/usr/lib/g13d"
    PID=""
    
    function get_pid {
       PID=`pidof g13d`
    }
    
    function stop {
       get_pid
       if [ -z $PID ]; then
          echo "server is not running."
          exit 1
       else
          echo -n "Stopping server.."
          kill -9 $PID
          sleep 1
          echo ".. Done."
       fi
    }
    
    
    function start {
       get_pid
       if [ -z $PID ]; then
          echo  "Starting server.."
            (/usr/bin/g13d-run &> /dev/null  &) &
          get_pid
          echo "Done. PID=$PID"
       else
          echo "server is already running, PID=$PID"
       fi
    }
    
    function restart {
       echo  "Restarting server.."
       get_pid
       if [ -z $PID ]; then
          start
       else
          stop
          sleep 5
          start
       fi
    }
    
    
    function status {
       get_pid
       if [ -z  $PID ]; then
          echo "Server is not running."
          exit 1
       else
          echo "Server is running, PID=$PID"
       fi
    }
    
    case "$1" in
       start)
          start
       ;;
       stop)
          stop
       ;;
       restart)
          restart
       ;;
       status)
          status
       ;;
       *)
          echo "Usage: $0 {start|stop|restart|status}"
    esac

create a systemd .service script for the service named ``g13d-service.service`` and save it in ``/lib/systemd/g13d-service.service``

    sudo touch /lib/systemd/g13d-service.service && sudo chmod a+x /lib/systemd/g13d-service.service
    
open the file and paste the following script:

    [Unit]
    Description=Start g13d-service
    
    [Service]
    WorkingDirectory=/tmp/g13d
    Type=forking
    ExecStart=/bin/bash /etc/init.d/g13d-service start
    KillMode=process
    
    [Install]
    WantedBy=multi-user.target

### setup default bindings

create a directory ``/etc/g13d.d`` and put your bindings in a file named ``/etc/g13d.d/default.bind``

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
    
Now execute 

    sudo systemctl daemon-reload
    sudo systemctl enable g13d-service.service

to install the service, and we are done!

## Running 

Now you can control g13d like any other service on your box. just issue
    
    sudo systemctl status g13d-service

to start the service.

