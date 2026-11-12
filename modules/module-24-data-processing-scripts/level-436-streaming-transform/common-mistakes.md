# Common Mistakes

- **Collecting lines first.** `lines[NR] = $0` and processing in `END` uses memory proportional to the input and prints nothing until the stream ends. Compute and print per line.
- **Reaching for a temp file.** `awk ... > out.tmp; mv ...` or `mktemp` writes the data to disk twice and fails on a full disk. Let the pipe carry the data.
- **Floating point money.** `running += $2 / 100` accumulates errors such as `0.07000000000000001`. Add integer cents and split with `int(c / 100)` and `c % 100`.
- **Mishandling negative cents.** `-5 % 100` is `-5` and `int(-5 / 100)` is `0`, so naive formatting prints `0.-5`. Take the sign off first, format the absolute value, put the sign back.
- **Using `sort` in the middle.** `sort` must read all input before printing anything, which breaks the "output as it arrives" requirement. Streaming steps are line-at-a-time tools.
