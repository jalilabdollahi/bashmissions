#!/usr/bin/env bash
set -euo pipefail

work(){ echo work; }
decorated(){ echo before; work; echo after; }
decorated
