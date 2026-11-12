#!/usr/bin/env bash
set -euo pipefail

stamp=$1

# ${stamp:OFFSET:LENGTH}: offsets count from 0, so the year starts at 0,
# the month at 4, the day at 6, then "T" sits at 8 and the time starts at 9.
year=${stamp:0:4}
month=${stamp:4:2}
day=${stamp:6:2}
hour=${stamp:9:2}
minute=${stamp:11:2}
second=${stamp:13:2}

echo "date=$year-$month-$day"
echo "time=$hour:$minute:$second"
