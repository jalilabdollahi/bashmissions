#!/usr/bin/env bash
# GitOps deployer. REPO/apps/NAME.app is the desired state, LIVE/NAME.state is
# what is deployed. Make live match the repository: plan, apply, verify each
# change, roll back what is unhealthy, audit everything.
#   solution.sh [--dry-run] [--prune] REPO LIVE NOW
# Environment: MAX_CHANGES (default 5) limits the blast radius of one run.

# TODO: options and arguments, both directories must exist
# TODO: guards in order: FREEZE file, mkdir lock (+ trap), git pull, git rev-parse
# TODO: read and validate ALL manifests first; list every problem; exit 2
# TODO: read the live state files; plan create / update / unchanged, orphans
# TODO: refuse when there are more changes than MAX_CHANGES (warn in a dry run)
# TODO: apply in (order, name) order: deployctl, healthctl, write state or roll back
# TODO: audit log line per change with NOW and the commit; orphans: report or --prune
# TODO: final summary, notifyctl on trouble, exit status
