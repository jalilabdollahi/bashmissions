# Debrief: The SLA Monitor

An availability number is an accounting exercise, and accounting is about rules written down before the incident. In this mission the rules were explicit: a minute is the unit, a missing probe is downtime, "degraded" counts depending on a flag, and the verdict compares exact integers. Change any one of those rules and the same logs give a different answer, which is why contracts spell them out.

The error budget is the useful reframing. "99.9%" sounds like a quality goal; "43 minutes a month" is a *spending limit*. Teams that track the budget can answer practical questions: may we ship the risky change today, or have we spent too much? That is also why `AT RISK` exists: a warning is only useful while there is still something left to protect.

Technically, you practised three habits. Scale decimals to integers and multiply before dividing. Never judge on a rounded number: round for display, compare exactly. And treat a gap in your own data as a finding, not as silence; a monitor that assumes "no news is good news" is the first thing to fail in a storm.

Run-length counting (the outage and longest columns) is a pattern you will reuse for streaks in any log: keep a counter, close it on the first change, and remember to close it again at the end of the input.

Going further: the SLA monitor says how much it cost. The next mission says what it costs in money: usage multiplied by a price list becomes an invoice.
