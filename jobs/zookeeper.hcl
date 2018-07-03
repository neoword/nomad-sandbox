# Zookeeper
job "zookeeper" {
    region = "global"
    datacenters = ["dc1"]
    type = "service"

    # Run tasks in serial or parallel (1 for serial)
    update {
        max_parallel = 1
    }

    # define job constraints
    constraint {
        attribute = "${attr.kernel.name}"
        value = "linux"
    }
    constraint {
        attribute = "${meta.zookeeper}"
        value = "true"
    }
    # define group
    group "zk-group" {

        # define the number of times the tasks need to be executed
        count = 3

        # because we have 3 client nodes, we are guaranteed to be on node1, node2, node3
        # NOTE: if the number of nodes are changed this WILL BREAK... will need to add a node meta constraing
        #       to ensure that there are only 3 "ZK-READY" nodes
        constraint {
            operator  = "distinct_hosts"
            value     = "true"
        }

        # specify the number of attemtps to run the job within the specified interval
        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

        task "zk-data-dir" {
            driver = "exec"
            config {
                command = "mkdir"
                args = [ "-p", "/opt/zookeeper/datadir" ]
            }
        }
        task "zk-log-dir" {
            driver = "exec"
            config {
                command = "mkdir"
                args = [ "-p", "/opt/zookeeper/log" ]
            }
        }

        task "zookeeper" {
            driver = "docker"
            template {
              data        = <<EOT
                # generated at deployment
                {{$i := env "NOMAD_ALLOC_INDEX"}}
                ZOOKEEPER_SERVER_ID   = {{$i | parseInt | add 1}}
                ZOOKEEPER_SERVERS     = {{if eq $i "0"}}0.0.0.0:2888:3888;node3:2888:3888;node4:2888:3888{{else}}{{if eq $i "1"}}node2:2888:3888;0.0.0.0:2888:3888;node4:2888:3888{{else}}node2:2888:3888;node4:2888:3888;0.0.0.0:2888:3888{{end}}{{end}}
                ZOOKEEPER_HOST        = {{if eq $i "0"}}node2{{else}}{{if eq $i "1"}}node3{{else}}node4{{end}}{{end}}
                ZOOKEEPER_IP        = {{if eq $i "0"}}192.168.33.11{{else}}{{if eq $i "1"}}192.168.33.12{{else}}192.168.33.13{{end}}{{end}}
              EOT
              destination = "zk-env/zookeeper.env"
              env         = true
            }
            env {
              ZOOKEEPER_CLIENT_PORT = 2181 # "${NOMAD_HOST_PORT_zk}"
            }
            config {
#                network_mode = "host"
                image = "confluentinc/cp-zookeeper:4.1.1-2"
                hostname = "${ZOOKEEPER_HOST}"
#                ipv4_address = "${ZOOKEEPER_IP}"
                labels {
                    group = "zk-docker"
                }
                extra_hosts = [
                    "node1:192.168.33.10",
                    "node2:192.168.33.11",
                    "node3:192.168.33.12",
                    "node4:192.168.33.13"
                ]
                port_map {
                    zk = 2181
                    zk_leader = 2888
                    zk_election = 3888
                }
                volumes = [
                    "/opt/zookeeper/datadir:/var/lib/zookeeper/data",
                    "/opt/zookeeper/log:/var/lib/zookeeper/log"
                ]
            }
            resources {
                cpu = 100
                memory = 128
                network {
                    mbits = 10
                    port "zk" {
                      static = 2181
                    }
                    port "zk_leader" {
                      static = 2888
                    }
                    port "zk_election" {
                      static = 3888
                    }
                }
            }
            service {
                tags = ["zookeeper"]
                port = "zk"
                address_mode = "driver"
                check {
                    type = "tcp"
                    port = "zk"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}
