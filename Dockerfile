# main image
FROM node:latest AS node
FROM php:8.1-apache

# installing php necessary dependencies
RUN apt-get update && apt-get install -y git

RUN apt-get install -y libzip-dev unzip

RUN apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    zlib1g-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

RUN docker-php-ext-configure intl

RUN docker-php-ext-install bcmath exif gd intl mysqli pdo pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# setting node js
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# arguments
ARG container_project_path
ARG uid
ARG user

# set working directory
WORKDIR $container_project_path

# adding user
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# setting apache
COPY ./.configs/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# setting up project from `src` folder
RUN chmod -R 775 $container_project_path
RUN chown -R $user:www-data $container_project_path

# changing user
USER $user
