# Debrief: Idempotent Setup

The mental model: **describe the end state, not the steps.** "Create the group"
fails the second time; "the group must exist" does not. Provisioning tools such
as Ansible, Puppet and Terraform are built on that idea, and a ten-line shell
script can follow it too if every action is preceded by its own question.

Three kinds of questions appeared. Existence (`-d`, `-e`, `-L`). Asking the
system through a command's exit status (`getent`). And content (`grep -qxF`),
where precision matters: a loose match treats `# umask 027` as done and the
setting is never applied. `-x` and `-F` together mean "this exact line, as plain
text".

The second principle is ownership. Some things your script *owns* (the
directories, the link) and may fix; others it only *seeds* (the config file) and
must leave alone once a human has had a go. Deciding which is which is a design
choice, and the conflict message for a plain file where a link should be is the
script admitting it does not own that.

Reporting what changed ("7 created, 0 already in place") is also useful: an
operator running it twice sees at a glance that nothing happened.

Going further: the last level of this module cleans up after all of this, keeping
only the newest few artifacts and deleting the rest.
