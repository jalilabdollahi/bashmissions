# Debrief: Build and Tag an Image

The mental model: **an image is immutable; tags are movable names.** The exact
version tag (`1.4.2`) should never move. `1.4` means "the newest 1.4.x" and
`latest` means "the newest stable release", so they move on purpose, and only
for releases that are meant to be picked up automatically. A release candidate
that steals `latest` is how a Friday experiment becomes a Saturday outage.

Building once and tagging afterwards guarantees every name resolves to
byte-identical content, which is what you want when you promote a build later.
Building three times could yield three slightly different images.

Under the hood the builder sends the context directory to the Docker daemon, and
`--build-arg` values become build-time variables for `ARG` lines. Neither is
secret: anyone with the image can read build args from its history, so tokens do
not belong there.

Scripts that wrap `docker` follow the same rules as any external tool: check the
exit status, stop pushing when something fails, and log what was done. Real
pipelines also login first and often push by digest, but the tag policy above
is the part people get wrong.

Going further: an image in a registry is not a running service. Next you deploy
it and refuse to call the job done until the service says it is healthy.
