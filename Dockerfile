FROM ubuntu:14.04

MAINTAINER Matthias Leuffen <matthes@leuffen.de>

RUN echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/  trusty main restricted universe multiverse" > /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/  trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb http://vesta.informatik.rwth-aachen.de/ftp/pub/Linux/ubuntu/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

# Install deps
RUN apt-get update && apt-get install -y dnsmasq syslinux wget openssh-server openssh-client php5-cli squashfs-tools

COPY app /app
COPY oem /oem

# Install pxelinux.0
RUN mkdir app/tftp && cp /usr/lib/syslinux/pxelinux.0 /app/tftp

# Import CoreOS Signing Key
RUN wget -qO- https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.pem | gpg --import

# Install coreos pxe images
RUN cd /app/tftp && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig && \
    gpg --verify coreos_production_pxe.vmlinuz.sig

# Download image to /tmp
RUN cd /tmp && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz && \
    wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig && \
    gpg --verify coreos_production_pxe_image.cpio.gz.sig

# Extract and combine with /oem
RUN mkdir /tmp/initrd && \
    cd /tmp/initrd && \
    cat /tmp/coreos_production_pxe_image.cpio.gz | gzip -d | cpio -i && \
    unsquashfs -f -d ./tttmp usr.squashfs && \
    cp -R /oem/* ./tttmp && \
    rm usr.squashfs && \
    echo "Wurst" > ./tttmp/lalelu && \
    mksquashfs ./tttmp ./usr.squashfs && \
    rm -R ./tttmp && \
    find | cpio -o --format=newc | gzip -9c > /app/tftp/coreos_production_pxe_image_oem.cpio.gz

# Cleanup
RUN cd /tmp && rm -R *






#     wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig && \
#     wget -q http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig && \
#     wget -qO- https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.pem | gpg --import && \
#     gpg --verify coreos_production_pxe.vmlinuz.sig && \
#     gpg --verify coreos_production_pxe_image.cpio.gz.sig


# Customizations
ENV INTERFACE=eth1

CMD /app/init
