# Debrief: Color Codes

Colour in a terminal is not graphics. It is text that contains invisible control characters, and the terminal acts on them as they arrive.

## How it works
The sequence starts with the Escape character, which is byte 27. A `[` follows, then one or more numbers separated by semicolons, then a letter that names the action. The letter `m` means "select graphic rendition", and the number picks the style: 30-37 are the foreground colours, 0 resets everything, 1 is bold.

Because the codes are only text, colours survive in files and pipes, and show up as odd characters in places that do not interpret them. That is why real tools turn colour off when their output is not a terminal.

## In real work
Colour makes warnings stand out in long logs and deployment output. Use it sparingly, always reset, and never make colour the only way to tell success from failure; screen readers and log files do not see it.

## Going further
Next, you will build graphics from text: a banner whose border is made by repeating a character.
