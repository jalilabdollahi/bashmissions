# Walkthrough: POST Form Data

## The plan
A browser form submission is a POST request whose body looks like `email=a@b.example&plan=pro`. curl sends exactly that when you give it `-d`. The script validates its arguments, sends the form, and prints what the server says.

## Steps
1. Two arguments or usage on stderr with exit 2:
   ```bash
   if [[ $# -ne 2 ]]; then
     echo "usage: solution.sh EMAIL PLAN" >&2
     exit 2
   fi
   ```
2. Name the arguments so the request reads well: `email=$1`, `plan=$2`.
3. Build the body inside double quotes so the variables expand, and let `-d` do the rest:
   ```bash
   reply=$(curl -s -d "email=$email&plan=$plan" https://billing.lanternfish.example/signup)
   ```
   You never write `-X POST`: giving curl a body already selects POST, and it adds the header `Content-Type: application/x-www-form-urlencoded` for you.
4. Print the answer with `printf 'reply: %s\n' "$reply"`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh EMAIL PLAN" >&2
  exit 2
fi
email=$1
plan=$2

reply=$(curl -s -d "email=$email&plan=$plan" https://billing.lanternfish.example/signup)

printf 'reply: %s\n' "$reply"
```

## Try it by hand
```
./solution.sh ollie@lanternfish.example pro
cat .calls.log          # what the pretend curl received
```

## Alternative
Two separate options, `-d "email=$email" -d "plan=$plan"`, produce the same request: curl joins repeated `-d` values with `&`. That reads nicely when there are many fields. A single string is fine for two.
