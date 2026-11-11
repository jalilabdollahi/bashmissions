# Common Mistakes

- **Prepending instead of replacing.** Wrong: `PATH="/usr/bin:$PATH"` keeps the attacker's folder, just later (and anything not in /usr/bin still resolves to it). Right: `PATH=/usr/bin:/bin`.
- **Pinning too late.** Wrong: running `ls` in a usage check and setting PATH afterwards. Right: PATH is the first assignment after `set -euo pipefail`.
- **Leaving an empty entry.** Wrong: `PATH=/usr/bin:/bin:` ends with a colon, so the current folder is searched. Right: no leading, trailing or double colons, and no `.`.
- **Trusting `hash` caches.** Wrong: assuming a command found earlier is still the right one after changing PATH; run `hash -r` in long scripts that changed it. Right: pin PATH before the first lookup.
- **Pinning to user folders.** Wrong: `PATH=$HOME/bin:/usr/bin` lets anyone who can write in HOME decide. Right: only folders writable by root.
