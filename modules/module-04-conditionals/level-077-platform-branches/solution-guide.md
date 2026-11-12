# Walkthrough: Platform Branches

## The plan

macOS and Linux are close relatives but not twins: the same job often needs a
different command. A portable script asks the system what it is, then takes the
matching branch. The question is answered by `uname -s`, which prints the name of
the kernel:

| System | `uname -s` |
|---|---|
| Linux server or laptop | `Linux` |
| macOS | `Darwin` |
| FreeBSD | `FreeBSD` |
| Git Bash on Windows | something like `MINGW64_NT-10.0` |

## Building it

Capture the answer once, in a variable. Calling `uname` again and again in each
test is wasteful and makes the code harder to read:

```bash
os="$(uname -s)"
```

Then branch, with an `else` for everything you did not plan for. Refusing
cleanly on an unknown platform is better than guessing and running the wrong
command:

```bash
if [[ $os == Linux ]]; then
  echo "cpu count: nproc"
elif [[ $os == Darwin ]]; then
  echo "cpu count: sysctl -n hw.ncpu"
else
  echo "unsupported platform: $os" >&2
  exit 1
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

os="$(uname -s)"

if [[ $os == Linux ]]; then
  echo "cpu count: nproc"
elif [[ $os == Darwin ]]; then
  echo "cpu count: sysctl -n hw.ncpu"
else
  echo "unsupported platform: $os" >&2
  exit 1
fi
```

## Try it by hand

In this game `uname` is a stand-in that reads `FAKE_UNAME`:

```bash
./solution.sh
FAKE_UNAME=Darwin ./solution.sh
FAKE_UNAME=FreeBSD ./solution.sh; echo "exit=$?"
```

## An alternative

`case "$(uname -s)" in Linux) ...;; Darwin) ...;; *) ...;; esac` does exactly
the same with less repetition. For two or three platforms either is fine;
`case` wins as the list grows.
