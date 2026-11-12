# Debrief: The Canary Releaser

The canary pattern turns "deploy and hope" into "deploy and measure". It works because it makes failure small: a bug that would have hit every customer hits one in twenty for a few minutes, and the script, not a person, pulls the plug.

Three ideas carry over to other work. First, **relative thresholds**. Comparing the canary with the baseline measured at the same moment cancels out everything both share: a flaky network, a busy hour, a storm. Second, **minimum evidence**. A rate computed from forty requests is noise, and the safe default for "not enough data" is to stop. Third, **a single abort path**. All the ways to fail lead through one function, so rollback is the code you test most.

You also saw why exit codes carry meaning. Status 1 says the release was judged bad; status 3 says the tooling itself failed. A deploy pipeline can react differently to each: retry one, page someone for the other.

Working in permille showed a general trick: when you only have integers, scale first, divide last, and add the decimal point only when printing.

Going further: the canary needs failures to be real before it can react to them. How do you know your rollback actually works? Deliberately break things, repeatably: the chaos monkey, next.
