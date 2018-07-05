# Overview

This repo has install scripts for:
* Setting up a cluster of 4 vagrant boxes locally on your machine as host.
* The first one is the nomad Server, the other 3 are nomad client nodes
* Once the nomad cluster is provisioned with `vagrant up`, then a zookeeper nomad (HCL) job can be deployed
* Since zk requires "static knowledge" of its quorum peers, a static allocation is made to the nomad cluster via
  a private network and known IPs. This will also simplify other cluster installations like kafka.

Feel free to use any of this for your learning adventures.

*DISCLAIMER:* This setup has not been vetted for production.  I recommend load testing, soak testing, and contingency
planning before adopting any of these technologies into your production environment

# INSTALL
Start up your local cluster by running Vagrant.
```
> vagrant up
```

Once it is started... verify by looking at the running version of nomad_node
```
> open http://localhost:4646/
```

Now startup zookeeper job
```
> vagrant ssh node2 -c /vagrant/scripts/start_zk.sh
```

To stop the zookeeper job
```
> vagrant ssh node2 -c /vagrant/scripts/stop_zk.sh
```
