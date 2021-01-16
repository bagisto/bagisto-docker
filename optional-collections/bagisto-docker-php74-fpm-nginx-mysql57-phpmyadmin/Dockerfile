# main image
FROM php:7.4-fpm

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
RUN groupadd -g $uid www
RUN useradd -u $uid -ms /bin/bash -g www www

# copy existing application directory contents
COPY $host_project_path $container_project_path

# copy existing application directory permissions
COPY --chown=www:www $host_project_path $container_project_path

# change current user to www
USER www

# expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]