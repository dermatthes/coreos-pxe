# Manually start docker swarm


```
docker run swarm create
```

Returns a id: Copy it (last line)

Token: `531ce0d785621a8c9f4748b4de28f87e`



On each machine:
```
docker run -d -p 2375:2375 swarm join --listen-addr=$COREOS_PRIVATE_IPV4:2375 etcd://$COREOS_PRIVATE_IPV4:2379/swarm
```


On one machine:

```
docker run -d -p 8333:2375 swarm manage etcd://$COREOS_PRIVATE_IPV4:2379/swarm
```

To see it:

```
docker -H tcp://$COREOS_PRIVATE_IPV4:8333 info
```


## Swarm init with distributed registry

```
docker swarm init --advertise-addr $COREOS_PRIVATE_IPV4
```

displays command to run to join the cluster:

``` 
docker swarm join \
    --token <some token> \
    <masterip>:2377
```

Verify by

```
docker node ls
```

shows the nodes