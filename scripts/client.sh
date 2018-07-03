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


zk_ips=("192.168.33.11" "192.168.33.12" "192.168.33.13")
if [[ " ${zk_ips[@]} " =~ " $1 " ]]; then
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
		meta {
			"zookeeper" = "true"
		}
	}
	EOF
	) | sudo tee /etc/nomad.d/client.hcl
fi

if [[ ! " ${zk_ips[@]} " =~ " $1 " ]]; then
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
	}
	EOF
	) | sudo tee /etc/nomad.d/client.hcl
fi

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
