#!/usr/bin/env bash
# The reporting tool. It is a separate program: it only sees variables that
# were exported to it. (Do not edit; your script just has to run it.)
echo "child sees: REGION=[${REGION-}] SCRATCH=[${SCRATCH-}]"
