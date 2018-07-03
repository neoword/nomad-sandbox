#!/bin/bash
NOMAD_ADDR="http://192.168.33.11:4646" nomad job stop zookeeper
curl -X PUT "http://192.168.33.11:4646/v1/system/gc"
