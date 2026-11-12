# Debrief: The Chaos Monkey

A pseudo-random generator is a deterministic machine that looks random: the same seed gives the same sequence, forever. That is exactly what you want from chaos testing, load generators, fuzzers and simulations. Real randomness gives you surprise; seeded randomness gives you surprise *and* a reproduction.

You wrote one with three ideas of general use. **Masking** (`& 2147483647`) is how you do "modulo a power of two" and keep numbers inside a known range. **Shifting** (`>> 16`) discards the weak low bits. **Sequence discipline**: the number of draws per round is fixed, so a change anywhere shifts everything after it, and that is why the draw order was written into the specification.

The loop itself mirrors the scientific method: inject, observe, repair, observe again. Reporting S1 and S2 proves the experiment ran and shows what happened. The protected list and the dry run are the safety rails: a chaos tool without a way to preview or to exclude the crown jewels will eventually take down something it should not have.

Going further: knowing a service broke is half the story. The SLA monitor, next, turns a stream of up/down observations into a number the business understands, an uptime percentage and what is left of the error budget.
