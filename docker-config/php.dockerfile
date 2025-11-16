FROM php:8.4-fpm
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install wget ocaml libelf-dev -y

# nodejs and jre
RUN mkdir -p /etc/apt/keyrings && \
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && \
    apt-get install -y temurin-8-jre git sudo unzip nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g vite
    
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
# Tambahkan Microsoft repo (Bookworm, bukan Trixie)
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list
ENV ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    msodbcsql18 unixodbc-dev && \
    rm -rf /var/lib/apt/lists/*
RUN install-php-extensions calendar exif FFI ftp gd gettext intl mysqli pcntl pdo_mysql pdo_pgsql pgsql shmop sodium sysvmsg sysvsem sysvshm opcache zip zlib sqlsrv pdo_sqlsrv
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN chown -R www-data:www-data /var/www

USER www-data

WORKDIR /var/www