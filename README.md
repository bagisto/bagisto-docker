# Bagisto Dockerization
---------------------


# Introduction



What is Bagisto
---------------
Bagisto is a hand tailored E-Commerce framework designed on some of the hottest opensource technologies such as Laravel a PHP framework, Vue.js a progressive Javascript framework.

Bagisto is viable attempt to cut down your time, cost and workforce for building online stores or migrating from physical stores to the ever demanding online world. Your business whether small or huge it suits all and very simple to set it up.


What is Docker
--------------
Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. Docker can also be used for defining and running multi-container Docker applications using Docker-Compose tool.

With the help of docker-compose, one can define containers to be built, their configuration, links, volumes, ports etc in a single file and it gets launched by a single command. One can add multiple servers and services just by adding them to docker-compose configuration file. This configuration file is in YAML format.


System Requirements
-------------------

System/Server requirements of bagisto are mentioned [here](https://github.com/bagisto/bagisto#2-requirements-). Using Docker, these requirements will be fulfilled by docker images of apache & mysql, and our application will run in a multi-tier architecture.

1). Docker and Docker Compose
-----------------------------

Install latest version of Docker and Docker Compose if it is not already installed. Docker supports Linux, MacOS and Windows Operating System. Click [Docker](https://docs.docker.com/install/) and [Docker Compose] (https://docs.docker.com/compose/install/) to find their installation guide.


2). Composer Tool (Optional)
-----------------

Install latest version of composer using following command:-

> `curl -s https://getcomposer.org/installer | php;` 
> `cp composer.phar /usr/bin/composer;` 
> `chmod +x /usr/bin/composer`


Application Data and Database Volume Persistance
-------------------------------------------------

To ensure application and database data persistance even in the case of containers' failure or termination, it is recommended to keep application files and database data volume on the docker host and mount them on the running container. In this way even if you destroy containers, your data won't get lost unless you remove them forcefully.
This compose configuration file mounts application directory `app` and database volume `dbvolume` from host to running docker containers at the time of containers launch.


Bagisto Installation using Docker-compose tool
----------------------------------------------

To get started with Docker-Compose, ensure you have docker and docker-compose already installed. 

1). Clone this project as `git clone https://wkrepo.webkul.com/laravel/bagisto-docker-compose.git` or create a docker-compose.yml file in a directory.


```yml

version: '3'

services:

  web_server:
    image: webkul/apache-php:latest
    container_name: apache2
    restart: always
    volumes:
      - ./app:/var/www/html
    working_dir: /var/www/html/
    environment:
      USER_UID: 'mention your system user ID here. ex: 1001, 1000, 33, etc'
    networks:
      - bagisto-network
    ports:
      - '80:80'
    expose:
      - '80'
    depends_on:
      - database_server
    links:
      - database_server

  database_server:
    image: mysql:5.7
    container_name: mysql
    restart: always
    environment:
      MYSQL_DATABASE: 'mention the name of the database to be created here. eg: mydatabase'
      MYSQL_USER: 'mention database user here. eg: mydatabase_user'
      MYSQL_PASSWORD: 'mention database user password here. ex: mystrongPassword'
      MYSQL_ROOT_PASSWORD: 'mention mysql root password here. ex: mysqlstrongpass'
      MYSQL_ROOT_HOST: '%'
    networks:
      - bagisto-network
    ports:
      - '3306:3306'
    expose:
      - '3306'
    volumes:
      - ./dbvolume:/var/lib/mysql

volumes:
  dbvolume:
  app:

networks:
  bagisto-network:

```


2). Above mentioned yml configuration file requires following inputs from the user:


> In web_server Service block, assign your system working user uid to the `USER_UID` enviroment variable. To get your user id run command `id -u` on linux or macos.

> In database_server Service block, assign mysql database name, mysql database user name, mysql database user password and mysql root password to `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` and `MYSQL_ROOT_PASSWORD` environment respectively.


3). Once docker-compose.yml file is ready, go to a directory having docker-compose.yml file and pull the updated docker images as:


> `docker-compose pull`
 

Above command will download docker images for apache-php version 7.2 and mysql version 5.7.

4). Launch docker containers from docker-compose.yml configuration file as:


> `docker-compose up -d`


(a). Above command will create a network and launch webserver and database containers with names `apache2` and `mysql` respectively. 

(b). It will also create `app` and `dbvolume` directory on host and mount it to respective docker containers as mentioned in docker-compose.yml.

(c). It binds your `host port 80` with the apache2 container port 80 and `host port 3306` with mysql container port 3306. If you want to run containers on ports other than 80 and 3306, modify their values in docker-compose.yml file. 

Check running docker containers as:


> `docker ps` OR `docker-compose ps`


5). Now, as our environment is ready for bagisto Installation. You can either install bagisto via GUI or via composer

(a). For installation via graphical user interface, clone the [bagisto](https://github.com/bagisto/bagisto) in app/public_html directory and mention your system or system IP on browser and begin with installaton process. Mention the database details same as docker-compose.yml and admin details.


> `git clone https://github.com/bagisto/bagisto app/public_html`


`IMPORTANT ->> Please use database container name 'mysql' as the database host while filling out the database credentials`.


(b). For installation via composer, commands will be needed to be exexcuted within docker container.


> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'composer create-project bagisto/bagisto'"`

> Find file .env inside `app/bagisto` directory and set the environment variables listed below:

```

APP_URL=
DB_CONNECTION=
DB_HOST=mysql
DB_PORT=
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=


```

> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'php bagisto/artisan migrate'"`


> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'php bagisto/artisan db:seed'"`


> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'php bagisto/artisan vendor:publish'"`


> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'php bagisto/artisan storage:link'"`


> `docker exec -i apache2 bash -c "su - www-data -s /bin/bash -c 'composer dump-autoload -d bagisto'"`


> Apache documentroot is `/var/www/html/public_html`. As `app` directory on host is mapped with `html` directory inside container, we will create a symlink of `bagisto/public` in `app` directory to `/var/www/html/public_html`.

> `cd app; ln -snf bagisto/public public_html`



6). Bagisto has been installed and is ready to be explored. Browse your server IP address or domain name on the web browser.


To log in as admin:
------------------
```
http(s)://your_server_endpoint/admin/login

email: admin@example.com
password: admin123
```

To log in as customer:
----------------------

You can directly register as customer and then login.

```
http(s):/your_server_endpoint/customer/register
```





In case of any issues or queries, raise your ticket at [Webkul Support.](https://webkul.uvdesk.com/en/customer/create-ticket/)
--------------------------------------------------------------------------------------------
