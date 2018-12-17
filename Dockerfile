FROM debian

RUN set -ex; apt-get update; 
RUN set -ex; apt-get install -y apache2 php;
#RUN set -ex; apt-get install -y unzip libcurl4-openssl-dev libjpeg-dev libpng-dev libmcrypt-dev;
RUN set -ex; apt-get install -y curl unzip php-gd php-mcrypt php-mbstring php-mysqli php-opcache php-curl; 
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=2'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
        } > /etc/php/7.0/cli/conf.d/opcache-recommended.ini

RUN a2enmod rewrite

VOLUME /var/www/html

ENV TASTYIGNITER_VERSION 2.1.1

RUN set -ex; \
        curl -o tastyigniter.zip -fSL "https://codeload.github.com/tastyigniter/TastyIgniter/zip/${TASTYIGNITER_VERSION}"; \
        unzip tastyigniter.zip -d /usr/src/; \
        rm tastyigniter.zip; \
        mv /usr/src/TastyIgniter-${TASTYIGNITER_VERSION} /usr/src/tastyigniter; \
        chown -R www-data:www-data /usr/src/tastyigniter


COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
