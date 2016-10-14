# coreos-pxe
Docker image for setting up an CoreOS PXE server 

> This repository is a proof of concept only - don't use in production!
>

## Thanks to

This Project is build upon the work of [Quanlong He docker-coreos-pxe-installer](https://github.com/cybertk/docker-coreos-pxe-installer) 
but instead of installing CoreOS on a device, this project boots
CoreOS und builds the cluster without any harddrives needed.




## Running the Image

```
docker run --net=host -v ~/.ssh/id_rsa.pub:/app/rsa_public_key leuffen/coreos-pxe
```


