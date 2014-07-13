FROM stackbrew/ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update -y
RUN apt-get install -y \
 daemontools nginx curl \
 php5-cli php5-json php5-fpm php5-intl php5-curl php5-mysql \
 mysql-server \
 git

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD docker/services/ /srv/services

ADD docker/entrypoint.sh /usr/local/bin/entrypoint.sh
ADD docker/vhost.conf /etc/nginx/sites-enabled/default
ADD docker/my.cnf /etc/mysql/my.cnf

RUN echo 'date.timezone = Europe/Paris' >> /etc/php5/fpm/php.ini


RUN apt-get install -y python-software-properties python g++ make
#RUN add-apt-repository -y ppa:chris-lea/node.js
#RUN apt-get update -y
#RUN apt-get install -y nodejs

WORKDIR /var/www

VOLUME ["/var/www"]

EXPOSE 80

CMD ["/usr/local/bin/entrypoint.sh"]
