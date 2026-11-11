# Common Mistakes

- **Leaving out `-n 1`.** xargs packs many names into one call, so `thumb` gets several arguments and there is little to parallelise.
  - Wrong: `xargs -P 4 thumb`
  - Right: `xargs -n 1 -P 4 thumb`
- **Printing in finishing order.** Parallel jobs finish in a different order each run.
  - Right: `... | sort` before showing or comparing results.
- **Forgetting that xargs's status is 123, not 1.** A script that tests `== 1` misses failures.
  - Right: treat any non-zero status as failure (`if ! ...; then exit 1; fi`).
- **Letting `set -e` hide the output.** If the pipeline's failure ends the script, the explanation never prints.
  - Right: put the pipeline in an `if`.
- **Using `-P 0` without thinking.** On GNU it means "as many as possible", which for hundreds of items is the "everything at once" mistake from level 310.
