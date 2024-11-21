# Docker Template

## Installation
Before installing the framework, you should make yourself familiar with ROS and how it works. A good starting point is the [official ROS tutorials](http://wiki.ros.org/ROS/Tutorials).

### Using the docker Image
###  Prerequisites
#### Install Instructions

#### Steps

1. Install Docker using the [official install instructions](https://docs.docker.com/install/)   _Note: The install instructions list Ubuntu in the server section!_
2. Allow Docker execution as a non-root user; follow [these instructions](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)   _Note: Only do the first section "Manage Docker as a non-root user"_
3. Test your Docker installation with the following command   _Note: You might want to restart your computer at this point._

   ```sh
   docker run hello-world
   ```
4. Clone the git repository.
   ```sh
   git clone --recursive git@github.com:renezurbruegg/DockerTemplate.git
   cd DockerTemplate
   ```
5. Navigate to the Ubuntu setup folder

   ```sh
   cd .setup/ubuntu # for Ubuntu
   cd .setup/macos # for Mac
   ```
6. Execute the setup script

   ```sh
   ./setup.sh
   ```

**Note:** After the setup script has finished, you should log out of your terminal and open a new one. This step ensures the terminal environment is reloaded with all the changes.

#### Next

1. In the main folder, make sure that the installation was successful by running

   ```sh
   mydocker --help
   ```
2. Build the docker image by running

   ```sh
   mydocker up
   ```
3. Start the docker container by running

   ```sh
   mydocker run
   ```
4. If you want to attack another terminal to the running container, you can do so by running

   ```sh
   mydocker attach
   ```


## Usage

## Contributing ##
Please install [pre-commit](https://pre-commit.com/) to lint and statically check your code before committing. To install pre-commit, run the following command:
```
pip install pre-commit
```
Then, run the following command to install the pre-commit hooks:
```
pre-commit install
```