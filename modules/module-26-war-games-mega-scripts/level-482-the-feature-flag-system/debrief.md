# Debrief: The Feature Flag System

A flag file is configuration that changes behaviour without changing code, and the interesting engineering is in the rules: what wins when they disagree. You made the answer explicit and ordered, with the kill switch on top. That ordering is documentation as much as logic; when production is on fire, nobody should need to read source to know that `off` means off.

The rollout trick is the part to remember. Hashing a stable identity gives each user a fixed bucket, which makes rollouts sticky (no flicker between page loads), monotonic (growing the percentage only adds users) and reproducible (the same input gives the same answer on every server). A random roll does none of these. Real systems use better hash functions than a CRC, but the shape is identical.

You also designed an error path: validate everything, report every problem with its place, and refuse to evaluate a damaged file. A flag system that silently skips a line it cannot parse can leave a feature half-enabled.

Feature flags show up everywhere: gradual rollouts, A/B tests, per-customer features, emergency kill switches. The same pattern of "parse config, then run a decision ladder" is how firewalls, routers and rate limiters read their rules.

Going further: a gradual rollout is more than one number. The blue-green switcher, next, moves an entire release at once, atomically, with an instant way back.
