arch=$(uname -m)

echo "Detected architecture: $arch"

if [[ "$arch" == "x86_64" ]]; then
  docker build --build-arg IMG="osrf/ros-humble-desktop-full" --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:cam .
elif [[ "$arch" == "aarch64" ]] || [[ "$arch" == "arm64" ]]; then
	docker build --build-arg IMG="dustynv/ros:humble-desktop-l4t-r35.4.1" --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:cam .
else
  echo "Unknown architecture: $arch"
fi
