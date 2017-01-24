FROM composer:latest
MAINTAINER Peijun Cong <congpeijun@tuozhongedu.com>

ENV PHP_SSH2_VERSION ssh2-1.0

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
    && apk add --update rsync \
    && apk add --virtual .build-deps $PHPIZE_DEPS \


    && echo -e "date.timezone=Asia/Shanghai" > /usr/local/etc/php/conf.d/date_timezone.ini \
    && pecl install ${PHP_SSH2_VERSION} && docker-php-ext-enable ssh2 \
    # 配置ssh
    && mkdir /root/.ssh \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \
    && rm /tmp/*


