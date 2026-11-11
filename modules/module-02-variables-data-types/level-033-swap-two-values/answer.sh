#!/usr/bin/env bash
# Failover helper. Overwriting a variable destroys its old value, so park
# one of them in a temporary variable first.

echo "before: primary=$PRIMARY standby=$STANDBY"

tmp=$PRIMARY        # 1. save the primary
PRIMARY=$STANDBY    # 2. primary takes the standby's value
STANDBY=$tmp        # 3. standby takes the saved value

echo "after: primary=$PRIMARY standby=$STANDBY"
