# Debrief: Firewall Rule Audit

## What you learned

Configuration audits are parsing plus predicates. The export format (`-A CHAIN option value ... -j TARGET`) is regular enough that one pass of awk extracts everything you need, and each policy becomes a one-line condition. The line numbers in the output make the report directly actionable: open the file, jump to line 10, fix it.

## Under the hood

iptables evaluates INPUT rules top to bottom and the first match wins, with the chain policy as the fallback. That is why a default-ACCEPT policy is dangerous: anything not explicitly dropped gets in. "Open to the world" means the rule has no source restriction, and the same rule with `-s 10.0.0.0/8` would be fine. The audit looks at what a rule permits, not at the order, so a real tool would also check for shadowed or dead rules.

awk's `exit` in the `END` block sets the status, and awk being the last command passes it through the script. Resetting variables at the start of every rule is essential, since awk variables persist between lines.

## In real work

The same approach audits sshd_config, sudoers and nginx configs. Real firewalls add nftables, security groups and cloud rules, but a text export plus a checker run from cron is how most small teams stay honest.

## Going further

Next you will audit another file that is easy to get dangerously wrong: sshd_config, where the first value wins.
