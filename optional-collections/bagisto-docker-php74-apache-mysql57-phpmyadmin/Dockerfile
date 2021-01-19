# main image
FROM php:7.4.13-apache

# installing necessary dependencies
RUN apt-get update && apt-get install -y git libicu-dev libpng-dev libzip-dev unzip zlib1g-dev
RUN docker-php-ext-configure intl && docker-php-ext-install bcmath gd intl mysqli pdo pdo_mysql zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# arguments
ARG container_project_path
ARG host_project_path
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
COPY $host_project_path $container_project_path
RUN chmod -R 775 $container_project_path
RUN chown -R $user:www-data $container_project_path

# changing user
USER $user
