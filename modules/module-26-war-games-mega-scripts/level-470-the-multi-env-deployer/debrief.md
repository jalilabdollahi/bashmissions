# Debrief: The Multi-Env Deployer

Promotion pipelines exist because the cheapest place to find a bug is the environment
before the one that matters. The tool's job is to make skipping steps impossible and to
make the reasons for a refusal impossible to misunderstand. Three design decisions carry that:

**Data over code.** The environments and gates live in a file. The script is a generic
engine, so adding a gate or an environment is a config change, reviewed like any other.

**Report everything.** Gates are all evaluated and printed, with a reason in
parentheses. A failure message like "gate approval: FAIL (self-approval is not allowed)" is
more useful than any amount of documentation.

**Record last.** State is written after the health check. Writing it first and
"fixing it up" on failure is the classic recipe for a state file that lies. This is the same
principle as the pipeline of the first mission, now with environments added.

Separation of duties (the approver must differ from the deployer) is a small piece of Bash
that carries a large idea: controls are policy turned into code, so people do not have to
remember them under pressure. Production tools such as Spinnaker, Argo and GitHub environments
implement the same gates with more polish.

Going further: the next mission is a different kind of pipeline: ingest, validate, transform and
load some data.
