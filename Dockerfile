# Set initial image
FROM debian:latest

# Set maintainer
MAINTAINER Konstantin Kozhin <konstantin@profitco.ru>
LABEL Description="This image provides PHP-FPM service version 5.6" Vendor="ProfitCo" Version="1.0"

# Update image
RUN apt-get update -y \
 && apt-get install build-essential vim git wget curl vim openssl imagemagick sudo -y \
 && apt-get clean all

# Install PHP and modules
RUN apt-get install -y \
php5 \
php5-adodb \
#php5-apcu \
php5-cgi \
php5-cli \
php5-common \
php5-curl \
php5-dbg \
#php5-dev \
php5-enchant \
php5-exactimage \
php5-fpm \
php5-gd \
php5-gdcm \
php5-gearman \
php5-geoip \
php5-geos \
php5-gmp \
php5-gnupg \
php5-idn \
php5-igbinary \
php5-imagick \
php5-imap \
php5-interbase \
php5-intl \
php5-json \
php5-lasso \
php5-ldap \
php5-librdf \
php5-libvirt-php \
php5-mapscript \
php5-mcrypt \
php5-memcache \
php5-memcached \
php5-mhash \
php5-mongo \
php5-msgpack \
php5-mssql \
#php5-mysql \
php5-mysqlnd \
php5-mysqlnd-ms \
php5-oauth \
php5-odbc \
php5-pecl-http \
php5-pecl-http-dev \
php5-pgsql \
php5-phpdbg \
php5-pinba \
php5-propro \
#php5-propro-dev \
php5-pspell \
php5-radius \
php5-raphf \
#php5-raphf-dev \
php5-readline \
php5-recode \
php5-redis \
php5-remctl \
php5-rrd \
php5-sasl \
#php5-snmp \
#php5-solr \
php5-sqlite \
php5-ssh2 \
php5-stomp \
#php5-svn \
php5-sybase \
php5-tidy \
#php5-tokyo-tyrant \
php5-twig \
#php5-uprofiler \
#php5-user-cache \
php5-vtkgdcm \
php5-xcache \
php5-xdebug \
php5-xhprof \
php5-xmlrpc \
php5-xsl \
#php5-yac \
php5-zmq

# Prepare configuration
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;date.timezone\s*=/date.timezone = Europe\/Moscow/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;php_admin_value[memory_limit]\s*=\s*128M/php_admin_value[memory_limit] = 256M/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;php_admin_value\[memory_limit\]\s*=\s*128M/php_admin_value[memory_limit] = 256M/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/php_value\[session.save_path\]\s*=\s*\/var\/lib\/php\/session/php_value[session.save_path] = \/tmp\/php\/session/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/php_value\[soap.wsdl_cache_dir\]\s*=\s*\/var\/lib\/php\/wsdlcache/php_value[soap.wsdl_cache_dir] = \/tmp\/php\/wsdlcache/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/^listen.allowed_clients\s*=\s*127.0.0.1/;listen.allowed_clients = 127.0.0.1/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/user\s*=\s*www-data/user = nobody/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/group\s*=\s*www-data/group = nogroup/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/listen\s*=\s*\/var\/run\/php5-fpm\.sock/listen = 0.0.0.0:9000/g" /etc/php5/fpm/pool.d/www.conf

# Create document root
RUN mkdir -p /var/www/html

# Set document root as work dir
WORKDIR /var/www/html

# Expose port
EXPOSE 9000

# Run service
CMD ["php5-fpm"]
