# Common Mistakes

- **Forgetting -t on CSV.** `sort -k3,3n disks.csv` splits at blanks, so every line is one field and the key is empty. Right: `sort -t, -k3,3n disks.csv`.
- **An open-ended key.** `-k3` compares from field 3 to the end of the line. Wrong: `sort -t, -k1 file` as a "sort by first column" (it also looks at later columns). Right: `-k1,1`.
- **Text order for sizes.** Without `n`, `95` sorts after `120`. Wrong: `-k3,3r`. Right: `-k3,3nr`.
- **Putting -r where it hits everything.** `sort -r -t, -k3,3n -k1,1` reverses the host tie-break too, giving `flounder` before `dory`. Attach `r` to the key that needs it.
- **Leaving ties undefined.** With only one key, equal lines appear in whatever order the system picks. Name a second key so the report is the same on every machine.
