# Common Mistakes for Convert Bases

- Expecting Bash arithmetic to handle decimals without `bc`.
- Forgetting that division inside `$(( ))` is integer division.
- Using string comparison for numeric decisions.
- Printing extra explanatory text that the exact-output validator does not expect.
