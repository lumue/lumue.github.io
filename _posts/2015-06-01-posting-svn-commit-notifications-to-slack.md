---
layout : layout
title : posting svn commit notifications to slack
tags :
 - svn
 - slack
 - project automation
update : 2015-11-22 00:00:00
---

# Posting svn commit notifications to slack

We are trying out [slack](http://www.slack.com) as a communication tool at work, and i thought it would be nice to post notifications about commits to our [svn](https://subversion.apache.org) repository to the channel i set up for project stuff.  
So the plan is to setup a [post-commit hook](http://svnbook.red-bean.com/de/1.7/svn.ref.reposhooks.post-commit.html)  on the svn host which calls into slacks webapi.  

## Posting to the slack webapi

I have already described howto post to slack channels from the shell in [another post]({% post_url 2015-06-01-posting-to-slack-from-shell %}).  
To make it easier for to send the commit information to slack, i modified the script from the above mentioned post to accept a svn repo location and a revision number (which is what we get passed into the svn hook handler) instead of the message.
Also the user and channel name are fix.

Now it looks like this:

{% highlight bash %}
#!/bin/bash

#these have to be obtained from slack
api_token="your slack webapi token"
url="https://your webhook url"

username="svnbot"
channel="#korona-resource"

#commandline parameter
repo=$1
revision=$2

#build message
message=`svn log --revision $revision $repo`
message=`echo $message | iconv -f iso8859-1 -t ascii//translit`
message=`echo $message | sed "s/'/\\\\\'/g"`
message=${message//--/}
message=${message//|/\\n}

#build json
jsonstring="{\"token\":\"$api_token\",\"channel\":\"$channel\",\"username\":\"$username\",\"text\":\"$message\",\"icon_emoji\":\":ghost:\"}"
echo $jsonstring > /tmp/slack_git_msg

#call curl
curl -i -X POST -H 'Accept: application/json' -H "Content-Type: application/json; charset=ascii"  --data @/tmp/slack_git_msg $url
{% endhighlight %}

As you can see, there is some converting and replacing magic involved, to end up with a message which curl can hand over as valid json.


## The SVN side

Place the above script in a location where it is callable from svn (e.g. /usr/bin) and give it the appropriate execution rights.  

Next we have to tell svn to call the script and pass it the correct parameters after each commit to our repository(-branch).  
To do this, edit the post-commit script of your repository. Its usually located in ``<path-to-repo>/hooks/post-commit``.

Add the following lines:

{% highlight bash %}
if [ -n "$(svnlook changed ${REPOS} -r ${REV} | grep <branchname>)" ]
then
  /usr/bin/slack_send_svnlog.sh ${REPOS} ${REV}
fi
{% endhighlight %}

And we are done here. A commit should now produce a post displaying the commit message in the selected slack channel:

![your commit message in slack](/assets/slack-svn-post-screen.png)
