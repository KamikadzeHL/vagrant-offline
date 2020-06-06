#!/usr/bin/env bash
set -e
echo "*****************************************************************************************"
echo "******************************* Install NGINX  ******************************************"
echo "*****************************************************************************************"

apt-get update
apt-get install -y nginx
chown vagrant:root -R /var/www/html/

echo "*****************************************************************************************"
echo "******************************* Install OpenSSL  ******************************************"
echo "*****************************************************************************************"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=UA/ST=Hell/L=Sallo/O=Personal/OU=Local Machine/CN=localhost"

echo "*****************************************************************************************"
echo "**************** Generate dhparam, wait for minutes please  *****************************"
echo "*****************************************************************************************"
openssl dhparam -out /etc/nginx/dhparam.pem 4096

cat <<-CONF > /etc/nginx/snippets/self-signed.conf
	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
CONF

cat <<-CONF > /etc/nginx/snippets/ssl-params.conf
	ssl_protocols TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_dhparam /etc/nginx/dhparam.pem;
	ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
	ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
	ssl_session_timeout  10m;
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off; # Requires nginx >= 1.5.9
	ssl_stapling on; # Requires nginx >= 1.3.7
	ssl_stapling_verify on; # Requires nginx => 1.3.7	
	resolver 8.8.8.8 8.8.4.4 valid=300s;
	resolver_timeout 5s;
	# Disable strict transport security for now. You can uncomment the following
	# line if you understand the implications.
	# add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
	add_header X-Frame-Options DENY;
	add_header X-Content-Type-Options nosniff;
	add_header X-XSS-Protection "1; mode=block";
CONF

sed -i "27i\listen 443 ssl;" /etc/nginx/sites-available/default
sed -i "28i\include snippets/self-signed.conf;" /etc/nginx/sites-available/default

service nginx restart







