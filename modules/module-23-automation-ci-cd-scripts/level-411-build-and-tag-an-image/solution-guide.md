# Walkthrough: Build and Tag an Image

## The plan
A container image is identified by `repository:tag`, but a tag is only a label.
You build once and then attach as many labels as the release deserves.
The policy is simple: the exact version always, and the moving labels
(`MAJOR.MINOR`, `latest`) only for stable releases.

## Steps
Parse the version once, with the suffix as its own capture group so "is this a
pre-release?" becomes "is `suffix` non-empty?":

```bash
re='^([0-9]+)\.([0-9]+)\.[0-9]+(-[0-9A-Za-z.]+)?$'
major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} suffix=${BASH_REMATCH[3]}
```

Build with `-t` naming the exact version. `--build-arg` hands the version to
the Dockerfile (`ARG VERSION`) so the app can print it; the last argument is the
build context, the directory sent to the builder:

```bash
if ! docker build --build-arg "VERSION=$version" -t "$image:$version" "$context"; then
  echo "build failed" >&2; exit 1
fi
```

The `if !` form is the cleanest way to react to a failing command without
fighting `set -e`.

For stable versions create the extra labels with `docker tag SOURCE TARGET`.
It copies nothing: both names point at the same image id. Keep every tag in
an array in the order created:

```bash
tags=("$version")
if [[ -z $suffix ]]; then
  docker tag "$image:$version" "$image:$major.$minor"
  docker tag "$image:$version" "$image:latest"
  tags+=("$major.$minor" latest)
fi
```

Finally push each tag, stopping at the first failure:

```bash
for tag in "${tags[@]}"; do
  docker push "$image:$tag" || { echo "push failed: $image:$tag" >&2; exit 1; }
  echo "pushed $image:$tag"
done
```

## Try it by hand
```bash
echo 'FROM scratch' > Dockerfile
./solution.sh dory/api 1.2.3; cat .calls.log
```

## Alternative
`docker build -t a:1.2.3 -t a:1.2 -t a:latest .` applies several tags in one
command. It is compact, but the policy decision (stable or not) then has to be
made before the build, and each push still needs its own call.
