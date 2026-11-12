# Common Mistakes

- **Logging to stdout.** `echo "[$level] $*"` without `>&2` pollutes the output of
  scripts used in pipes or `$( )`.
- **Comparing the words.** `[[ $level > $threshold ]]` compares alphabetically, so
  ERROR looks "smaller" than INFO. Map names to numbers first.
- **Forgetting `shift`.** The message then starts with the level name:
  `[WARN] WARN disk filling up`.
- **`${LOG_LEVEL}` without a default.** With `set -u` an unset variable aborts the
  script. Right: `${LOG_LEVEL:-INFO}`.
- **Checking WARN before ERROR.** With `pct >= 75` first, a 95% disk logs only the
  warning. Test the largest threshold first.
