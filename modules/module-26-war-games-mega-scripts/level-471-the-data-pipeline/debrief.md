# Debrief: The Data Pipeline

Most data jobs fail in one of three ways: they load garbage, they lose data, or they load things
twice. This script was designed against all three. **Garbage** is stopped by explicit validation rules
applied in a fixed order. **Loss** is prevented by never discarding a row silently: rejects go to a file
with the line number and the reason, and files with the wrong header are quarantined whole.
**Duplication** is prevented twice over, with a unique key (the order id) and a content checksum (the
re-delivered file), which together make the job *idempotent*: running it again changes nothing.

Look at how the stages are separated. The awk program validates and transforms, and *prints* its
results to files; the shell decides what to do with them. That split is why `--dry-run` costs only a
few `(( dry ))` checks around the write operations: the real code path runs, only its side effects
are skipped. It is the cheapest way to make an operational tool trustworthy.

Also note the small habits: normalise input at the border (`tr -d '\r'`), do the money arithmetic
once, keep the reasons countable, and make the order of operations (load, record, archive)
crash-safe. Real pipelines in Airflow, dbt or plain cron use the same skeleton with more machinery
around it.

Going further: the next mission turns the lens on Bash itself, a tiny test harness for shell
functions.
