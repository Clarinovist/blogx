FROM debian:buster

RUN apt update
RUN apt install -y curl wget unzip nano
WORKDIR /blogx

RUN apt install -y gnupg2 ca-certificates apt-transport-https software-properties-common
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list

RUN apt update
RUN apt install -y php8.0 php8.0-mysql php8.0-xml php8.0-curl php8.0-mbstring php8.0-zip php8.0-cli
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

COPY . /blogx
RUN composer install

COPY .env.example .env

RUN php artisan migrate
CMD ["php","artisan","serve","--host=0.0.0.0"]

