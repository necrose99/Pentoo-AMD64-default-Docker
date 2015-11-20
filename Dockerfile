FROM gentoo/stage3-amd64

MAINTAINER necrose99 necrose99@protmail.ch mike@michaellawrenceit.com

#ADD http://www.busybox.net/downloads/binaries/latest/busybox-i686 /busybox

# This one should be present by running the build.sh script
RUN echo "Getting power ISO to Unpack Pentoo into the Gentoo root & Overlay"
RUN wget -O poweriso-1.3.tar.gz http://goo.gl/p8Tzc
RUN tar -xzvf poweriso-1.3.tar.gz -C /usr/local/bin
RUN chmod +x /usr/local/bin/poweriso
RUN mkdir /pentoo_tmp
RUN cd  /pentoo_tmp
RUN wget -bqc http://www.pentoo.ch/isos/latest-iso-symlinks/pentoo-amd64-default.iso
RUN sleep 520
RUN echo pentoo-amd64-default.iso unpacking"
RUN poweriso extract pentoo-amd64-default.iso / -od ./
RUN mv image.squashfs /
RUN mv /pentoo_tmp/modules/*.lzm /
RUN emerge -v sys-fs/squashfs-tools
RUN echo "unpacking Squashfile and modules"
RUN unsquashfs -f -d / /image.squashfs
RUN unsquashfs -f -d / /*.lzm 
RUN rm *.lzm && rm *.squashfs && rm -rf /pentoo_tmp/
RUN eslect profile set pentoo:pentoo/hardened/linux/amd64/bleeding_edge
RUN pentoo-updater
RUN echo "Bootstrapped  Pentoo iso into /:"
