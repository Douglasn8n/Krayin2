# Copia os arquivos do projeto
COPY . /var/www/html

# Define a pasta pública como raiz do Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Atualiza a configuração do Apache para usar public/
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Ativa regravação e inicia o Apache
RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]
