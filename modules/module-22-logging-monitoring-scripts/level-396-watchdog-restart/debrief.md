# Debrief: Watchdog Restart

Detection without action produces alerts at 3 a.m.; action without verification
produces confident lies. The watchdog pattern joins them in four verbs:
**detect, act once, verify, report**. Each verb matters. "Once" prevents a
restart storm against a service that is broken for a reason a restart cannot fix.
"Verify" means you do not print `restarted` merely because the command ran. And
"report" turns the outcome into an exit status and a line a human or the next
script can use.

The Bash lesson underneath is that **the exit status is the answer**. Every
command ends with a number: 0 for success and anything else for failure. `if
command; then` is the language's native way to branch on it; reading the printed
text is fragile because wording changes between versions and languages.
Putting a command in an `if` condition also tells `set -e` that failure is
*expected* there, which is why a watchdog can run safely under strict mode.

Notice also the shape of the loop: a flag collects the verdict while the loop
continues. Stopping at the first failure would leave services later in
the list unattended, and that is exactly the situation the watchdog exists for.

Real systems use `Restart=on-failure` in systemd for the simple cases; scripts
like this cover checks the init system cannot do, such as "the port answers"
or "the queue is draining".

Going further: when a restart fails, someone must hear about it. The next level
posts an alert to a webhook.
