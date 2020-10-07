FROM  layr/lean-dev:latest
MAINTAINER Laur

ARG TMPDIR=/tmp

ARG RIDER_MAJOR_VER
ENV RIDER_MAJOR_VER=${RIDER_MAJOR_VER:-2020}
ARG RIDER_MINOR_VER
ENV RIDER_MINOR_VER=${RIDER_MINOR_VER:-2}
ARG RIDER_PATCH_VER
ENV RIDER_PATCH_VER=${RIDER_PATCH_VER:-4}

# rider setup
#   https://www.jetbrains.com/rider/download/other.html
#   eg https://download.jetbrains.com/rider/.tar.gz
ARG RIDER_FULL_VER=${RIDER_FULL_VER:-"JetBrains.Rider-${RIDER_MAJOR_VER}.${RIDER_MINOR_VER}.$RIDER_PATCH_VER"}
ADD rider /usr/local/bin

## -- derived vars ---
ENV RIDER_INSTALL_DIR="${HOME}/Rider${RIDER_MAJOR_VER}.${RIDER_MINOR_VER}"
# note confdir can be found in tarball/Install-Linux-tar.txt:
ENV RIDER_CONFIG_DIR="${HOME}/.Rider${RIDER_MAJOR_VER}.${RIDER_MINOR_VER}"
ENV RIDER_PROJECT_DIR="${HOME}/RiderProjects"
ARG RIDER_IDE_TAR=${RIDER_FULL_VER}.tar.gz


RUN mkdir -p \
        ${RIDER_INSTALL_DIR} \
        ${RIDER_CONFIG_DIR} \
        ${RIDER_PROJECT_DIR} && \
    wget --directory-prefix=$TMPDIR https://download.jetbrains.com/rider/${RIDER_IDE_TAR} && \
    tar -xvf $TMPDIR/${RIDER_IDE_TAR} -C ${RIDER_INSTALL_DIR} --strip-components=1 && \
    rm -- $TMPDIR/${RIDER_IDE_TAR} && \
    ln -s "${RIDER_INSTALL_DIR}/bin/rider.sh" /usr/local/bin/rider-launcher

VOLUME ${RIDER_PROJECT_DIR}
VOLUME ${RIDER_CONFIG_DIR}
