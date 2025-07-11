FROM ghcr.io/shadichy/aaropa_rootfs_base:main

COPY template /
COPY packages /
COPY scripts /
COPY iso /iso

RUN apt update && apt upgrade -y

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

RUN /post-install.sh

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /post-setup.sh
RUN rm /*.sh
