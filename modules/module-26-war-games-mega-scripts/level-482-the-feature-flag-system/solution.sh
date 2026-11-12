#!/usr/bin/env bash
# Feature-flag evaluator. FLAGS holds lines like
#   new-checkout = on rollout=60 allow=ollie deny=theo env=prod,staging
#   solution.sh FLAGS check FLAG USER [ENV] | list USER [ENV] | validate

# TODO: usage + the readable-file check
# TODO: load_flags: trim, skip comments, split NAME = STATE options, collect
#       errors as "FILE:LINE: message" (first problem per line)
# TODO: keep the flags in associative arrays plus an `order` array
# TODO: decide FLAG USER ENV: kill switch, deny, env, allow, rollout 100, bucket
# TODO: bucket = cksum of "FLAG:USER" modulo 100
# TODO: check prints and exits 0/1; list prints a padded table; validate counts
# TODO: a file with problems exits 1 for validate but 3 for check and list
