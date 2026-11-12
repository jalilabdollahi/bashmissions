# Debrief: DNS Lookups

## What you learned

Every connection starts with a name that must become an address, and DNS is the phone book that does it. `dig` asks the phone book directly. Its default output is a full report; `+short` strips it down to the answers, which is the form scripts want.

## Under the hood

A name can resolve through aliases. `www.harbourbakery.example` is a CNAME pointing at `shop.lanternfish.example`, which in turn has two A records; `dig +short` lists the whole chain, so filtering by shape (an IPv4 address) is how you keep only what you came for. Several A records for one name are normal: clients may use any of them.

Two kinds of "nothing" need telling apart. A name that does not exist (NXDOMAIN) is a valid DNS answer: dig exits 0 and, with `+short`, prints an empty string. Only when no resolver can be reached does dig exit non-zero (status 9 for a timeout). Exit status says "could I ask?", the output says "what was the answer?", the same distinction you met with curl and HTTP codes.

## In real work

DNS checks verify migrations ("is the new address live yet?"), spot expired records, and prove to a customer that the problem is on their side. Note that your own machine may cache answers; `dig` queries the resolver directly, which is why it is the trusted tool.

## Going further

You can now verify that you can reach a service. Next you will download a file and make sure that what arrived is what was sent.
