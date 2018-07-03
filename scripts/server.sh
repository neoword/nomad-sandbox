#!/bin/bash

echo "Provision consul config..."
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
	ExecStart=/usr/bin/consul agent -server -bootstrap-expect 1 -join node1 -bind $1 -data-dir /tmp/consul.d
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service
echo "Starting consul..."
sudo mkdir -p /tmp/consul.d
sudo systemctl enable consul.service
sudo systemctl start consul

# for bin in cfssl cfssl-certinfo cfssljson
# do
#	echo "Installing $bin..."
#	curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
# 	sudo install /tmp/${bin} /usr/local/bin/${bin}
# done

echo "Writing nomad server config..."
(
cat <<-EOF
# /etc/nomad.d/server.hcl
data_dir  = "/etc/nomad.d"
log_level = "DEBUG"
bind_addr = "$1"
server {
  enabled          = true
  bootstrap_expect = 1
}
EOF
) | sudo tee /etc/nomad.d/server.hcl

(
cat <<-EOF
[Unit]
Description=nomad agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/bin/nomad agent -config=/etc/nomad.d/server.hcl
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

echo "Starting nomad server..."
sudo systemctl enable nomad.service
sudo systemctl start nomad
