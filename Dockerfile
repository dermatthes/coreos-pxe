FROM ubuntu:14.04

MAINTAINER Matthias Leuffen <matthes@leuffen.de>

RUN echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/  trusty main restricted universe multiverse" > /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/  trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

# Install deps
RUN apt-get update && apt-get install -y dnsmasq syslinux wget

COPY app /app

# Install pxelinux.0
RUN mkdir app/tftp && cp /usr/lib/syslinux/pxelinux.0 /app/tftp

# Install coreos pxe images
RUN cd /app/tftp && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz

#     wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig && \
#     wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig && \
#     wget -qO- https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.pem | gpg --import && \
#     gpg --verify coreos_production_pxe.vmlinuz.sig && \
#     gpg --verify coreos_production_pxe_image.cpio.gz.sig


# RUN chmod 644 pxe/pxelinux.cfg/default && \
#     chmod 644 pxe/pxelinux.0 && \
#     chmod 644 pxe/coreos_production_pxe_image.cpio.gz && \
#     chmod 644 pxe/coreos_production_pxe.vmlinuz

# Customizations
ENV INTERFACE=eth1

CMD /app/init
