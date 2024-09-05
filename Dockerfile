FROM ros:humble-ros-core

#Initial Setup
RUN apt-get update \
    && apt-get -y update
RUN apt install ros-dev-tools -y 

WORKDIR /Robot

#Copying All Dependencies
COPY src . 
COPY build .

#Ros Pkg initialization 
RUN colcon build 
RUN . install/setup.bash

