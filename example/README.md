# HAProxy Consul Connect without mTLS

This example shows how to set up HAProxy Connect without mTLS. Three separate containers being spawned here are:

* [consul-server](consul-server): running Consul in server mode,

* [client](client): running Consul Agent, HAProxy Connect, HAProxy and Dataplane,

* [echo-server](echo-server): running Consul Agent, HAProxy Connect, HAProxy, Dataplane and echo server.

In this setup, client is attempting to communicate with echo-server. Both will receive configuration information about the cluster from the Consul server. HAProxy Consul Connect will start HAProxy and Dataplane on each container and configure HAProxy to be a local/sidecar proxy for the service. It will communicate with the local Consul instance (in each container) to get address information and use Dataplane API to configure local HAProxy instance accordingly.

Containers can be started with:

```console
docker-compose up -d
```

After all three containers have been created and initialized, sending HTTP requests through port 8080 on the client (*http://127.0.0.1:8080*) will end up being routed through client's instance of HAProxy to remote HAProxy instance with echo-server listener on echo-server container, which we can test with:

```console
docker-compose exec client curl http://127.0.0.1:8080
```

After testing, the stack can be teared down and cleaned up with:

```console
docker-compose down --rmi all
```

This example can be optionally extended to use [mTLS](https://www.consul.io/docs/connect/connect-internals) so that Consul assigns each client a SSL certificate. Then you can configure [intentions](https://www.consul.io/docs/connect/intentions) which control which services may or may not establish connections based on its certificate. HAProxy Consul Connect supports this kind of setup if it is being started with `-enable-intentions` and `-token` parameters.