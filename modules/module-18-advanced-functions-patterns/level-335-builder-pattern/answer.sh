#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh NAME [KEY=VALUE ...]" >&2
  exit 2
fi

declare -A spec=()

vm_new() {
  spec=([name]=$1 [cpus]=1 [ram_gb]=2 [disk_gb]=20 [region]=eu-north)
}

# Helper: is $1 a whole number between $2 and $3?
in_range() {
  [[ $1 =~ ^[0-9]+$ ]] && (( $1 >= $2 && $1 <= $3 ))
}

# Each setter checks its own value, so the error names the culprit.
with_cpus() {
  if ! in_range "$1" 1 16; then echo "with_cpus: invalid value '$1'" >&2; return 1; fi
  spec[cpus]=$1
}
with_ram_gb() {
  if ! in_range "$1" 1 64; then echo "with_ram_gb: invalid value '$1'" >&2; return 1; fi
  spec[ram_gb]=$1
}
with_disk_gb() {
  if ! in_range "$1" 10 500; then echo "with_disk_gb: invalid value '$1'" >&2; return 1; fi
  spec[disk_gb]=$1
}
with_region() {
  case $1 in
    eu-north|eu-south|us-east) spec[region]=$1 ;;
    *) echo "with_region: invalid value '$1'" >&2; return 1 ;;
  esac
}

# Only build knows about relations between fields.
build() {
  local need=$(( 2 * spec[cpus] ))
  if (( spec[ram_gb] < need )); then
    echo "build: ${spec[cpus]} cpus need at least $need GB of RAM" >&2
    return 1
  fi
  echo "vm=${spec[name]}"
  echo "cpus=${spec[cpus]}"
  echo "ram_gb=${spec[ram_gb]}"
  echo "disk_gb=${spec[disk_gb]}"
  echo "region=${spec[region]}"
}

vm_new "$1"
shift
for arg in "$@"; do
  key=${arg%%=*}
  value=${arg#*=}
  case $key in
    cpus)    with_cpus "$value" || exit 2 ;;
    ram_gb)  with_ram_gb "$value" || exit 2 ;;
    disk_gb) with_disk_gb "$value" || exit 2 ;;
    region)  with_region "$value" || exit 2 ;;
    *) echo "unknown option: $key" >&2; exit 2 ;;
  esac
done
build || exit 2
