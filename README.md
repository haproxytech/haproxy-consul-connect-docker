# Supported tags and respective `Dockerfile` links

-	[`latest`](https://github.com/haproxytech/haproxy-consul-connect-docker/blob/master/Dockerfile)

# Quick reference

-	**Where to get help**:  
	[HAProxy mailing list](mailto:haproxy@formilux.org), [HAProxy Community Slack](https://slack.haproxy.org/) or [#haproxy on FreeNode](irc://chat.freenode.net:6697/haproxy)

-	**Where to file issues**:  
	[https://github.com/haproxytech/haproxy-consul-connect-docker/issues](https://github.com/haproxytech/haproxy-consul-connect-docker/issues)

-	**Maintained by**: 
	[HAProxy Technologies](https://github.com/haproxytech) and [Criteo](https://github.com/criteo)

-	**Supported architectures**: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
	[`amd64`](https://hub.docker.com/r/amd64/haproxy/)

-	**Image updates**:  
	[commits to `haproxytech/haproxy-consul-connect-docker`](https://github.com/haproxytech/haproxy-consul-connect-docker/commits/master), [top level `haproxytech/haproxy-consul-connect-docker` image folder](https://github.com/haproxytech/haproxy-consul-connect-docker)  

-	**Source of this description**:  
	[README.md](https://github.com/haproxytech/haproxy-consul-connect-docker/blob/master/README.md)

# What is HAProxy Connect

[Consul Connect](https://www.consul.io/docs/connect/index.html) provides a simple way to setup service mesh between your services by offloading the load balancing logic to a sidecar process running alongside your application. It exposes a local port per service and takes care of forwarding the traffic to alives instances of the services your application wants to target. Additionnaly, the traffic is automatically encrypted using TLS, and can be restricted by using [intentions](https://www.consul.io/docs/connect/intentions.html) by selecting what services can or cannot call your application.
[HAProxy](https://www.haproxy.org) is a proven load balancer widely used in the industry for its high performance and reliability.
HAProxy Connect allows to use HAProxy as a load balancer for Consul Connect.

## Architecture

Three components are used:

* HAProxy, the load balancer

* Dataplane API, which provides a high level configuration interface for HAProxy

* HAProxy Connect, that configures HAProxy through the Dataplane API with information pulled from Consul.

To handle intentions, HAProxy Connect, sets up a SPOE filter on the application public frontend. On each connection HAProxy checks with HAProxy Connect that the incomming connection is authorized. HAProxy Connect parses the request certificates and in turn calls the Consul agent to know wether it should tell HAProxy to allow or deny the connection.

![architecture](https://raw.githubusercontent.com/haproxytech/haproxy-consul-connect/master/docs/architecture.png)

## Requirements

* [HAProxy](https://www.haproxy.org/) >= v1.9
* [DataplaneAPI](https://www.haproxy.com/documentation/hapee/1-9r1/configuration/dataplaneapi/) >= v1.2
* [Consul](https://www.consul.io/) >= 1.2

## How to use

```
./haproxy-consul-connect --help
Usage of ./haproxy-consul-connect:
  -dataplane string
    	Dataplane binary path (default "dataplane-api")
  -enable-intentions
    	Enable Connect intentions
  -haproxy string
    	Haproxy binary path (default "haproxy")
  -haproxy-cfg-base-path string
    	Haproxy binary path (default "/tmp")
  -http-addr string
    	Consul agent address (default "127.0.0.1:8500")
  -log-level string
    	Log level (default "INFO")
  -sidecar-for string
    	The consul service id to proxy
  -sidecar-for-tag string
    	The consul service id to proxy
  -stats-addr string
    	Listen addr for stats server
  -stats-service-register
    	Register a consul service for connect stats
  -token string
    	Consul ACL token./haproxy-consul-connect --help
```

# How to use this image

Minimal working example for [Docker Compose](https://docs.docker.com/compose/) is in [example](example) folder, showing how to set up Consul Connect without mTLS, with a simple client, consul server and echo server.

# License

View [license information](https://raw.githubusercontent.com/haproxytech/haproxy-consul-connect/master/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
