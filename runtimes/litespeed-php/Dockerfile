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
# System Dependencies
# ---------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    gosu \
    imagemagick \
    libmagickwand-dev \
    libssl-dev \
    nano \
    pkg-config \
    procps \
    software-properties-common \
    sudo \
    supervisor \
    unzip \
    wget \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------------------------------------
# OpenLiteSpeed + lsphp83 (native LSAPI PHP)
# repo.litespeed.sh adds the LiteSpeed repo and runs its own apt-get update.
# ---------------------------------------------------------------------------------------
RUN wget -qO - https://repo.litespeed.sh | bash \
    && apt-get install -y \
    openlitespeed \
    lsphp83 \
    lsphp83-common \
    lsphp83-curl \
    lsphp83-imagick \
    lsphp83-intl \
    lsphp83-mysql \
    lsphp83-opcache \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/lsws/lsphp83/bin:$PATH

RUN ln -sf /usr/local/lsws/lsphp83/bin/php /usr/local/bin/php


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
# PHP Configuration (lsphp83 — LSAPI and CLI)
# ---------------------------------------------------------------------------------------
COPY ./configs/php/php.ini /usr/local/lsws/lsphp83/etc/php/8.3/litespeed/php.ini


# ---------------------------------------------------------------------------------------
# OpenLiteSpeed Configuration
# ---------------------------------------------------------------------------------------
COPY ./configs/openlitespeed/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
COPY ./configs/openlitespeed/vhosts/bagisto.conf /usr/local/lsws/conf/vhosts/bagisto.conf


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
    && chown -R www-data:www-data /usr/local/lsws/logs /usr/local/lsws/conf \
    && chmod -R 775 /var/www/html \
    && chmod g+s /var/www/html


# ---------------------------------------------------------------------------------------
# Sudo Setup For Project User
# ---------------------------------------------------------------------------------------
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


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
