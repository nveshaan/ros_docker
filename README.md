
> This container is a production environment made to publish images from FLIR camera using ros2 spinnaker camera driver.

---
# Build
```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:cam .
```

# Run
```bash
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --user=$(id -un) --network=host --ipc=host --pid=host --privileged ros:cam
```
Either use `--rm` or `--name=ros` tags.

