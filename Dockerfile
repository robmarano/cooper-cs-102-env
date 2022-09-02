#
# Dockerfile for cs102
#
# Build command:
# docker build --rm -f Dockerfile -t ubuntu:cs102 .
# Exec command:
# docker run --rm -dit -P --name cs102 --cap-add=CAP_SYS_PTRACE --security-opt seccomp=unconfined \
#   --privileged -v ~/:/home/cs102/myHome -v ~/dev/cooper/cs102:/home/cs102/dev -v ~/.m2:/home/cs102/.m2 -t ubuntu:cs102
#
FROM ubuntu:focal
LABEL maintainer="Prof. Rob Marano <rob@cooper.edu>"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN yes | unminimize
# add our course's global bashrc file
ADD --chown=root:root ./etc/bash.bashrc /etc/bash.bashrc
ADD --chown=root:root ./etc/motd /etc/motd
ADD --chown=root:root ./etc/issue /etc/issue
# update your instance of Ubuntu server
RUN apt update && apt upgrade -y
# install essential C development tools
RUN apt install -y --force-yes build-essential gdb manpages-dev man-db sudo curl git-core vim wget
# install terminal multiplexer to have multiple terminals in one session
# https://tmuxcheatsheet.com/
RUN apt install -y tmux
# install ncurses for development
RUN apt install -y libncurses-dev
# allow cs102 to have superuser/root privileges
RUN apt install -y --force-yes sudo
ADD --chown=root:root ./etc/sudoers /etc/sudoers
# install some neat Linux tools
RUN apt install -y fortune cowsay
# create a local user called "cs102" for local development
RUN adduser \
        --quiet \
        --disabled-password \
        --shell /bin/bash \
        --home /home/cs102 \
        --gecos "User" cs102
# configure your local "cs102"
RUN echo "cs102:Cooper1859!" | chpasswd
RUN usermod -aG sudo cs102
#  Add new user docker to sudo group
RUN adduser cs102 sudo
# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# create your C development directory called /home/cs102/dev/c
USER cs102
WORKDIR /home/cs102
ADD --chown=cs102:cs102 ./etc/vimrc /home/cs102/.vimrc
ADD --chown=cs102:cs102 ./README.md /home/cs102/CS-102-README.md
# configure YOUR GitHub credentials
ADD --chown=cs102:cs102 ./etc/.gitconfig /home/cs102/.gitconfig
# add the pre-existing SSH files for your access to your GitHub account
# ensure you have in your host computer under C:\Users\YOURNAME\Documents\ssh in Windows or /Users/YOURNAME/ssh
RUN mkdir -p /home/cs102/.ssh
ADD --chown=cs102:cs102 ./ssh/id_ed25519 /home/cs102/.ssh/id_ed25519
ADD --chown=cs102:cs102 ./ssh/id_ed25519.pub /home/cs102/.ssh/id_ed25519.pub
RUN chmod 400 /home/cs102/.ssh/id_ed25519
RUN chmod 400 /home/cs102/.ssh/id_ed25519.pub
SHELL ["/bin/bash", "-c"]
