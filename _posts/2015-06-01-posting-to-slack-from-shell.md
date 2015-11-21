---
layout : post
title : Posting to slack from shell
tags:
    - slack
---

# Posting to slack from shell (using the webapi)

We are trying out [slack](http://www.slack.com) as a communication tool at work, so i decided to give its webapi a little try.  
What i want to do, is send a message from the commandline into slack.

## Getting api access to slack

Access to slacks web api is authorized by an access token. so we need to obtaion one. to do this, log in to slack and point the browser to [slack webapi](https://api.slack.com/web).
scroll down, and hit the issue token button.  

![creating the webapi token](/assets/slack-get-token-screen.png)  

you can always go back to the [same url](https://api.slack.com/web) to view your token.

## Using the slack api to post

### incoming webhooks

To post a message to a slack channel, we need to setup an [incoming webhook](https://api.slack.com/incoming-webhooks).  

#### creating the webhook

In order to do so, navigate to [new incoming webhook](https://<teamname>.slack.com/services/new/incoming-webhook), select in which channel you want the messages to appear, and click the big green button which says "Add incoming WebHooks Integration". The selected channel is just a default and can be overriden when sending the actual message. 

![setting up an incoming webhook in slack](/assets/slack-new-incoming-webhook-screen.png)

The URL of the created webhook is shown on th resulting page:  

![setting up an incoming webhook in slack](/assets/slack-new-incoming-webhook-result.png)

#### testing the webhook

Let's see if this works:  

{% highlight bash %}
curl -X POST --data-urlencode 'payload={"token":"<your-token-here>","channel": "#korona-resource","username": "lumue","text": "This is posted to #korona-resource from lm","icon_emoji": ":ghost:"}' https://<your-incoming-webhook-url-here>
{% endhighlight %}

if everything works as it should, you should see this testmessage  displayed in the selected channel:  

![setting up an incoming webhook in slack](/assets/slack-view-testpost.png)

the username does not have to exist in your slack team.

### roll everything into a friendly bash script

because i know i will never be able to memorize this call properly we will put this into a shell script i will call "slack_send.sh". also, it will look cleaner this way when used from the commit-hook script later on.  

{% highlight bash %}
#!/bin/bash
#these have to be setup via slack
api_token="<your-token-here>"
url="https://<your-webhook-url-here>"

#commandline parameter
message=$1
channel=$2
username=$3

#assemble json payload
jsonstring="'payload={\"token\":\"$api_token\",\"channel\":\"$channel\",\"username\":\"$username\",\"text\":\"$message\",\"icon_emoji\":\":ghost:\"}'"

#call curl
curl -X POST --data-urlencode $jsonstring $url
{% endhighlight %}