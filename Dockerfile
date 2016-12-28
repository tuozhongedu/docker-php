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

RUN set -xe \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk add --no-cache --update \
       unzip git rsync \
       ca-certificates openssl openssh-client \
       php5-cli php5-openssl php5-json php5-phar php5-mcrypt php5-xml php5-xmlreader php5-ctype \
       php5-curl \
       php5-bcmath \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && wget $PHP_SSH2_URL && tar -zxvf ${PHP_SSH2_NAME}.tgz \
    && cd ${PHP_SSH2_NAME} && phpize && ./configure && make && make install \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \
    && cd / && rm -rf ${PHP_SSH2_NAME}* && rm -rf package.xml \
    && echo -e "[Date]\ndate.timezone=Asia/Shanghai" > /etc/php5/php.ini \
    && echo -e "extension=ssh2.so" > /etc/php5/conf.d/ssh2.ini \
    && wget "https://getcomposer.org/composer.phar" -O /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer \
    #&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    #&& php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  \
    #&& php composer-setup.php --install-dir="/usr/local/bin" \
    #&& php -r "unlink('composer-setup.php');" \
    #&& ln -s /usr/local/bin/composer.phar /usr/local/bin/composer \
    && mkdir /root/.ssh \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
