# Walkthrough: The Multi-Env Deployer

## The plan
A promotion pipeline is a set of rules about *what may move where, and under which conditions*.
The two decisions that make it robust are to keep those rules in data (`pipeline.conf`), and to
make the version come from the *previous environment's recorded state*: you can only promote what
has already been running one step earlier. The script itself then has one generic algorithm:
find the version, check all gates, deploy, verify, record.

## Step by step
1. **Commands and identity.** `status APP` and `[--dry-run] promote APP FROM TO` are the only valid shapes;
   everything else is usage, exit 2. `NOW` is injectable and the deployer is `${DEPLOYER:-$USER}`.
   Both matter later: the soak gate needs the clock, the approval gate needs to know who is asking.

2. **Loading the pipeline.** A `while IFS='|' read` loop with a `case` on the first field. The
   `order` line becomes an array; each `gate` line is validated (known environment, known gate, a numeric
   soak) and appended to parallel arrays. Validating the whole file up front means a typo in the prod
   gates is found by `status` too, not at 2 a.m. during a promotion.

3. **Adjacency.** Look up the index of FROM and TO in the order array. A valid step has
   `pos_to == pos_from + 1`; dev to prod is refused with a clear message. Then read the version FROM
   currently runs. If the target already runs it, there is nothing to do and the exit status is 0,
   which makes the command safe to repeat.

4. **Gates: evaluate all, report all.** Each gate is a `case` arm that sets `ok` and `detail`. The loop
   never exits at the first failure: an engineer who has to run the command four times to discover four
   missing approvals will stop trusting it. Failures are counted; one decision is taken at the end.
   - *soak*: whole minutes since the version arrived in FROM, `(now - since) / 60`.
   - *tests*: run the smoke test against FROM, because that is where the version is running.
   - *approval*: a file `approvals/APP-VERSION-TO` naming an approver, who must not be the deployer
     (separation of duties).
   - *freeze*: a `FREEZE` file whose first line becomes the explanation.

5. **Deploy and verify.** `deployctl push`, then `deployctl health`. If the push itself fails,
   nothing is recorded. If health fails, push the previous version back and exit 5; with no previous version
   there is nothing to roll back to and the exit status is 6, an honest "this needs a human".

6. **Record last.** `.version`, `.since` and the history line are written only after a healthy deploy,
   so `status` never claims a version that did not survive its health check.

## Try it by hand
```
NOW=100000 DEPLOYER=mara ./solution.sh promote shrimp-api staging prod
./solution.sh status shrimp-api
```

## Alternative
Hard-coding `if [[ $to == prod ]]; then require approval` is shorter today, and a rewrite the day
someone adds a `canary` environment. Data-driven gates cost a parser and buy you a pipeline that
can change without touching the script.
