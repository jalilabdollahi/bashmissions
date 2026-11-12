# Walkthrough: The Certificate Watchdog

## The plan
Expiry checking sounds like a date problem, and date problems are where scripts go to die on
macOS versus Linux. The trick is not to compute dates at all: `openssl x509 -checkend N` already
knows the certificate's end date and the current time, and answers with an exit status. Asking
it three times (now, in crit days, in warn days) gives all four classifications. The rest of the
design is about being a good citizen: renew little and carefully, and touch the web server once.

## Step by step
1. **Options.** Three numeric options and a flag. All mistakes exit 64 (the "usage" status from
   `sysexits.h`), keeping 0, 1 and 2 for the verdict, as monitoring plugins do. `crit <= warn`
   is checked because the reverse would make the CRIT state unreachable.

2. **Finding certificates.** `certs=("$dir"/*.pem)` plus `[[ -e ${certs[0]} ]]` is the idiom for
   "the glob matched something". Glob order is alphabetical, which also fixes the order
   renewals are attempted in.

3. **`inspect`.** The subtle point: `-checkend` exits 1 both when the certificate expires in time
   and when the file is garbage, so on its own it would label a corrupted file "EXPIRED". Asking
   `-enddate` first separates the cases: if that fails the file is `INVALID` and no later
   question is asked. Then the three `-checkend` calls from strictest (0 seconds) to loosest.
   The function sets globals so it can be called again after a renewal.

4. **Renewal with a budget.** For WARN, CRIT and EXPIRED certificates (never INVALID, certbot
   cannot fix a file that is not a certificate) call `certbot renew`. Every attempt, successful
   or not, uses up one unit of `--max-renewals`: certificate authorities rate-limit, and a failing
   renewal retried in a loop for 40 certificates is a good way to get locked out. After a success
   `inspect` runs again, so the report shows the new expiry, not the stale one.

5. **Reload once.** Reloading nginx after every renewal would be harmless but noisy; skipping
   it entirely would leave the old certificate in memory. The flag `renewed_any` and a single
   `systemctl reload nginx` after the loop get both right, and only if something changed.

6. **Report.** Rows are built with `printf` into an array and printed once, because the reload
   line must follow the table. Counters per status live in an associative array. The exit status
   is 2 for CRIT, EXPIRED or INVALID, 1 for WARN, otherwise 0.

## Try it by hand
```
./solution.sh certs; echo "exit=$?"
./solution.sh --renew --max-renewals 2 certs
```

## Alternative
Parsing the `notAfter=` date yourself lets you print "23 days left", but needs a month-name table,
a leap-year-aware day count and a time-zone decision. `-checkend` trades the pretty number for
correctness on every platform.
