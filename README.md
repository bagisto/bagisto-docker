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

Just one command and everything setup for you,

~~~sh
sh init.sh
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
