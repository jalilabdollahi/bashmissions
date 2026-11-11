# Debrief: Exit Codes Speak

Programs talk to people with text and to other programs with numbers. The exit status is the number: a whole value from 0 to 255 given back when the process ends.

## How it works
By convention 0 means success and anything else is some kind of failure. The meaning of 1, 2, 3 and so on is up to the program, as long as it is documented. The parent process, whether that is your shell, cron or a monitoring tool, reads the status and decides what to do next. `exit N` terminates the script immediately, so code placed after it is dead code.

If you never call `exit`, Bash ends the script with the status of the last command it ran. That is a common source of confusion: a script that printed an error can still report success.

## In real work
Deployment pipelines, health checks and `if` statements all depend on exit codes. A script with a wrong status is a script that lies to its callers.

## Going further
Next you will look at the information a script inherits from its surroundings: the environment.
