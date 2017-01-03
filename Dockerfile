FROM alpine:latest
MAINTAINER Peijun Cong <congpeijun@tuozhongedu.com>

ENV PHPIZE_DEPS \
		autoconf \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c \
        libssh2-dev \
        php5-dev

ENV PHP_SSH2_NAME ssh2-0.13
ENV PHP_SSH2_URL https://pecl.php.net/get/${PHP_SSH2_NAME}.tgz

ENV PHP_MONGO_NAME mongodb-1.2.2
ENV PHP_MONGO_URL https://pecl.php.net/get/${PHP_MONGO_NAME}.tgz

RUN set -xe \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk add --no-cache --update \
       unzip git rsync \
       ca-certificates openssl openssh-client \
       php5-cli php5-openssl php5-json php5-phar php5-mcrypt php5-xml php5-xmlreader php5-ctype \
       php5-curl \
       php5-bcmath \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    # php-ssh2
    && wget $PHP_SSH2_URL && tar -zxvf ${PHP_SSH2_NAME}.tgz \
    && cd ${PHP_SSH2_NAME} && phpize && ./configure && make && make install \
    && echo -e "extension=ssh2.so" > /etc/php5/conf.d/ssh2.ini \

    # php-mongo
    && wget ${PHP_MONGO_URL} && tar -zxvf ${PHP_MONGO_NAME}.tgz \
    && cd ${PHP_MONGO_NAME} && phpize && ./configure && make && make install \
    && echo -e "extension=mongodb.so" > /etc/php5/conf.d/mongodb.ini \

    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \
    && cd / && rm -rf ${PHP_SSH2_NAME}* ${PHP_MONGO_NAME}* && rm -rf package.xml \
    && echo -e "[Date]\ndate.timezone=Asia/Shanghai" > /etc/php5/php.ini \
    && wget "https://getcomposer.org/composer.phar" -O /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \

    # 配置ssh
    && mkdir /root/.ssh \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
