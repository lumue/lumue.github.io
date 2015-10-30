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
 
## Firebird and Database container

### Firebird

We will use the firebird 2.5 superserver docker image from [jacobalberty/firebird](https://hub.docker.com/r/jacobalberty/firebird/).

{% highlight bash %}
docker pull jacobalberty/firebird:2.5-ss
{% endhighlight %}

For a production deployment we would map the exposed database volume to a path in the hosts filesystem (in this case ``/data/firebird/databases``). The image also exposes firebirds default port 3050. We will not expose it on the host machine, but instead build a connection between webapp and   database images later.

{% highlight bash %}
docker run -d --name firebird -v /data/firebird/databases:/databases jacobalberty/firebird:2.5-ss
{% endhighlight %}

To setup testing and demo environments it would be useful to have datacontainers with various known application states. so i am going to create a datacontainer for the application state.  
The application stores its state in the database and in a working directory. i try to fit both in the same container image because both are inseparable anyway from a application state versioning point of view. 

