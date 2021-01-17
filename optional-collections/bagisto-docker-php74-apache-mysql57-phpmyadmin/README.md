# Bagisto Docker - PHP 7.4, Apache, MySQL 5.7 & PHPMyAdmin

Set of all development-related tools needed for Bagisto.

## Information

After installation below are the ports for the usage of the container,

### Apache

We have bound all default ports for ease. Please take a note if apache is running on the host machine then either you should stop apache in the host machine or change the port in `docker-compose. yml`file.

### MySQL

MySql is also bound on the same port. Please take a note if MySQL is running on the host machine then either you should stop MySQL in the host machine or change the port in the `docker-compose.yml` file.

### PHPMyAdmin

It is bounded on port number 3333. For accessing PHPMyAdmin in the browser, you need to hit the `localhost:3333`.

## Installation

Road to setup Bagisto via. docker,

1. Via shell script
2. Manual process

### 1. Via shell script

You just need to copy one of the folders of your choice or flavor. Inside that folder, you need to run only one command i.e.,

  ~~~sh
  sh execute.sh
  ~~~

Done! No need to do anything.

It will ask you only one question, whether you want us to install everything for you or you want to install it on your own from Bagisto's GUI.

If you select yes, then everything will set up for you and if you select no, then we assume that you are familiar with docker and you can set up your project manually by Bagisto's GUI or by entering the command line of the container.

### 2. Manual process

Sometimes shell scripts won't work so, you can do it manually also. If you check the shell scripts, we have provided a list of several tasks that you take as a reference also. Let's get started,

- Step 1: The first step is to have a project which you want in the docker container. So, you need to put all the project-related files in folder names as `bagisto`. Please take a note, if you renamed your folder name then please renamed the path in `docker-compose.yml` file. So, I am cloning via git you can download and extract zip also.

  ~~~sh
  git clone https://github.com/bagisto/bagisto bagisto
  ~~~

- Step 2: After setting up the project, now the docker comes into the game. Now, we need to build the container via. `docker-compose.yml`. Just run the below command,

  ~~~sh
  docker-compose build && docker-compose up -d
  ~~~

This command will build all your containers and run all your containers in detach mode i.e. in the background.

- Step 3: Now, your container is running. You need the container id to enters inside the container to execute the further steps. We are doing it from the outside, if you need to go inside the container then use the `-it` command. For e.g. `docker exec -it <container-id> bash`. Now, run the below command to get the container id,

  ~~~sh
  docker ps -aqf "name=bagisto-php-apache"
  ~~~

This command will give some random string which you needed for executing the command inside the container. For e,g, you get some string like `some-random-string-123`.

- Step 4: Now, run the below command to execute the `composer install` command inside a docker container,

  ~~~sh
  docker exec some-random-string-123 composer install
  ~~~

- Step 5: Now check the `localhost` in the browser. Please take a note, we have bound all default ports in `docker-compose.yml`. If you have bind some other port then please use that port like `localhost:8080`, `localhost:9999`, etc.
