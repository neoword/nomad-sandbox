# Overview

This repo has install scripts for:
* Setting up a cluster of 4 vagrant boxes locally on your machine as host.
* The first one is the nomad Server, the other 3 are nomad client nodes
* Once the nomad cluster is provisioned with `vagrant up`, then a nomad (HCL) job can be deployed
* Since jobs like zookeeper require "static knowledge" of its quorum peers, a static allocation is made to the nomad cluster via
  a private network and known IPs. This will also simplify other cluster installations like kafka.
  (See [confluent-sandbox][e07346f4] for more details.)

[e07346f4]: https://github.com/neoword/confluent-sandbox "confluent-sandbox"

Feel free to use any of this for your learning adventures.

*DISCLAIMER:* This setup has not been vetted for production.  I recommend load testing, soak testing, and contingency
planning before adopting any of these technologies into your production environment

# INSTALL
Start up your local cluster by running Vagrant.
```
> vagrant up
```

Once it is started... verify nomad is running by browsing to the nomad ui
```
> open http://localhost:4646/
```
