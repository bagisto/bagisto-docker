# ---------------------------------------------------------------------------------------
# Main Image
# ---------------------------------------------------------------------------------------
FROM ubuntu:24.04


# ---------------------------------------------------------------------------------------
# ARGs
# ---------------------------------------------------------------------------------------
ARG container_project_path
ARG uid
ARG user


# ---------------------------------------------------------------------------------------
# ENVs
# ---------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC


# ---------------------------------------------------------------------------------------
# System Dependencies + PHP 8.3 (Available Natively In Ubuntu 24.04)
# ---------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    apache2 \
    apt-transport-https \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    gosu\
    imagemagick \
    libapache2-mod-php8.3 \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg-turbo8-dev \
    libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    nano \
    php8.3 \
    php8.3-bcmath \
    php8.3-calendar \
    php8.3-cli \
    php8.3-curl \
    php8.3-dev \
    php8.3-exif \
    php8.3-gd \
    php8.3-gmp \
    php8.3-intl \
    php8.3-mbstring \
    php8.3-mysql \
    php8.3-pdo \
    php8.3-soap \
    php8.3-sockets \
    php8.3-xml \
    php8.3-zip \
    php-imagick \
    procps \
    software-properties-common \
    supervisor \
    unzip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------------------
# Composer
# ---------------------------------------------------------------------------------------
COPY --from=composer:2.9 /usr/bin/composer /usr/local/bin/composer


# ---------------------------------------------------------------------------------------
# Node JS & Global NPM Dependencies
# ---------------------------------------------------------------------------------------
COPY --from=node:24 /usr/local/bin/node /usr/local/bin/node
COPY --from=node:24 /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && npm install -g laravel-echo-server opencode-ai


# ---------------------------------------------------------------------------------------
# PHP Configuration (native mod_php — Apache runs PHP in-process)
# ---------------------------------------------------------------------------------------
COPY ./configs/php/php.ini /etc/php/8.3/apache2/php.ini


# ---------------------------------------------------------------------------------------
# Apache Configuration
# ---------------------------------------------------------------------------------------
COPY ./configs/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite headers \
    && a2ensite 000-default


# ---------------------------------------------------------------------------------------
# Project User Setup
# ---------------------------------------------------------------------------------------
RUN useradd -G www-data,root -u $uid -d /home/$user $user \
    && mkdir -p /home/$user/.composer \
    && chown -R $user:$user /home/$user \
    && usermod -aG $user www-data


# ---------------------------------------------------------------------------------------
# Composer Cache — Accessible By Both Root And Project User
# ---------------------------------------------------------------------------------------
RUN mkdir -p /root/.composer \
    && mkdir -p /home/$user/.composer \
    && chmod -R 775 /root/.composer \
    && chown -R $user:$user /home/$user/.composer


# ---------------------------------------------------------------------------------------
# Runtime Directories (Created At Build Time So Permissions Are Correct)
# ---------------------------------------------------------------------------------------
RUN mkdir -p /var/www/html \
    && chown -R $user:$user /var/www/html \
    && chmod -R 775 /var/www/html \
    && chmod g+s /var/www/html


# ---------------------------------------------------------------------------------------
# Sudo Setup For Project User
# ---------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# ---------------------------------------------------------------------------------------
# Git Configuration
# ---------------------------------------------------------------------------------------
RUN git config --system --add safe.directory '*' \
    && git config --system core.fileMode false


# ---------------------------------------------------------------------------------------
# Working Directory
# ---------------------------------------------------------------------------------------
WORKDIR $container_project_path


# ---------------------------------------------------------------------------------------
# Entrypoint
# ---------------------------------------------------------------------------------------
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
