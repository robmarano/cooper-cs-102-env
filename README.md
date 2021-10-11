# CS 102 C - Course Notes
Fall 2021
The Cooper Union
Prof Rob Marano

## Getting Started with your Virtual Machine (VM)

We will be using Ubuntu Server 20.04.3 for our class this semester, working on a single type of development environment for C and for Python 3. The following instructions are for those whose computers are running an operating system (OS) specifically Windows or Mac. If you are on Linux already, you're set; you will have to install specific C and Python packages throughout the semester.

### Creating your environment to code on your computer (Windows, Mac, Linux)

Note: Since Apple introduced their M1 ARM-based CPU, the usual use of VirtualBox will no longer work. We will use Docker containers instead.

#### Installing Microsoft Visual Studio Code (VS Code): your editor and workspace using Docker

Go to the main page for [Microsoft Visual Studio Code](https://code.visualstudio.com/) and download the application for your type of OS: Windows or Mac.

Also, since we will be using Docker to create the Linux container within which we will develop C and Python software for this course, it will be very helpful for you to add the Docker extension to VS Code.

**AFTER** you install the Docker Desktop on your computer (see below), follow the instructions on this page [Working with Container](https://code.visualstudio.com/docs/containers/overview). You can install the Docker extension directly within the VS Code application once you start it up by opening it.

#### Download Docker Desktop

Go to [Getting Started with Docker](https://www.docker.com/get-started) and choose your computer type under Docker Desktop. See here for [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac) and here for [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows) Once downloaded, install the software. You may have to update your computer BIOS on non-Apple computers to enable CPU virtualization. This may help for [BIOS setting of virtualization](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html) for non-Apple computers.

Once installed, move on to next section.

#### Download Git

Follow [these instructions](https://www.atlassian.com/git/tutorials/install-git) on installing Git on your computer -- Windows or Mac.

#### Learning How to Use Git (with GitHub as its server)

Follow [these instructions on GitHub](https://docs.github.com/en/get-started/getting-started-with-git) to learn the basics of Git with GitHub.

#### Configure and Build Your Docker Container 

After installing Docker Hub and Git on your computers, follow the instructions:
1. Open a terminal on your computer, ```cmd.exe``` on Windows or ```Terminal.app``` or ```iTerm2.app``` on Mac
2. Change directory to either ```My Documents``` on Windows or your ```${HOME}``` directory on Mac OS. Then create a directory called ```dev``` where we will create sub-directories for projects and code respositories.
    1. If you are on Mac, run command:
    ```bash
    cd ${HOME}
    mkdir dev
    cd dev
    ```
    2. If you are on Windows, replace %HOMEDRIVE% and %HOMEPATH% with your Windows home directory run command:
    ```bash
    cd %HOMEPATH%
    mkdir dev
    cd dev
    ```
3. Then clone the repo to your computer using the command
```bash
git clone https://github.com/robmarano/cooper-cs-102-env.git
```
4. Change directory into ```./cooper-cs-102-env```
5. Update your full name and email address in the file ```etc/.gitconfig```
6. Build the Docker image with the command. See Docker [build manual](https://docs.docker.com/engine/reference/commandline/build/) to decode what the command above does.
```bash
docker build --rm -f Dockerfile -t ubuntu:cs102-student .
```
7. Run your new Docker image in a container and place in background
    Choose from either option below based upon your OS. See Docker [run manual](https://docs.docker.com/engine/reference/run/) to decode what the command above does.
    1. If you are on Mac, run command:
    ```bash
    docker run --rm -dit -P --name cs102-student -v ~/:/home/devuser/myHome ubuntu:cs102-student
    ```
    2. If you are on Windows, replace %HOMEDRIVE% and %HOMEPATH% with your Windows home directory run command:
    ```bash
    docker run --rm -dit -P --name cs102-student --security-opt seccomp=unconfined --mount type=bind,source="%HOMEDRIVE%%HOMEPATH%\Documents",destination=/home/devuser/myHome ubuntu:cs102-student
    ```
8. Find the Docker container ID using the command ```docker ps```
9. Login to your new Docker container to being coding ```docker exec -i -t {CONTAINER ID} /bin/bash```
10. Create your ssh keys for GitHub usage.
    1. Follow the instructions to create SSH keys in your Linux container [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
    2. Follow the instructions to add the keys to your GitHub account [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
11. Save your keys to your host computer from your Linux container
```bash
cd ~ && cp -r ./.ssh ~/myHome/ssh && ~/myHome/dev/cooper-cs-102-env/ssh
```
12. Exit your Linux container
13. Kill your container
14. Remove the cs102-student image
15. Then rebuild the image, now with the proper ssh keys and .gitconfig
16. Run your container like in Step 7
17. Enter your container like in Step 9
18. You're ready!

## Getting Started with Some Key Tools After Installation

### Git -- Source Code Collaboration

We will use Git via GitHub to manage our software (code) repositories (repos). Please create an account on [GitHub.com](https://www.github.com) and share your account details with [Prof. Marano via email](mailto:rob@cooper.edu). You will find his GitHub profile [here](https://github.com/robmarano).

#### Some good links
* [Learn Vim For the Last Time: A Tutorial and Primer](https://danielmiessler.com/study/vim/)
* [Docker Basics](https://docker-curriculum.com/)
* [6 Docker Basics You Should Completely Grasp When Getting Started](https://vsupalov.com/6-docker-basics/)
* [Towards Data Science - Git: The Complete Beginner's Guide](https://codewords.recurse.com/issues/two/git-from-the-inside-out)
* [Rob Reiter's Learn-C.org](https://www.learn-c.org/)

## To remove the Docker container and image
### Stop the container
```bash
docker ps
```
Copy the ```CONTAINER_ID```
```bash
docker container kill CONTAINER_ID
```
### Delete the container
```bash
docker container rm CONTAINER_ID
```
### Delete the image
```bash
docker image ls
```
Take the ```IMAGE_ID``` of the image for cs102-student
```bash
docker image rm IMAGE_ID
```

To recreate and run a new container, start from the top of this page.
