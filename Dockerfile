FROM ros:indigo
MAINTAINER Eric Dortmans (eric.dortmans AT gmail.com)

# Arguments
ARG user
ARG uid
ARG home
ARG workdir
ARG shell

# prevent "debconf: unable to initialize frontend: Dialog"
ENV DEBIAN_FRONTEND noninteractive

# install support packages
RUN apt-get update && apt-get install -y \
    screen tree sudo ssh synaptic \
    build-essential wget curl git \
    libncurses5-dev qtdeclarative5-dev \
    libeigen3-dev \
    python-rosinstall \
    python-pip && \
    rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/include/eigen3/Eigen /usr/include/Eigen
RUN pip install catkin_tools

# install ROS-desktop and remove Gazebo 2
RUN apt-get update && apt-get install -y ros-indigo-desktop-full && \
    apt-get remove -y gazebo2 && \
    rm -rf /var/lib/apt/lists/*

# install Gazebo 7
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list
RUN wget --quiet http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
    gazebo7 libgazebo7-dev ros-indigo-gazebo7-ros-pkgs ros-indigo-gazebo7-ros-control && \
    wget --quiet https://raw.githubusercontent.com/osrf/osrf-rosdep/master/gazebo7/00-gazebo7.list -O /etc/ros/rosdep/sources.list.d/00-gazebo7.list && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# setup simatch workspace
RUN /bin/bash -c "source /opt/ros/indigo/setup.bash && \
    cd / && \
    git clone https://github.com/nubot-nudt/simatch.git && \
    cd simatch && \
    chmod +x configure && \
    ./configure && \
    catkin_make"
COPY ./simatch_entrypoint.sh /
ENTRYPOINT ["/simatch_entrypoint.sh"]

# Clone user into docker image 
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

# Intel GPU support
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils && \
    rm -rf /var/lib/apt/lists/*
# add user to video group
#RUN usermod -a -G video ${user}
RUN gpasswd -a ${user} video

# Nvidia GPU support
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

# prevent "ignoring C.UTF-8: not a valid language tag"
ENV LC_ALL=C

# mount the user's home directory
VOLUME "${home}"

USER "${user}"
WORKDIR ${workdir}

# make SSH available
EXPOSE 22

