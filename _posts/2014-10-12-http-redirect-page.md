---
layout : layout
title :  A redirect page with fallbacks
tags:
 - html
 - coding
update : 2015-11-22 00:00:00
---

# A Template HTML5 redirect page


{% highlight html %}
<html>
  <head>
  <title>Page Title</title>
  
  <meta http-equiv="Refresh" content="0; url=target.html">
  
  <!-- If the meta tag doesn't work, try JavaScript to redirect. -->
  
  <script type="text/javascript">
        window.location.href = "target.html"
      </script>
  </head>
  
  <body>
    <!-- If JavaScript doesn't work, give a link to click on to redirect. -->
    <p>
      If you are not redirected automatically, click <a
        href="target.html">here</a>.
    </p>
  </body>
</html>
{% endhighlight %}