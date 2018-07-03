#!/bin/bash

# Update /etc/hosts
sudo sed -i "s/^.*$1/$2/" /etc/hosts
