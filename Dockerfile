FROM php:8.1-apache

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libpng-dev libonig-dev libxml2-dev curl \
    && docker-php-ext-install pdo pdo_mysql zip gd

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define o diretório de trabalho padrão
WORKDIR /var/www/html

# Copia os arquivos do projeto
COPY . .

# Instala as dependências do Laravel
RUN composer install --no-interaction --prefer-dist || true

# Copia o .env se não existir
RUN [ -f ".env" ] || cp .env.example .env

# Gera a chave da aplicação (ignora falhas se banco não estiver pronto)
RUN php artisan key:generate || true

# Define o diretório público do Apache para o Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Atualiza as configurações do Apache para servir a partir de /public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Ativa mod_rewrite
RUN a2enmod rewrite

# Expõe a porta padrão
EXPOSE 80

# Inicia o Apache
CMD ["apache2-foreground"]
