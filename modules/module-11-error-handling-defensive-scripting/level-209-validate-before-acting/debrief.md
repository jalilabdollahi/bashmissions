# Debrief: Validate Before Acting

Most dangerous scripts share one shape: a loop that mixes checking and changing.
Everything works until input number three is wrong, and then you are left with a
world that is neither the old one nor the new one. The fix is structural, not
clever: two phases.

Phase one is read-only. It examines every input, and it does not stop at the
first problem; it collects them. Collecting is kinder to the human, who learns
about all three typos at once instead of fixing one and rerunning twice. Phase two
runs only when phase one found nothing, so it can assume its inputs are good and
stay short.

This is the same idea as a pre-flight checklist, `terraform plan` before `apply`,
or `--dry-run` options. Anything that deletes, moves, deploys or bills deserves a
look-before-you-leap section, especially when the list comes from a human or from
another script.

Limits to remember: between phase one and phase two the world can still change (a
file disappears), so `set -e` remains the second line of defence. And validation
cannot catch everything, for example a full disk; that is why the earlier tools
in this module still matter.

Going further: a command that is merely flaky, not wrong, deserves another try
rather than an exit. The next level adds bounded retries.
