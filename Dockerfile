FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libpng-dev libonig-dev libxml2-dev curl \
    && docker-php-ext-install pdo pdo_mysql zip gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-interaction --prefer-dist || true

RUN cp .env.example .env || true

RUN php artisan key:generate || true

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]
