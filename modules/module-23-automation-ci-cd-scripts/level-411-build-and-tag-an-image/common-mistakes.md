# Common Mistakes

- **Pushing `latest` for every build.** Wrong: tagging a `-rc1` as `latest`, so deployments pull an unfinished version. Right: only versions without a suffix move `latest` and `MAJOR.MINOR`.
- **Building once per tag.** Wrong: three `docker build -t` calls produce three images that may differ. Right: build once, then `docker tag`.
- **Pushing after a failed build.** Wrong: a build that errors is followed by `docker push`, publishing the previous image under the new tag. Right: `if ! docker build ...; then exit 1; fi` first.
- **Forgetting the tag in `push`.** Wrong: `docker push "$image"` pushes (or complains about) `latest` only. Right: `docker push "$image:$tag"`.
- **Putting secrets in build args.** Wrong: `--build-arg TOKEN=$TOKEN` ends up readable in the image history. Right: pass only non-secret values like the version.
