#!/bin/bash

echo "Criando estrutura de diretórios..."
mkdir -p database/{mariadb,mysql,oracle,postgresql,sqlite}
mkdir -p hybrid-folder
mkdir -p php/{7.0,7.4,8.0,8.1,8.2}/conf
mkdir -p tools/{bitbucket,pgadmin,phpmyadmin}
mkdir -p webserver/{apache/sites-enabled,caddy,nginx,openlitespeed}
mkdir -p wordpress/{wp-5.8,wp-6.0,wp-6.2,wp-6.4}/{plugins,themes,uploads,wp-content}

echo "Criando arquivos de configuração..."
touch docker-compose.yml LICENSE README.md

# Criando configurações PHP
for version in 7.0 7.4 8.0 8.1 8.2; do
  echo "memory_limit = 512M" > php/$version/conf/php.ini
  echo "upload_max_filesize = 50M" >> php/$version/conf/php.ini
  echo "post_max_size = 50M" >> php/$version/conf/php.ini
done

# Criando configurações do Webserver
echo "Criando configurações do Apache..."
cat > webserver/apache/sites-enabled/default.conf <<EOL
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOL

echo "Criando configurações do Nginx..."
cat > webserver/nginx/nginx.conf <<EOL
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOL

echo "Criando configurações do Caddy..."
cat > webserver/caddy/Caddyfile <<EOL
:80 {
    root * /var/www/html
    php_fastcgi php:9000
    file_server
}
EOL

echo "Criando configurações do OpenLiteSpeed..."
cat > webserver/openlitespeed/ols.conf <<EOL
listener Default {
    address *:80
    secure 0
}
virtualhost Example {
    vhRoot /var/www/html
    configFile conf/vhosts/Example/vhconf.conf
}
EOL

echo "Criando configurações do WordPress..."
for version in wp-5.8 wp-6.0 wp-6.2 wp-6.4; do
  cat > wordpress/$version/wp-config.php <<EOL
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'root');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'database');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('WP_DEBUG', true);
EOL
done

echo "Estrutura criada com sucesso!"
