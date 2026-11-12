# Debrief: The Config Drift Detector

Configuration drift is the gap between what you *think* is deployed and what is. The detector
works because it asks the right question: not "are these bytes identical?" but "do these
files **mean** the same thing?". Normalising before comparing (drop comments, trim spaces,
ignore volatile keys) is the single most useful trick in the whole family of "compare two
things" scripts, from config audits to test-output diffs.

A few design choices are worth copying. Control data (`.ignore`, `.modes`) lives *next to*
the golden files, so the policy is versioned together with the configuration. Secrets are
compared but never printed. The tool produces a **plan** rather than fixing things
itself: the same classification feeds both views, and a human decides when to run
the commands. Reading permissions from `ls -l` instead of `stat` keeps the script portable,
at the price of converting the string to octal yourself, which is a nice reminder of what mode
bits really are.

In practice this is the core of tools like `etckeeper`, Ansible check mode and Terraform plan:
desired state, observed state, a readable difference.

Going further: the next level takes a snapshot of state again, but of a release: tags,
changelogs and artefacts for a version.
