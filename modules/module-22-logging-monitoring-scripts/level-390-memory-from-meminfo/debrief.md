# Debrief: Memory from meminfo

Under `/proc`, Linux pretends the kernel's internal state is a folder of text
files. `/proc/meminfo` is the memory ledger: one `Name: value kB` per line.
Tools like `free` and `top` are essentially pretty-printers for it. Because it
is a plain file, a script can read it with nothing but `read` and a loop, and
because you pass the *path* in as an argument, the same script can be pointed at
a saved copy from a crashed machine and replayed at leisure.

The important concept is **"used" is not a single obvious number**. Linux uses
spare RAM for caches that it hands back the instant a program asks, so
`MemTotal - MemFree` makes a healthy server look nearly full. `MemAvailable`
(an estimate of what could be allocated without swapping) is the honest
figure; older kernels did not print it, hence the fallback sum. Knowing which
field to trust matters more than the parsing.

On the technique side: `IFS=': '` splits on several characters at once,
associative arrays turn a stream into a lookup table, and `${x:-default}`
lets you ask for a key that might not exist. Multiplying before dividing keeps
integer arithmetic accurate.

You meet the same format in `/proc/cpuinfo`, `/proc/self/status`, and in
many config-like files.

Going further: the next level asks a different question about a running
program: not "how much", but "is it even alive?"
