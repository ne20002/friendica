ARG VARIANT="8.2-apache-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/php:${VARIANT}

ARG DEBIAN_FRONTEND=noninteractive
ARG apcu_version=5.1.24
ARG memcached_version=3.3.0
ARG redis_version=6.1.0
ARG imagick_version=3.7.0

RUN apt-get update -y;

# Base packages
RUN apt install -y vim software-properties-common sudo nano gnupg2

# entrypoint.sh and cron.sh dependencies
RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                rsync \
                bzip2 \
                msmtp \
                tini \
        ;

ENV GOSU_VERSION 1.17
RUN set -eux; \
# save list of currently installed packages for later so we can clean up
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \
    if ! command -v gpg; then \
        apt-get install -y --no-install-recommends gnupg2 dirmngr; \
    elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
# "This package provides support for HKPS keyservers." (GnuPG 1.x only)
        apt-get install -y --no-install-recommends gnupg-curl; \
    fi; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
# clean up fetch dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu --version; \
    gosu nobody true

# install the PHP extensions we need
# see https://friendi.ca/resources/requirements/
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        mariadb-client \
        bash \
        libpng-dev \
        libjpeg62-turbo-dev \
        libtool \
        libmagick++-dev \
        libmemcached-dev \
        zlib1g-dev \
        libssl-dev \
        libgraphicsmagick1-dev \
        libfreetype6-dev \
        libwebp-dev \
        librsvg2-2 \
        libzip-dev \
        libldap2-dev \
        libgmp-dev \
        libmagickcore-6.q16-6-extra \
        ; \
        \
    docker-php-ext-configure gd \
            --with-freetype \
            --with-jpeg \
            --with-webp \
        ; \
    docker-php-ext-install -j "$(nproc)" \
            pdo_mysql \
            gd \
            exif \
            zip \
            opcache \
            ctype \
            pcntl \
            ldap \
            gmp \
            intl \
        ; \
        \
    # pecl will claim success even if one install fails, so we need to perform each install separately
        pecl install apcu-${apcu_version}; \
        pecl install memcached-${memcached_version}; \
        pecl install redis-${redis_version}; \
        pecl install imagick-${imagick_version}; \
        \
        docker-php-ext-enable \
            apcu \
            memcached \
            redis \
            imagick \
        ;



RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV PHP_MEMORY_LIMIT 512M
ENV PHP_UPLOAD_LIMIT 512M

RUN { \
        echo 'opcache.enable=1' ; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidte_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    { \
        echo 'memory_limit=${PHP_MEMORY_LIMIT}'; \
        echo 'upload_max_filesize=${PHP_UPLOAD_LIMIT}'; \
        echo 'post_max_size=${PHP_UPLOAD_LIMIT}'; \
    } > /usr/local/etc/php/conf.d/friendica.ini; \
    ln -s /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
    \
    mkdir /var/www/data; \
    chmod -R g=u /var/www
    
RUN set -ex;\
    a2enmod rewrite remoteip ;\
    {\
     echo RemoteIPHeader X-Real-IP ;\
     echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
     echo RemoteIPTrustedProxy 172.16.0.0/12 ;\
     echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
    } > /etc/apache2/conf-available/remoteip.conf;\
    a2enconf remoteip

ENV FRIENDICA_VERSION "2025.02-dev"
ENV FRIENDICA_ADDONS "2025.02-dev"

