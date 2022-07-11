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

Note for your tasks to be persisted, you will have to change the
`data.location` to somewhere in a volume, e.g.:

```
$ task config data.location /taskwarrior/task
```

`man` is installed within the container and the man pages for TaskWarrior are
copied from the build image.

Here are two aliases for convenience:

```
$ alias task='podman run --rm -ti -v ${VOLUME}:/taskwarrior:Z taskwarrior:latest'
$ alias mtask='podman run --rm -ti -v ${VOLUME}:/taskwarrior:Z --entrypoint man taskwarrior:latest'
```

This way, you can add a task as you would outside a container:

```
$ task add Buy milk
Created task 1.
```

Note: when the `.taskrc` location is overridden, a header appears in every
command output. To avoid having the header show up, change the `verbose`
configuration accordingly, e.g.:

```
$ task config verbose 0
```

For further detail, refer to the `taskrc(5)` man page:

```
$ mtask taskrc
```
