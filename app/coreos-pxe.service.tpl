[Unit]
Description=CoreOSPxeAnnouncing
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill coreos-pxe
ExecStartPre=-/usr/bin/docker rm coreos-pxe
ExecStartPre=/usr/bin/docker pull dermatthes/coreos-pxe
ExecStart=/usr/bin/docker run --net=host -e MODE=JOIN -e INTERFACE=enp8s0 -v /bootpxe/rsa_public_key:/app/rsa_public_key -v /bootpxe/etcd_discovery_token:/app/config/etcd_discovery_token --name coreos-pxe dermatthes/coreos-pxe
ExecStop=/usr/bin/docker stop coreos-pxe
