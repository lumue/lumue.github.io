---
layout : post
title : Packaging a spring-boot application for distribution with docker
tags:
 - docker
 - java
 - devops
 - spring
 - spring-boot
 - coding
 - project automation
update : 2015-11-22 00:00:00
---

# Packaging a spring-boot application for distribution

## But how

Over the last couple of weeks i built a little [web application](https://github.com/lumue/getdown) which allows for downloading files to a server. think headless version of jdownloader. because i wanted to try out some stuff like spring-boot,reactor,webcomponents, papyrus, websockets. and because i had use for a headless version of jdownloader.  
Anyway, it's ready now for installation, and i want to package the application jar along with a script which allows it to run as a service and an external config file.
But it turns out, imho, there is no really clean and portable way of doing so.  

## Docker!

So i am going to do this with [docker](https://www.docker.com/). which seems to be the hip way to do it nowadays anyway.  
And it turns out, there are even docker plugins for [maven](https://github.com/spotify/docker-maven-plugin) and [gradle](https://github.com/Transmode/gradle-docker) which let you build an docker image from a Dockerfile. Yay!  
As you see, this is really easy to accomplish, and as a bonus you get to control the environment your app is deployed in.  
which translates for me to: Java 8 anywhere :)  
Deploying to any major PaaS provider should theoretically work too.


## What it looked like

### build.gradle

add this to build.gradle

{% highlight groovy %}

buildscript {
    dependencies {
    	classpath('se.transmode.gradle:gradle-docker:1.2')
    }
}

apply plugin: 'docker'

group = 'somehost:5000' //your docker registry location

task buildDocker(type: Docker, dependsOn: build) {
	
	push = true
	applicationName = jar.baseName
	
	dockerfile = file('src/main/docker/Dockerfile')
	
	doFirst {
	  copy {
		from jar
		into stageDir
	  }
	}
	
  }


{% endhighlight %}

## Dockerfile

and the Dockerfile for my application lives ins ``src/main/docker/`` and looks like this :

{% highlight dockerfile %}
FROM jeanblanchard/busybox-java:8
MAINTAINER lm "lm@combase.de"

ADD getdown-app-springboot.jar app.jar
RUN touch /app.jar
CMD mkdir /media
ENTRYPOINT ["java","-jar","/app.jar"]
{% endhighlight %}


