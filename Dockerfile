FROM ubuntu:focal
LABEL maintainer="Prof. Rob Marano <rob@cooper.edu>"
ENV DEBIAN_FRONTEND=noninteractive
# add our course's global bashrc file
ADD --chown=root:root ./etc/bash.bashrc /etc/bash.bashrc
ADD --chown=root:root ./etc/motd /etc/motd
ADD --chown=root:root ./etc/issue /etc/issue
# update your instance of Ubuntu server
RUN apt update && apt upgrade -y
# install essential C development tools
RUN apt install -y --force-yes build-essential manpages-dev sudo curl git-core vim wget
# allow devuser to have superuser/root privileges
RUN apt install -y --force-yes sudo
ADD --chown=root:root ./etc/sudoers /etc/sudoers
# install some neat Linux tools
RUN apt install -y fortune cowsay
# create a local user called "devuser" for local development
RUN adduser \
        --quiet \
        --disabled-password \
        --shell /bin/bash \
        --home /home/devuser \
        --gecos "User" devuser
# configure your local "devuser"
RUN echo "devuser:Cooper1859!" | chpasswd
RUN usermod -aG sudo devuser
# create your C development directory called /home/devuser/dev/c
USER devuser
RUN mkdir -p /home/devuser/dev/c
ADD --chown=devuser:devuser ./README.md /home/devuser/CS-102-README.md
WORKDIR /home/devuser
# configure YOUR GitHub credentials
ADD --chown=devuser:devuser ./etc/.gitconfig /home/devuser/.gitconfig
#ADD ~/dev/cooper /home
#CMD ["bash"]
ADD --chown=devuser:devuser . /home/devuser/dev/docker
SHELL ["/bin/bash", "-c"]