FROM ros:humble-ros-core
# Example of installing programs
RUN apt update 
RUN apt install ros-${ROS_DISTRO}-xacro -y\
    python3-rosdep\
    python3-colcon-common-extensions

RUN apt-get update \
    && apt-get install -y \
    nano \
    vim \
    libfreeimage-dev\ 
    && rm -rf /var/lib/apt/lists/*
RUN rosdep init
RUN rosdep update
# Example of copying a file
COPY config/ /site_config/


# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config


# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint and bashrc scripts so we have 
# our container's environment set up correctly
COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

RUN mkdir /root/inblue_ws
  
RUN mkdir /root/inblue_ws/src
#    && mkdir /root/inblue_ws/build
WORKDIR /root/inblue_ws

COPY /src /root/inblue_ws/src
#COPY /build /root/inblue_ws/build

# Set up entrypoint and default command
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]
RUN apt install --upgrade python3

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
 && apt-get update -y \
 && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y \
 && colcon build --symlink-install
RUN rm -rf /var/lib/apt/lists/*
