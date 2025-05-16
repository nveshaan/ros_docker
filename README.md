> NOTE: It is meant to be run in UNIX based environments. Linux & Mac support it right away. In Windows, run in WSL.

# Build

```bash
docker build --build-arg USER_UID=$(id -u) -t ros:nv .
```

# Run

```bash
docker run -it --user=ros --network=host --ipc=host --pid=host --privileged ros:nv
```

---

Be sure to run the following command before installing any packages:

```bash
sudo apt-get update
```
