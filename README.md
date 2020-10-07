# lean-dev-rider

Packages Intellij Rider into its [lean-dev](https://github.com/laur89/Lean-dev)
base-image.
Any commit on this repo also causes docker build to be triggered.

## Usage

In order to be able to run GUI programs from docker, allow X11 connections from the
host; for that we have two options:

### Allow for user (not recommended)

```xhost +si:localuser:$USER```

Note this doesn't persist and has to be re-run after host reboot.

Unsure what the security implications are here, but this is roughly the docker-compose
you'd want to use:

    services:
      dev:
        image: layr/lean-dev-rider:latest
        working_dir: $SRC_MOUNT
        container_name: lean-dev
        environment:
          - HOST_USER_ID=$UID
          - HOST_GROUP_ID=$GID
          - SRC_MOUNT=$SRC_MOUNT
          - DISPLAY
        ports:
          - "2223:22"
        volumes:
          - ./:${SRC_MOUNT}:cached
          - /tmp/.X11-unix:/tmp/.X11-unix
        tty: true

### Recommended usage, setting container's XAUTHORITY

Note this setup is taken from [here](https://towardsdatascience.com/real-time-and-video-processing-object-detection-using-tensorflow-opencv-and-docker-2be1694726e5)

- `export XAUTH=$HOME/.docker.xauth`
  - note this step needs to be done upon every reboot
- `touch $XAUTH`
- `xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -`

Example of `docker-compse` to go with it:

    services:
      dev:
        image: layr/lean-dev-rider:latest
        working_dir: $SRC_MOUNT
        container_name: lean-dev
        environment:
          - HOST_USER_ID=$UID
          - HOST_GROUP_ID=$GID
          - SRC_MOUNT=$SRC_MOUNT
          - DISPLAY
          - XAUTHORITY=$XAUTH
        ports:
          - "2223:22"
        volumes:
          - ./:${SRC_MOUNT}:cached
          - /tmp/.X11-unix:/tmp/.X11-unix
          - $XAUTH:$XAUTH
        tty: true

You can also build this image yourself, eg if you need specific version of Rider:

    services:
      dev:
        build:
          context: ./lean-dev-rider
          args:
            RIDER_MAJOR_VER: $RIDER_MAJOR_VER
            RIDER_MINOR_VER: $RIDER_MINOR_VER
            RIDER_PATCH_VER: $RIDER_PATCH_VER
        working_dir: $SRC_MOUNT
        container_name: lean-dev
        environment:
          - HOST_USER_ID=$UID
          - HOST_GROUP_ID=$GID
          - SRC_MOUNT=$SRC_MOUNT
          - DISPLAY
          - XAUTHORITY=$XAUTH
        ports:
          - "2223:22"
        volumes:
          - ./:${SRC_MOUNT}:cached
          - /tmp/.X11-unix:/tmp/.X11-unix
          - $XAUTH:$XAUTH
        tty: true

Note in this case following env vars are to be provided either by `.env` file
or manually defined in docker-compose:
  - `SRC_MOUNT`
  - `RIDER_MAJOR_VER`  (eg "2020")
  - `RIDER_MINOR_VER`  (eg "2")
  - `RIDER_PATCH_VER`  (eg "4")

