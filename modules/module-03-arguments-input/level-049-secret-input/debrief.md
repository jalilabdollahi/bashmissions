# Debrief: Secret Input

Secrets deserve different treatment from other input in three ways, and this
level gave you the first two. They must not be shown while typed (`read -s`) and
they must not be echoed back, logged, or placed in output. Reporting the length
is a safe way to confirm that "something was received".

The third rule is the one to remember for later: do not take passwords from
*arguments*. Anything on a command line is visible to other users through the
process list and is saved in shell history. Reading from the terminal or stdin
keeps the secret out of both places.

Under the hood `-s` asks the terminal driver to turn echo off just for this read,
then restores it, even if the user presses Ctrl-C. When the input is a pipe there
is no terminal to silence, so the option does nothing harmful, and that is why
the same script works in tests and in real use.

Going further: you will soon validate what comes in. Never be tempted to print a
secret in an error message ("password abc is too short"), say only that it is too
short.
