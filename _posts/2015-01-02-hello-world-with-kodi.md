---
layout : layout
title :  Hello World! with KODI
tags:
 - xbmc
 - python
 - kodi
---

# "Hello World!" with KODI

I wanted to use the last couple of days before its back to work to take a brief look into the world of xbmc (now KODI!) addon development.  
This post describes how one goes about writing and running the obligatory "hello world!" program with KODI.  
The addon language of choice in KODI world is python, and it brings its own interpreter. I will use pycharm as an IDE. 

![KODI says "hello world!"](/assets/kodi-hello-world-at-runtime.png)

## What you need  

 * [KODI](http://kodi.tv) - A media center software which will act as the addons host. howto install KODI in your linux distro of choice is described [here](http://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux).
 
 * A Texteditor or IDE. Popular ones for Python are [Pycharm](https://www.jetbrains.com/pycharm/), Jetbrains take at a Python IDE, or the Eclipse based [PyDev](http://pydev.org/).    

 * [xbmcstubs](http://kodi.wiki) - a set of python files which provide method stubs for the libraries included in KODI's python interpreter. 
 
## Other useful resources

 * [HOW-TO:HelloWorld addon](http://kodi.wiki/view/HOW-TO:HelloWorld_addon) on [KODI wiki](http://kodi.wiki).  
 
 * [Audio/video add-on tutorial](http://kodi.wiki/view/Audio/video_add-on_tutorial#Hello.2C_World.21) on KODI wiki.  
  
## How to do it

### Project structure

The addon directory must have the same name as the addon itself, which will be named ```io.github.lumue.xbmc.hello```.  
to be available to KODI it must be placed in ```$HOME/.kodi/addons``` and  contain at least these two files:

 * ```addon.xml``` addon metadata
 
 * ```addon.py``` the addon python script 
 
![the addon directory layout shown in pycharm](/assets/kodi-hello-world-project-structure.png)


#### addon.xml
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addon id="io.github.lumue.xbmc.hello" name="Hello World" version="1.0.0" provider-name="lumue">
  <requires>
    <import addon="xbmc.python" version="2.14.0"/>
  </requires>
  <extension point="xbmc.python.pluginsource" library="addon.py">
    <provides>executable</provides>
  </extension>
  <extension point="xbmc.addon.metadata">
    <summary lang="en">Hello World</summary>
    <description lang="en">a "Hello World" addon</description>
    <disclaimer lang="en"></disclaimer>
    <language></language>
    <platform>all</platform>
    <license></license>
    <forum></forum>
    <website></website>
    <email>mueller.lutz@gmail.com</email>
    <source></source>
  </extension>
</addon>
{% endhighlight %}

#### addon.py

{% highlight python %}
import xbmcaddon
import xbmcgui

xbmcgui.Dialog().ok("Hello World!","Hello World!")
{% endhighlight %}
