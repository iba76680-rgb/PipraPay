FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    php8.1 \
    php8.1-mysql \
    php8.1-zip \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-gd \
    php8.1-xml \
    php8.1-bcmath \
    libapache2-mod-php8.1 \
    && apt-get clean

RUN a2dismod mpm_event && \
    a2enmod mpm_prefork rewrite headers php8.1

RUN rm -rf /var/www/html/*

COPY . /var/www/html/

RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    DirectoryIndex index.php index.html\n\
    <Directory /var/www/html>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
