#!/usr/bin/env bash
# pipefail: the pipeline's status is the failing stage's status, not tee's.
set -o pipefail
site=$1

# 2>&1 puts the warning into the pipe as well; tee -a copies the stream into
# deploy.log (append) and passes it on to our stdout.
deploy-tool "$site" 2>&1 | tee -a deploy.log
