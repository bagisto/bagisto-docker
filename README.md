# Bagisto Dockerization

## Introduction

The primary purpose of this repository is to provide a workspace along with all the necessary dependencies for Bagisto. In this repository, we include the following services:

- PHP-Apache
- MySQL
- Redis
- PHPMyAdmin
- Elasticsearch
- Kibana
- Mailpit

## Supported Bagisto Version

Currently, all these services are included to fulfill the dependencies for the following Bagisto version:

**Bagisto Version:** v2.2.4 to v2.3.6

However, there may be some specific cases where adjustments are necessary. We recommend reviewing the `Dockerfile` or the `docker-compose.yml` file for any required modifications.

> [!IMPORTANT]
> The setup script in this repository is configured for **Bagisto dev-master**. The `.env` files located in the `.configs` folder are aligned with this version. If you plan to modify the script or change the Bagisto version, ensure that your adjustments maintain compatibility with the updated version.

## System Requirements

- System/Server requirements of Bagisto are mentioned [here](https://github.com/bagisto/bagisto#2-requirements-). Using Docker, these requirements will be fulfilled by docker images of apache & mysql, and our application will run in a multi-tier architecture.

- Install latest version of Docker and Docker Compose if it is not already installed. Docker supports Linux, MacOS and Windows Operating System. Click [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) to find their installation guide.

## Installation

- This is a straightforward repository with no complex configurations. Just update the `docker-compose.yml` file if needed, and you’re all set!

- Adjust your services as needed. For example, most Linux users have a UID of 1000. If your UID is different, make sure to update it according to your host machine.

  ```yml
  version: "3.1"

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
  ```

- In this repository, the initial focus was on meeting all project requirements. Whether your project is new or pre-existing, you can easily copy and paste it into the designated workspace directory. If you’re unsure where to begin, a shell script has been provided to streamline the setup process for you. To install and set up everything, simply run:

  ```sh
  sh setup.sh
  ```

## After installation

- To log in as admin.

  ```text
  http(s)://your_server_endpoint/admin/login

  Email: admin@example.com
  Password: admin123
  ```

- To log in as customer. You can directly register as customer and then login.

  ```text
  http(s):/your_server_endpoint/customer/register
  ```

## Already Docker Expert?

- You can use this repository as your workspace. To build your container, simply run the following command:

  ```sh
  docker-compose build
  ```

- After building, you can run the container with:

  ```sh
  docker-compose up -d
  ```

- Now, you can access the container's shell and install [Bagisto](https://github.com/bagisto/bagisto).

In case of any issues or queries, raise your ticket at [Webkul Support](https://webkul.uvdesk.com/en/customer/create-ticket/).
