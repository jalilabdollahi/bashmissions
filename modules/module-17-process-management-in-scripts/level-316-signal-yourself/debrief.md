# Debrief: Signal Yourself

## What you learned

A signal is an asynchronous message from the kernel (or another process) to a
process. For most signals the default reaction is to die, but you can replace
the default with a handler using `trap`. USR1 and USR2 exist for exactly this:
they mean nothing by themselves, and each program gives them its own meaning.

## Under the hood

`$$` is the script's PID. `kill -USR1 $$` asks the kernel to deliver SIGUSR1
to that PID. Bash does not run the trap inside the signal-arrival moment
itself; it notes the signal, and runs the trap between commands. When the
signal arrives during a long foreground command (say `sleep 60`), the handler
waits until that command is finished. This is why a script that sleeps is
slow to react, and why you will see `sleep` in a loop with short intervals.

Because the handler runs in the main shell, it can use and change your
variables. That is also its danger: it can fire between any two commands, so
keep handlers short and simple.

Two signals of the same kind that arrive while one is pending merge into one.
Signals are not a queue.

## In real work

Reopening log files (USR1 in many servers), dumping statistics (USR2, or
SIGINFO), toggling debug logging, or telling a daemon "reload your config",
which is what `HUP` is for, and what comes next.

## Going further

You sent the signal yourself. Next, someone else sends it: a config-reload
handler for HUP.
