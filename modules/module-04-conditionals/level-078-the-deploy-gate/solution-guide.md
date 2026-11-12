# Walkthrough: The Deploy Gate

## The plan

The napkin policy is a tree of questions. Some questions only matter if an
earlier one came out a certain way, and that is exactly what nesting expresses:
an `if` inside the branch of another `if`.

```
arguments valid?  ->  else usage / unknown environment (exit 2)
tests pass?       ->  no: BLOCKED
  environment?    ->  staging: DEPLOY
                      prod:
                        freeze.flag?   -> BLOCKED
                        approvals < 2? -> BLOCKED
                        otherwise      -> DEPLOY
```

## Building it

Start with the guards. They deal with bad input and exit, so everything after
them can assume three valid arguments and a known environment:

```bash
if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh ENV TESTS APPROVALS" >&2
  exit 2
fi
env_name="$1"; tests="$2"; approvals="$3"
if [[ $env_name != staging && $env_name != prod ]]; then
  echo "unknown environment: $env_name" >&2
  exit 2
fi
```

The outer decision is the one that applies to everybody, red tests:

```bash
if [[ $tests != pass ]]; then
  echo "BLOCKED: tests are not passing"
else
```

Inside the `else` (tests are green) the environment decides. Staging is done;
production opens a third level with the production-only rules in the policy's
order: the freeze file first, then approvals:

```bash
  if [[ $env_name == staging ]]; then
    echo "DEPLOY: staging"
  else
    if [[ -e freeze.flag ]]; then
      echo "BLOCKED: change freeze is active"
    elif (( approvals < 2 )); then
      echo "BLOCKED: prod needs 2 approvals, has $approvals"
    else
      echo "DEPLOY: prod"
    fi
  fi
fi
```

Each `if` has its own `fi`; indentation shows which belongs to which.

## Complete solution

See `answer.sh`: it is the code above with the guards and the nested block in
one file.

## Try it by hand

```bash
./solution.sh prod pass 2
./solution.sh prod pass 1
touch freeze.flag; ./solution.sh prod pass 3
./solution.sh staging pass 0
```

## An alternative

Flat conditions with `&&` (`[[ $env == prod && ! -e freeze.flag && ... ]]`)
avoid nesting but repeat the shared questions in every rung, and the reasons for
blocking get harder to say separately. Nesting mirrors how people describe policy.
