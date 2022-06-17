# Bagisto Dockerization

## Introduction

### What is Bagisto?

Bagisto is a hand tailored E-Commerce framework designed on some of the hottest opensource technologies such as Laravel a PHP framework, Vue.js a progressive Javascript framework.

Bagisto is viable attempt to cut down your time, cost and workforce for building online stores or migrating from physical stores to the ever demanding online world. Your business whether small or huge it suits all and very simple to set it up.

### What is Docker?

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. Docker can also be used for defining and running multi-container Docker applications using Docker-Compose tool.

With the help of docker-compose, one can define containers to be built, their configuration, links, volumes, ports etc in a single file and it gets launched by a single command. One can add multiple servers and services just by adding them to docker-compose configuration file. This configuration file is in YAML format.

## System Requirements

- System/Server requirements of Bagisto are mentioned [here](https://github.com/bagisto/bagisto#2-requirements-). Using Docker, these requirements will be fulfilled by docker images of apache & mysql, and our application will run in a multi-tier architecture.

- Install latest version of Docker and Docker Compose if it is not already installed. Docker supports Linux, MacOS and Windows Operating System. Click [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) to find their installation guide.

## Installation

- Adjust your Apache, MySQL and PHPMyAdmin port.

  ~~~yml
  version: '3.1'

  services:
      bagisto-php-apache:
          build:
              args:
                  container_project_path: /var/www/html/
                  uid: 1000 # add your uid here
                  user: $USER
              context: .
              dockerfile: ./Dockerfile
          image: bagisto-php-apache
          ports:
              - 80:80 # adjust your port here, if you want to change
          volumes:
              - ./workspace/:/var/www/html/

      bagisto-mysql:
          image: mysql:8.0
          command: --default-authentication-plugin=mysql_native_password
          restart: always
          environment:
              MYSQL_ROOT_HOST: '%'
              MYSQL_ROOT_PASSWORD: root
          ports:
              - 3306:3306 # adjust your port here, if you want to change
          volumes:
              - ./.configs/mysql-data:/var/lib/mysql/

      bagisto-phpmyadmin:
          image: phpmyadmin:latest
          restart: always
          environment:
              PMA_HOST: bagisto-mysql
              PMA_USER: root
              PMA_PASSWORD: root
          ports:
              - 8080:80 # adjust your port here, if you want to change

  volumes:
      mysql-data:
  ~~~

- Run the below command and everything setup for you,

  ~~~sh
  sh setup.sh
  ~~~

## After installation

- To log in as admin.

  ~~~text
  http(s)://your_server_endpoint/admin/login

  Email: admin@example.com
  Password: admin123
  ~~~

- To log in as customer. You can directly register as customer and then login.

  ~~~text
  http(s):/your_server_endpoint/customer/register
  ~~~

In case of any issues or queries, raise your ticket at [Webkul Support](https://webkul.uvdesk.com/en/customer/create-ticket/).
