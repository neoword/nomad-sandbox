#!/bin/bash

echo "Installing Consul..."
unzip /vagrant/artifacts/consul.zip
sudo install consul /usr/bin/consul
(
cat <<-EOF
	[Unit]
	Description=consul agent
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/consul agent -join node1 -bind $1 -data-dir /tmp/consul.d
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service
sudo mkdir -p /tmp/consul.d
sudo systemctl enable consul.service
sudo systemctl start consul

# set meta config for each node

# zookeeper meta config
zk_ips=("192.168.33.11" "192.168.33.12" "192.168.33.13")
if [[ " ${zk_ips[@]} " =~ " $1 " ]]; then
	ZK_META='"zookeeper" = "true"'
fi

# kafka meta config
kafka_ips=("192.168.33.11" "192.168.33.12" "192.168.33.13")
if [[ " ${kafka_ips[@]} " =~ " $1 " ]]; then
	KAFKA_META='"kafka" = "true"'
fi

# stream registry config
sr_ips=("192.168.33.11")
if [[ " ${sr_ips[@]} " =~ " $1 " ]]; then
	SR_META='"schema-registry" = "true"'
fi

# docker registry config
dr_ips=("192.168.33.11")
if [[ " ${dr_ips[@]} " =~ " $1 " ]]; then
	DR_META='"docker-registry" = "true"'
fi

function join_by { local IFS="$1"; shift; echo "$*"; }

META=`join_by , "${ZK_META}" "${KAFKA_META}" "${SR_META}" "${DR_META}"`

if [ ! -z "${META}" ]; then
	META_SECTION="meta { $META }"
fi

echo "Writing nomad client config..."
(
cat <<-EOF
# /etc/nomad.d/client.hcl

datacenter = "dc1"
data_dir   = "/etc/nomad.d"
log_level  = "DEBUG"
bind_addr = "$1"

client {
  enabled = true
  network_interface = "eth1"
	${META_SECTION}
}
EOF
) | sudo tee /etc/nomad.d/client.hcl

(
cat <<-EOF
	[Unit]
	Description=nomad agent
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/nomad agent -config=/etc/nomad.d/client.hcl
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

echo "Starting nomad client..."
sudo systemctl enable nomad.service
sudo systemctl start nomad
