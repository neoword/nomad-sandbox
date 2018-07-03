#!/bin/bash

# Execue this script by doing the following:
# vagrant ssh node2 -c /vagrant/scripts/start_zk.sh
NOMAD_ADDR="http://192.168.33.11:4646" nomad job run /vagrant/jobs/zookeeper.hcl
