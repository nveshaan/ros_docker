> This container is made to get ROS 2 running on Windows with Linux capabilities. Please run this using WSL.

---

# Prerequisites
Install the following tools:
1. [usbipd](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)
2. [XLaunch](https://sourceforge.net/projects/vcxsrv/)
3. Docker & WSL2 Ubuntu 22.04

# Build
```bash
docker build --build-arg USER_UID=$(id -u) -t ros:nv .
```

# Run
```bash
docker run -it --user=ros --network=host --ipc=host --pid=host --privileged ros:nv
```

# GUI Forwarding
Start the XLaunch app as mentioned (here)[https://jackkawell.wordpress.com/2019/09/11/setting-up-ros-in-windows-through-docker/].

# Port Forwarding
1. Open PowerShell in *administrator* mode, and run the command to list all devices connected to Windows.
```bash
usbipd list
```

2. Run this command if the device you want your container to access is not in `shared` mode.
```bash
usbipd bind --busid <bus ID of your device>
```
Add `--force` tag if needed. Using the above command, you can check that it is now in `shared` mode.

3. Now, Docker in Windows uses WSL as its backend. Attaching the devices to WSL allows Docker to access them as well.
```bash
udbipd attach --wsl --busid <busid>
```
Again, you can verify using the first command. You should see it as `attached`. Be aware that you won't be able to use your device on Windows while it is in the `attached` state.

4. In the container, you can check the devices which are connected using this command:
```bash
lsusb
```

5. To detach the device,
```bash
usbipd detach --busid <busid>
```
Or, use the `--all` tag to detach all devices.

---

Be sure to run the following command before installing any packages:
```bash
sudo apt-get update
```
