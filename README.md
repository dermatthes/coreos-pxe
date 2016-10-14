# coreos-pxe
Docker image for setting up an CoreOS PXE server 

> This repository is a proof of concept only - don't use in production!
>

## Thanks to

This Project is build upon the work of [Quanlong He docker-coreos-pxe-installer](https://github.com/cybertk/docker-coreos-pxe-installer) 
but instead of installing CoreOS on a device, this project boots
CoreOS und builds the cluster without any harddrives needed.


## Abstract

This docker image will:

- Listen for dhcp offers on the first network interface (or configured)
- add pxeboot-options to the dhcp offers
- download the current CoreOS image from mirror
- offer the pxe-images per tftp for network-booting
- provide a configuration-webservice on port 888
- distribute your ssh public-key to all the nodes


## Running the Image

What you'll need:

- A properly configured and running DHCP Server offering ipv4 addresses (coreos-pxe acts in DHCP Proxy mode)
- At least 2 Nodes with network-cards configured in PXE mode and boot from network

Start the PXE-Service:

```
docker pull dermatthes/coreos-pxe
docker run --net=host -e INTERFACE=eth2 -v /root/.ssh/id_rsa.pub:/app/rsa_public_key --name corepxe dermatthes/coreos-pxe
```

Then start the first node. Wait until its online. You'll see the 
offers. 

You can log into the node by using public-key auth:

```
ssh core@<ip>
```




