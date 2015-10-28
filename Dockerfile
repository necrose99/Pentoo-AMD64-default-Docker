FROM busybox

MAINTAINER necrose99 necrose99@protmail.ch mike@michaellawrenceit.com

# This one should be present by running the build.sh script
ADD build.sh /

RUN /build.sh amd64 x86_64

# Setup the (virtually) current runlevel
RUN echo "default" > /run/openrc/softlevel

# Setup the rc_sys
RUN sed -e 's/#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf

# Setup the net.lo runlevel
RUN ln -s /etc/init.d/net.lo /run/openrc/started/net.lo

# Setup the net.eth0 runlevel
RUN ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
RUN ln -s /etc/init.d/net.eth0 /run/openrc/started/net.eth0

# By default, UTC system
RUN echo 'UTC' > /etc/timezone
CMD ["/bin/bash"]
# Accepting licenses needed to continue automatic install/upgrade
ADD ./conf/spinbase-licenses /etc/entropy/packages/license.accept

# Upgrading packages and perform post-upgrade tasks (mirror sorting, updating repository db)
ADD ./script/post-upgrade.sh /post-upgrade.sh
RUN echo use-rcs=yes /etc/dispatch-conf.conf
RUN emerge  dev-vcs/rcs layman git
RUN rsync -av "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
	echo -5 | etc-update -5

  RUN rsync -r "http://pentoo.east.us.mirror.inerail.net/Packages/amd64-default/" "/usr/portage/Packages"

RUN /bin/bash /post-upgrade.sh  && \
	rm -rf /post-upgrade.sh
