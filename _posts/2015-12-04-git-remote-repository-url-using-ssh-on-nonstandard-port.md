---
layout : post
title :  git remote repository url using ssh on nonstandard port
tags :
 - gogs
 - git
 - linux
 - sysadmin
 - coding
 - project automation
---

# git remote repository url using ssh on nonstandard port

## why would one need this

i run [gogs](https://gogs.io/) on a server (dockerized of course ;)  in my home network to share repositories between my laptop and desktop.
since i still want to be able to ssh in to the server on port 22, i mapped the gogs containers port 22 to 10022 on the docker host.

To make this work, the repo url that gogs tells you to use, has to be tweaked a little bit.

## this url works

For example if this is the url gogs tells you to use:

    git@thegithost:lumue/myrepo.git

then this would be the repo url to use for gogs listening on port 10022:

    ssh://git@thegithost:10022/lumue/myrepo.git

There might be a way to get gogs to display the correct url to begin with, but for the time being i now have at least this cheatsheet and wont have to go hunting on the internet everytime i clone a new repo :)

