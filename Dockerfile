FROM php:5-alpine
MAINTAINER Peijun Cong <congpeijun@tuozhongedu.com>

ENV PHP_SSH2_VERSION ssh2-0.13

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
        ca-certificates openssl openssh-client \

    && apk add --virtual .build-deps $PHPIZE_DEPS \

    && echo -e "date.timezone=Asia/Shanghai" > /usr/local/etc/php/conf.d/date_timezone.ini \
    && pecl install ${PHP_SSH2_VERSION} && docker-php-ext-enable ssh2 \
    && wget "https://getcomposer.org/composer.phar" -O /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \

    # 配置ssh
    && mkdir /root/.ssh \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*


