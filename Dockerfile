FROM  layr/lean-dev:latest
MAINTAINER Laur

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
ARG RIDER_IDE_TAR=${RIDER_FULL_VER}.tar.gz

ADD rider /usr/local/bin

## -- derived vars ---
ENV RIDER_INSTALL_DIR="${HOME}/Rider${RIDER_MAJOR_VER}.${RIDER_MINOR_VER}"
# note confdir can be found in tarball/Install-Linux-tar.txt:
ENV RIDER_CONFIG_DIR="${HOME}/.config/JetBrains/Rider${RIDER_MAJOR_VER}.${RIDER_MINOR_VER}"
ENV RIDER_PROJECT_DIR="${HOME}/RiderProjects"

ENV RIDER_CONF_DIR_REAL="/rider-config-${RIDER_MAJOR_VER}-${RIDER_MINOR_VER}"
ENV RIDER_PROJECT_DIR_REAL="/rider-projects"

RUN mkdir -p \
        ${RIDER_INSTALL_DIR} \
        ${RIDER_CONF_DIR_REAL} \
        ${RIDER_PROJECT_DIR_REAL} && \
    ln -s "$RIDER_CONF_DIR_REAL" "$RIDER_CONFIG_DIR" && \
    ln -s "$RIDER_PROJECT_DIR_REAL" "$RIDER_PROJECT_DIR" && \
    chown -R "$USERNAME": "$RIDER_CONF_DIR_REAL" "$RIDER_PROJECT_DIR_REAL" && \
    wget --directory-prefix=/tmp https://download.jetbrains.com/rider/${RIDER_IDE_TAR} && \
    tar -xvf /tmp/${RIDER_IDE_TAR} -C ${RIDER_INSTALL_DIR} --strip-components=1 && \
    rm -- /tmp/${RIDER_IDE_TAR} && \
    ln -s "${RIDER_INSTALL_DIR}/bin/rider.sh" /usr/local/bin/rider-launcher

VOLUME ["$RIDER_CONF_DIR_REAL", "$RIDER_PROJECT_DIR_REAL"]
