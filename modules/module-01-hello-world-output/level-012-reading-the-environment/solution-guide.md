# Walkthrough: Reading the Environment

## The plan
The environment is a table of NAME=value pairs that a process inherits from the process that started it. The login system fills in `USER` and `HOME`, and every program, including your script, can read them. In Bash you read a variable by putting `$` in front of its name.

## Step by step
1. Write the sentence you want, with the two variables where the values go: `You are $USER, your home folder is $HOME`.
2. Put it inside double quotes so Bash expands the variables. In single quotes it would print the literal names, as you saw in level 4.
3. Pass it to `echo`.

## Complete solution

```bash
#!/usr/bin/env bash
echo "You are $USER, your home folder is $HOME"
```

## Trying it by hand
Run `bash solution.sh` and compare with `echo $USER` and `echo $HOME` in your terminal. To see the whole environment, run `env`. To fake a different user for one run: `USER=noor HOME=/home/noor bash solution.sh`.

## An alternative
`whoami` prints the user name too, and `~` stands for the home folder. Reading `$USER` and `$HOME` is simpler, needs no extra program, and is exactly what the tests can swap out.
