# Debrief: Port Inventory

## What you learned

An inventory becomes useful when it knows what normal looks like. Every deviation in your output is one of two stories: something is exposed that nobody intended, or something that should be running is not. Both are incidents, and the script finds them without anyone reading a list of numbers.

## Under the hood

`nc -z` performs a TCP handshake and closes the connection immediately. A successful handshake means something is listening; a refusal or timeout means closed or filtered. It cannot tell you what the service is, only that the port answers, and from one vantage point only: a port open to the internal network may be closed from outside. The associative array keyed by host is an in-memory table, the Bash equivalent of a dictionary; padding values with spaces is a cheap way to do exact-token membership tests.

The one-second timeout matters. Without `-w`, a firewall that drops packets makes each probe hang for a minute or more.

## In real work

Run the scan from outside the network as well, diff the output against last week's, and feed deviations to an alerting channel. Treat "expected" as configuration under version control.

## Going further

You compared what is listening with what should be. Next you will read firewall rule exports and look for rules that open too much.
