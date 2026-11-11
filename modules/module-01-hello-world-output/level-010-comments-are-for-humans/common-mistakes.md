# Common Mistakes

- **Writing the hash after the shebang text.** The header comments belong on their own lines under the shebang.
- **Commenting out only the first of several lines.** Each line needs its own hash, otherwise the rest still runs.
  Wrong: `#echo "DEBUG: pages = 3"` but the second DEBUG line left bare.
  Right: `#echo "DEBUG: entering warm-up"` and `#echo "DEBUG: pages = 3"`
- **Deleting the debug lines instead of commenting them.** The output is right, but this level wants them kept.
- **Putting # inside the quotes.** `echo "# DEBUG: pages"` still prints a line.
  Right: `# echo "DEBUG: pages"`
