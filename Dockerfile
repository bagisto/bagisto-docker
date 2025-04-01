# main image
FROM php:8.3-apache

# installing main dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg 

# installing unzip dependencies
RUN apt-get install -y \
    libzip-dev \
    zlib1g-dev \
    unzip

# gd extension configure and install
RUN apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libgmp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install gd

# imagick extension configure and install
RUN apt-get install -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# intl extension configure and install
RUN docker-php-ext-configure intl && docker-php-ext-install intl

# other extensions install
RUN docker-php-ext-install bcmath calendar exif gmp mysqli pdo pdo_mysql zip

# installing composer
COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer

# installing node js
COPY --from=node:23 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:23 /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# installing global node dependencies
RUN npm install -g npx

# arguments
ARG container_project_path
ARG uid
ARG user

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

# setting work directory
WORKDIR $container_project_path