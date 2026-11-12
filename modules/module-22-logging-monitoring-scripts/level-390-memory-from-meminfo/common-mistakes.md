# Common Mistakes

- **Using MemFree as "free memory".** Wrong: `used = MemTotal - MemFree` reports 87% on a perfectly healthy server full of cache. Right: subtract `MemAvailable` (or the Free+Buffers+Cached fallback).
- **Dividing first.** Wrong: `$(( used / total * 100 ))` is always 0 (or 100). Right: `$(( used * 100 / total ))`.
- **Splitting on spaces only.** Wrong: `read -r key value` leaves the colon on the name, so `${mem[MemTotal]}` is empty and the array holds `MemTotal:`. Right: `IFS=': ' read -r key value _unit`.
- **Missing key under `set -u`.** Wrong: `${mem[MemAvailable]}` aborts on old kernels with "unbound variable". Right: `${mem[MemAvailable]:-}` and test for empty.
- **Forgetting units.** The numbers are kB. Dividing by 1000 instead of 1024, or printing kB as MiB, gives a report that is wrong by a thousand-fold.
