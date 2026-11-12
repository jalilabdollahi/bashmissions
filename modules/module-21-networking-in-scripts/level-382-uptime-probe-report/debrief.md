# Debrief: Uptime Probe Report

## What you learned

A monitor is a loop over checks with a uniform result. You combined two layers of the network: **HTTP** (does the service answer sensibly?) and **TCP** (is anything listening?), and you gave each check the same three-part shape: probe, classify, report. The probe list is data, not code, so adding a service means adding a line.

## Under the hood

Every earlier level appears here in miniature. `%{http_code}` and `|| true` handle web checks; `000` is "no answer", not an HTTP status. `nc -z -w` handles raw ports within a time limit. `read -r kind name a b` splits a configuration line, and `case` dispatches on its first word, a pattern common in small tools. The two report functions keep the counters consistent so no branch can forget to count.

The exit status carries the same message as the report, but for machines. Humans read `DOWN billing (HTTP 503)`, cron reads exit 1. Designing both outputs on purpose is what turns a script into something other people can depend on. Note also the deliberate choice to report an unknown type as DOWN rather than silently skipping it: a typo in the list should be noisy, not invisible.

## In real work

This is a tiny version of what Nagios, Prometheus blackbox probes and uptime services do. It is also how many teams write their first deploy "smoke test".

## Going further

Next module: instead of asking the network about services, you will teach your scripts to keep logs and watch themselves, so problems are caught before a customer notices.
