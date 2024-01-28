# Use the official PHP image as the base image
FROM php:8.2-apache

# use root user
USER root 

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the application files into the container
COPY css /var/www/html/css/
COPY js /var/www/html/js/
COPY includes /var/www/html/includes/
COPY pages/login.php /var/www/html/pages/
COPY pages/register.php /var/www/html/pages/
COPY pages/dashboard.php /var/www/html/pages/
COPY composer.json composer.lock* /var/www/html/
COPY .env /var/www/html

RUN apt-get update && apt-get install -y\
    libpng-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \ 
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

RUN composer install --no-dev --optimize-autoloader

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port for Apache
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]