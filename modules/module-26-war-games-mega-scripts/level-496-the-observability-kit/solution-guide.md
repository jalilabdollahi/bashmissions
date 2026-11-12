# Walkthrough: The Observability Kit

## The plan
Observability rests on three kinds of data that answer three different questions. **Metrics** are numbers over time ("how many jobs finished?"). **Logs** are timestamped events ("what happened?"). **Spans** are timed steps that belong to a trace ("where did the time go?"). Each alone is a partial view; the power is in joining them on a shared *trace id*, which is why a log line carries `trace=t1` and a span carries the same.

Our kit is a folder with three plain files and a CLI to write to them. All time comes from `date +%s`, which the tests replace by a stub, so the same inputs always yield the same durations.

## Step by step

1. **State files that survive crashes.** Counters and ids are small files rewritten often. Writing in place can leave a half-written file; so `replace_file` writes a temporary file in the same folder and `mv`s it over the target, with a `trap` to clean up. The metrics file is kept sorted with `LC_ALL=C sort` so that `report` and diffs are stable.

2. **Metrics.** `metric_apply` loads the file into an associative array, changes one key (`inc` adds, `set` replaces) and writes everything back sorted. It prints the new value, which `metric inc` shows as `NAME=VALUE`.

3. **Logs.** A log line is a *structured* record: timestamp, level, trace, message, in a fixed order that can be parsed with `read`. Logging also bumps a `log.LEVEL` metric, the classic bridge between the logs signal and the metrics signal ("errors per minute" is just a counter).

4. **Spans.** Allocate ids first, so even if the command crashes the id is unique. Then run the command with the trace and span ids placed in its environment (`VAR=value command` form), which is how a nested `span` call in the child discovers its trace and parent, with no argument plumbing. Time it with two `date +%s` calls. Record the line *after* the command ends, so spans appear in completion order (children before parents), and the report must not rely on file order. Keep the command's exit status: instrumenting must not change behaviour.

5. **Report: rebuild the tree.** Read every span into arrays by id. Build `kids[parent]` lists, and per-trace root lists for spans whose parent is `-` or not found. A recursive `show` prints a span, then its children sorted by span number, with indentation proportional to depth. Traces are printed in numeric order of their ids; sort on the digits (`-t t -k2,2n`) because plain sorting would put `t10` before `t2`.

6. **Join the signals.** The report prints metrics, level counts with the error messages and the trace tree on one screen: SLOW spans and failing spans stand out next to the error logs of the same trace.

## Complete solution
The span core:
```bash
alloc span; sid=s$allocated
start=$(date +%s)
status=0
OBS_TRACE=$trace OBS_PARENT=$sid "$@" || status=$?
end=$(date +%s)
echo "$trace $sid $parent $start $((end - start)) $([[ $status == 0 ]] && echo ok || echo "exit=$status") $sname" >> "$spans"
```

## Try it by hand
```bash
mkdir out
./solution.sh out span backup-run -- bash solution.sh out span dump-db -- worker 7
./solution.sh out log error "upload failed"
./solution.sh out report
```
(`worker` is a stub that moves the fake `.clock` forward.)

## Alternative
Production systems send these signals to separate backends (Prometheus, Loki, Jaeger). The files here have the same shape: a counter store, an event log and a span list joined by ids, so everything you learned transfers.
