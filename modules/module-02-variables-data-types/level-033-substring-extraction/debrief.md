# Substring Extraction

The substring expansion is `${var:offset:length}`. `offset` is 0-based; `length` is optional (defaults to "rest of string"). Both can be expressions.

```bash
text="BashMissions"
echo "${text:0:4}"     # Bash
echo "${text:4}"       # Missions       (length omitted)
echo "${text:4:8}"     # Missions
echo "${text: -8}"     # Missions       (negative offset; mind the space)
echo "${text: -8:4}"   # Miss
```

The leading **space** before a negative offset is mandatory — without it, Bash parses `${text:-8}` as the default-value expansion (level 24). Treat the space as part of the syntax.

Edge cases:

- Offset past the end → empty string.
- Length > remaining → returns whatever's available, no error.
- Negative length: `${var:start:-N}` (Bash 4.2+) treats `N` as "skip the last N characters".

Common patterns:

```bash
first_char="${name:0:1}"
last_char="${name: -1}"
without_first="${name:1}"
without_last="${name:0:-1}"   # Bash 4.2+
middle_three="${name:2:3}"
```

`${var:offset:length}` operates on character indices in a multi-byte locale, like `${#var}`. For arrays the same syntax slices elements: `${arr[@]:1:3}` (covered in module 9).
