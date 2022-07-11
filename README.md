# taskwarrior-container

Container image to run TaskWarrior without having to install it onto the host system.

## Building

A [multi-stage](https://docs.docker.com/develop/develop-images/multistage-build/) build is performed to keep the final image size small.

To build the container run the following command:

```
podman build -t taskwarrior:latest .
```

To build and older version of TaskWarrior:

```
podman build --build-arg TW_RELEASE=2.6.1 -t taskwarrior:2.6.1 .
```

## Usage

Create a volume to store your configuration and then run the container:

```
$ VOLUME=~/.local/share/containers/storage/volumes/taskwarrior
$ mkdir -p ${VOLUME}
$ podman run --rm -ti -v ${VOLUME}:/taskwarrior:Z taskwarrior
```

Here's an alias for convenience:

```
alias task='podman run --rm -ti -v ${VOLUME}:/taskwarrior:Z taskwarrior:latest'
```
