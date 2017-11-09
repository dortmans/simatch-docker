# simatch-docker

This repository contains a Dockerfile and support scripts for building and running the Simatch MSL robot soccer simulator using Docker.

The Simatch sources and documentation can be found here: https://github.com/nubot-nudt/simatch

# Installation

If you have not done so before, install Docker Community Edition. For alternative ways to install Docker CE on Ubuntu see: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

One way of installing is using the get-docker convenience script as follows:
```
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Adding user to "docker" group allows you to use docker commands without sudo:
```
sudo usermod -aG docker ${USER}
```

Now download the simatch-docker workspace from GitHub:
```
cd ~
git clone https://github.com/dortmans/simatch-docker.git
```

Finally build the simatch docker image:
```
cd ~/simatch-docker
./build.sh simatch
```

If the building completes you are ready to run Simatch using Docker.

# Usage

To run the Simatch MSL soccer game simulator open a terminal window and enter following commands:
```
cd ~/simatch-docker
./run.sh simatch roslaunch nubot_gazebo game_ready.launch
```

If you also want to run nubot robot code for cyan robots then open a new terminal window and enter:
```
cd ~/simatch-docker
./run.sh simatch rosrun nubot_common cyan_robot.sh
```

Replace cyan by magenta in above command if you want to control magenta robots with nubot code.

You can start the coach software for the cyan team in another terminal window as follows:
```
cd ~/simatch-docker
./run.sh simatch rosrun coach4sim cyan_coach.sh
```

Likewise for the magenta team replace cyan by magenta.

If you want to start all of the above on one computer:
```
cd ~/simatch-docker
./run.sh simatch roslaunch simatch_cyan.launch
```

Again replace cyan by magenta if you like.

