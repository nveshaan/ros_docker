
> This container is a production environment made to publish images from FLIR camera using ros2 spinnaker camera driver.

---
# Build
```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:cam .
```

# Run
```bash
chmod +x run_docker.sh
./run_docker.sh
```
Either use `--rm` or `--name=ros` tags.

