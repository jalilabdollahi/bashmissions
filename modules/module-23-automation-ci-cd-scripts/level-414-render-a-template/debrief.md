# Debrief: Render a Template

The mental model: **a template is a program you do not trust to run, with holes
filled by data you do not trust to be harmless.** Keeping the two apart is the
whole job. Pasting a value into a `sed` command or `eval` makes it code; moving
it from the environment into an output string keeps it text.

The left-to-right walk is the safe design pattern. Because consumed text is
never re-read, there is no second expansion, so a hostile or merely unlucky
value (`${B}`, `$(...)`) cannot cause trouble. Compare `envsubst` and
`sed 's/${X}/value/'` loops, where ordering and escaping decide whether it is safe.

Indirect expansion is the Bash feature that makes it possible: `${!name}` means
"the value of the variable whose name is stored in `name`", and `[[ -v name ]]`
tells *unset* from *empty*. That distinction matters in deployments: an
empty `DB_PASSWORD` is a deliberate value, a missing one is a bug, and a
renderer should fail loudly on the second. Failing early with every missing name
listed saves a deploy cycle per name.

You will see this in Helm and Terraform templates, `docker-compose` `${VAR:-x}`
substitution, and nginx/systemd unit generators in provisioning scripts.

Going further: a rendered config is per environment. Next you promote a
version through dev, staging and prod, using the rules of each stage.
