# Walkthrough: Your First Script

## The plan
A Bash script is a plain text file. When you run it, Bash reads it from the top and executes each line as a command. The task needs a single command that prints text, which is what `echo` does.

## Step by step
1. Open `solution.sh`. The first line is `#!/usr/bin/env bash`. This is the shebang. The `#!` pair tells the operating system "hand this file to the program named here". Here that program is `bash`, found by `env`.
2. Below it, add a line with the command:

```bash
echo "Hello, Lanternfish!"
```

The quotes are not printed. They only tell Bash where the text begins and ends.

## Complete solution

```bash
#!/usr/bin/env bash
echo "Hello, Lanternfish!"
```

## Trying it by hand
In the workspace, run:

```
bash solution.sh
```

or make it executable once with `chmod +x solution.sh` and run `./solution.sh`. You should see the greeting and nothing else.

## An alternative
`printf "Hello, Lanternfish!\n"` also works and you will meet it in level 5. For plain lines of text, `echo` is shorter and perfectly fine, so we use it here.
