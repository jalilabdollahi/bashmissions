#!/usr/bin/env bash
# Status-page link builder: grow one string in several small steps.

url=https://$SITE
url+=:$PORT
url+=/status/$STAGE

echo "$url"
