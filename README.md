# Bagisto Dockerization

The primary purpose of this repository is to provide a workspace along with all the necessary dependencies for Bagisto. In this repository, we include the following services:

| Service | Description | Port |
|---------|-------------|------|
| Nginx (+ PHP-FPM)       | Web server runtime           | `80` |
| OpenLiteSpeed (+ lsphp) | Web server runtime           | `80` |
| Apache (mod_php)        | Web server runtime           | `80` |
| MySQL                   | Database                     | `3306` |
| PHPMyAdmin              | Database admin UI            | `3030` |
| Mailpit                 | Mail catcher (SMTP + web UI) | `1025` / `8025` |

The three web server runtimes are interchangeable — you run **one** at a time (see below).

Optional services (Redis, PostgreSQL/pgAdmin, RabbitMQ, Elasticsearch, Kibana) are included in the compose files but commented out — uncomment the ones you need.

## Three web server runtimes

This repository ships **three interchangeable web server runtimes** that serve the **same** Bagisto workspace. You pick **one** to run — each has its own compose file and serves on port `80`:

| Runtime | Service | Web server | Compose file |
|---------|---------|------------|--------------|
| Nginx         | `nginx-php`     | Nginx + PHP-FPM        | `docker-compose.nginx-php.yml` |
| OpenLiteSpeed | `litespeed-php` | OpenLiteSpeed + lsphp  | `docker-compose.litespeed-php.yml` |
| Apache        | `apache-php`    | Apache + mod_php       | `docker-compose.apache-php.yml` |

All serve the document root `/var/www/html/bagisto/public`. Each runtime is self-contained under `runtimes/<name>/` with its own `Dockerfile` and `configs/`.

## Supported Bagisto Version

Currently, all these services are included to fulfill the dependencies for the following Bagisto version:

**Bagisto Version:** v2.4.0 and up.

However, there may be some specific cases where adjustments are necessary. We recommend reviewing the `runtimes/<name>/Dockerfile` or the relevant `docker-compose.<runtime>.yml` file for any required modifications.

## Project Structure

```text
runtimes/
  nginx-php/
    Dockerfile
    configs/
      nginx/       # nginx.conf (vhost), pools/www.cnf (php-fpm pool)
      php/         # php.ini
      supervisor/  # php-fpm + nginx process control
  litespeed-php/
    Dockerfile
    configs/
      openlitespeed/   # httpd_config.conf + vhosts/bagisto.conf
      php/             # php.ini
      supervisor/      # lsphp + openlitespeed process control
  apache-php/
    Dockerfile
    configs/
      apache/      # 000-default.conf (vhost)
      php/         # php.ini (apache2 SAPI)
      supervisor/  # apache (mod_php) process control
.runtimes-data/    # persistent service data (mysql-data, ...) — gitignored
workspace/         # your Bagisto application lives here (mounted to /var/www/html)
docker-compose.nginx-php.yml
docker-compose.litespeed-php.yml
docker-compose.apache-php.yml
setup.sh
```

The web server configs are bind-mounted, so you can edit them on the host and apply with a container restart (e.g. `docker compose -f docker-compose.nginx-php.yml restart nginx-php`).

## System Requirements

- System/Server requirements of Bagisto are mentioned [here](https://devdocs.bagisto.com/getting-started/before-you-start.html#system-requirements). Using Docker, these requirements will be fulfilled by the docker images of the runtimes, and our application will run in a multi-tier architecture.

- Install the latest version of Docker and Docker Compose if not already installed. Docker supports Linux, MacOS and Windows. See [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) for installation guides.

## Installation

- Adjust your services as needed in the runtime's compose file. For example, most Linux users have a UID of 1000 — if your UID is different, update the `uid` build arg accordingly.

  ```yml
  services:
    nginx-php:
      build:
        args:
          container_project_path: /var/www/html/
          uid: 1000 # add your uid here
          user: $USER
        context: ./runtimes/nginx-php
        dockerfile: Dockerfile
      image: nginx-php
      ports:
        - "80:80"     # web server
        - "5173:5173" # Vite dev server
      volumes:
        - ./workspace/:/var/www/html/
  ```

- A shell script is provided to streamline the setup. It **asks which runtime you want** (`nginx-php`, `litespeed-php`, or `apache-php`), then builds the image, starts the services, creates the databases, installs Bagisto into the `workspace/` directory, and seeds demo products. To install and set up everything, simply run:

  ```sh
  sh setup.sh
  ```

## After installation

- Whichever runtime you chose, the site is served on `http://localhost` (port 80).

- To log in as admin.

  ```text
  http(s)://your_server_endpoint/admin/login

  Email: admin@example.com
  Password: admin123
  ```

- To log in as customer. You can directly register as a customer and then login.

  ```text
  http(s)://your_server_endpoint/customer/register
  ```

## Already Docker Expert?

- Pick a runtime's compose file and build it (use `docker compose` or `docker-compose`, whichever you have):

  ```sh
  docker compose -f docker-compose.nginx-php.yml build       # or docker-compose.litespeed-php.yml / docker-compose.apache-php.yml
  ```

- After building, run the containers with:

  ```sh
  docker compose -f docker-compose.nginx-php.yml up -d
  ```

- Now, you can access a container's shell and install [Bagisto](https://github.com/bagisto/bagisto) into the `workspace/` directory.

In case of any issues or queries, raise your ticket at [Webkul Support](https://webkul.uvdesk.com/en/customer/create-ticket/).
