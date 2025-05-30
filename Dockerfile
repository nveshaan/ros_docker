FROM osrf/ros:humble-desktop-full

# install necessary tools
RUN apt-get update \
    && apt-get install -y \
    nano \
    usbutils \
    net-tools \
    udev \
    build-essential
  

# adding a non-root user
ARG USERNAME
# USER_UID must be specified at build time with --build-arg USER_UID=$(id -u)
ARG USER_UID
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# install 'sudo'
RUN apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# install colcon and rosdep
RUN sudo apt-get update \
    && sudo apt-get install python3-colcon-common-extensions python3-rosdep -y \
    && rosdep update

# spinnaker sdk installation
ADD spinnaker-4.2.0.46-amd64 /root/spinnaker-debs
# RUN chmod +x ./install_spinnaker.sh
RUN yes | /root/spinnaker-debs/install_spinnaker.sh

# ready to run
COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

# fix permissions on user files
RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc && \
    chmod 644 /home/${USERNAME}/.bashrc && \
    chmod +x /entrypoint.sh

RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]
