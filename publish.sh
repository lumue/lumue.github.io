#!/bin/sh
# publish the site by pushing the _site directory to the master branch at github.com
jekyll build
git branch -D master
git checkout -b master
git filter-branch --subdirectory-filter _site/ -f
git checkout draft
git push --all -f origin
