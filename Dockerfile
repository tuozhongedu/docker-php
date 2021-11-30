FROM php:7.2.34-cli-alpine3.12
MAINTAINER Peijun Cong <congpeijun@tuozhongedu.com>

ENV PHP_SSH2_VERSION ssh2-1.1.2

ENV PHPIZE_DEPS \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        libssh2-dev

RUN set -xe \
    && apk add --update \
        unzip git rsync \
        ca-certificates openssl openssh-client libssh2 \
    && apk add --virtual .build-deps $PHPIZE_DEPS \
    && echo -e "date.timezone=Asia/Shanghai" > /usr/local/etc/php/conf.d/date_timezone.ini \
    && echo -e "opcache.enable_cli=on" > /usr/local/etc/php/conf.d/php.ini \
    && pecl install ${PHP_SSH2_VERSION} && docker-php-ext-enable ssh2 \
    && docker-php-ext-enable opcache \
    && wget "https://getcomposer.org/download/1.10.23/composer.phar" -O /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \
    && mkdir /root/.ssh \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
