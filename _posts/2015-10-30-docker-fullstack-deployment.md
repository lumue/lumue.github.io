---
layout : layout
title : Deploying jee webapplication and rdbms with docker 
tags:
 - linux
 - docker
 - firebird
 - glassfish
 - devops
 - jee
 - java
 - coding
 - project automation
update : 2015-11-22 00:00:00
---

# Deploying jee webapplication and rdbms with docker

I plan to migrate a testing environment comprised of a few jee webapps running on glassfish and connecting to a firebird database to a set of docker containers.
I tried this for one of the application, and here is how it can be done:  

## What will be deployed

Deployment consists of

 * war packaged java webapp
 * glassfish jee container
 * firebird database server
 * datacontainer with prefilled firebird db volume (for testing) 
 * datacontainer with prefilled application working directory (for testing)


## Application state in a container

To setup testing and demo environments it will be useful to have a set of known application states versioned and instantly deployable.
The docker solution to this seems to be setting up  a datacontainer as described [here](https://docs.docker.com/userguide/dockervolumes/).
Since the application i try to deploy here stores its state in the database and in a working directory, we want to fit both in the same container image.

It is recommended to use the same base image for data containers that is used in the other containers which make up your deployment.
This will save you some diskspace, but other than that its irrelevant what you use.

The [Dockerfile](https://github.com/jacobalberty/firebird-docker/blob/master/2.5-ss/Dockerfile) for jacobalberty/firebird:2.5-ss reveals the base image used:

{% highlight dockerfile %}
FROM debian:jessie
{% endhighlight %}

We want our image to expose two volumes. one for database file(s), and one for the work directory.
The Dockerfile below can be used to build this image.

<script src="https://gist.github.com/lumue/6c88a753403b9fe0eaee.js"></script>

It shall be named appdata, for it stores appdata!
to build and run this image execute

{% highlight bash %}
docker build -t <your_repo>/appdata .
docker -d --name appdata <your_repo>/appdata
{% endhighlight %}

check the result by running ``docker ps``. if all went well you should see output like this:

{% highlight bash %}
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
55c6523c4307        18384fe4a822....e558e295   "/bin/bash"         21 minutes ago      Up 18 minutes                           appdata
{% endhighlight %}

which means our datacontainer is up and running.


## Databaseserver

### getting the image

We will use the firebird 2.5 superserver docker image from [jacobalberty/firebird](https://hub.docker.com/r/jacobalberty/firebird/).

{% highlight bash %}
docker pull jacobalberty/firebird:2.5-ss
{% endhighlight %}

### running the container

For a production deployment we would map the exposed database volume to a path in the hosts filesystem (in this case ``/data/firebird/databases``). The image also exposes firebirds default port 3050. We will not expose it on the host machine, but instead build a connection between webapp and   database images later.

{% highlight bash %}
docker run -d --name firebird -v /data/firebird/databases:/databases jacobalberty/firebird:2.5-ss
{% endhighlight %}

But what we want to do is use our datacontainer "appdata" to store the database files. To tell docker about it we have to use the --volumes-from flag when starting the firebird image:

{% highlight bash %}
docker run -d --name firebird --volumes-from appdata jacobalberty/firebird:2.5-ss
{% endhighlight %}

you can verify that the firebird container uses volumes from appdata by attaching to both containers and writing to the /databases directory.
if everything is working as planned, you should see the same content in both containers.

## Application and Applicationserver

### creating the image

To setup the image for glassfish4 plus webapp, we use a custom shell script and a slightly modified version of the official glassfish Dockerfile from docker hub.
both are displayed below.

<script src="https://gist.github.com/lumue/7f88d5e0c54db75c5e70.js"></script>

Lets see whats happening:

#### The build.sh script

 * template domain is packed into a .jar file
 * docker build is executed

#### In the Dockerfile

 * glassfish is downloaded and installed (same as in the official image)
 * .jar file with template domain is added to the image
 * password.txt file containing the admin password is added
 * glassfish domain named webapp is created from the template-domain
 * the domain is started to execute the enable-security-admin command and stopped again

