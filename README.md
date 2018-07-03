# INSTALL
Now start up your local cluster by running Vagrant.
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

Top stop the zookeeper job
```
> vagrant ssh node2 -c /vagrant/scripts/stop_zk.sh
```
