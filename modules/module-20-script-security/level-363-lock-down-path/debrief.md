# Debrief: Lock Down PATH

Command names are not commands; they are *requests* that the shell answers by
searching `PATH`. An attacker who can influence that search, through a shared
`/tmp` folder in PATH, a writable `~/bin` that comes first, a `.` or an empty
entry, gets to run their program in your place, usually with your privileges.
This is "PATH hijacking", and it is the reason `sudo` resets the environment and
why cron scripts begin with a PATH line.

The defence is to set `PATH` yourself, at the top, to a short list of folders only
root can write to. Replace it, do not extend it: `PATH="$PATH:/opt/bin"` keeps
everything the caller supplied. If a script needs an extra tool, add its trusted
folder to your own fixed list.

Pinning PATH protects the commands you call; it does not protect the ones you
*source* or run by relative path (`./helper.sh`), nor `$BASH_ENV`-style hooks.
Keep those under your control too.

You can see the lookup with `type -a ls`, which lists every match in order, and
`command -v` to see which one would run.

Going further: another place where names must not be trusted is the file list
itself. Level 364 iterates over files without asking `ls` to hand over names as
text.
