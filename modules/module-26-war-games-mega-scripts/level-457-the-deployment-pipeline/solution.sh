#!/usr/bin/env bash
# Pipeline for the storm-season release: build, test, deploy, verify, and undo the
# deploy if verification fails. Tools on PATH: harbor-build, harbor-test,
# harbor-deploy, harbor-health. State lives in state/.

# TODO: check the arguments and the VERSION format (exit 2)
# TODO: refuse to run when state/APP.lock exists (exit 7), else create it
#       and make sure a trap removes it on every exit path
# TODO: read the previous version from state/APP.version (or "none")
# TODO: a run_stage function that prints "stage NAME: ok|FAILED" and logs it
# TODO: a verify function: 3 health attempts, `sleep 5` between failures
# TODO: a rollback function using the previous version
# TODO: wire the stages together with the right exit codes (3, 4, 5, 6)
# TODO: record the new version and print the final summary line
