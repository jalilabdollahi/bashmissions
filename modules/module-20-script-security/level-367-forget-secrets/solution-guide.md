# Walkthrough: Forget Secrets

## The plan
Use the token for the one line that needs it and remove it from the shell
straight afterwards, so no program started later can see it.

## How secrets leak through the environment
When Bash starts a program it copies all *exported* variables into the new
process's environment. Anything that process does with its environment (print
it, save it in a crash report, send it in a bundle, show it in `ps e` on some
systems) now includes your secret. The longer the token lives in the shell, the
more programs it can reach.

## Steps
1. Check that the variable is set and not empty:
   `[[ -z ${API_TOKEN:-} ]]`. The `:-` default keeps `set -u` quiet.
2. Write the request line with `printf`, which treats the token as plain data.
3. `unset API_TOKEN` immediately. After this line, `support-bundle` and any other
   child start with a clean environment (minus the one variable).
4. Run `support-bundle --out bundle.txt` and print the final message.

If you had copied the value (`token=$API_TOKEN`), you would unset that variable
too. A non-exported copy is invisible to child processes, but it still sits in
memory and in any debugging output such as `set -x`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ -z ${API_TOKEN:-} ]]; then
  echo "API_TOKEN is not set" >&2
  exit 1
fi
printf 'Authorization: Bearer %s\n' "$API_TOKEN" > request.txt
unset API_TOKEN
support-bundle --out bundle.txt > /dev/null
echo "request signed, bundle sent"
```

## Try it
```
API_TOKEN=abc123 REGION=dory ./solution.sh
grep -c abc123 bundle.txt
```

## Alternative
Run the bundle tool with the variable removed for that one command only:
`env -u API_TOKEN support-bundle ...`. It is precise, but the shell still holds
the secret afterwards, so unsetting is the stronger habit.
