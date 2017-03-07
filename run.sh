#!/bin/bash
echo "Starting LetsEncrypt CERT server"
echo "EMAIL: "$EMAIL
echo "DOMAIN: "$DOMAIN

dotnet run --server.urls http://0.0.0.0:5000 &>/dev/null &
/certbot/certbot-auto certonly --text --non-interactive --email $EMAIL --agree-tos --webroot -w /app/wwwroot -d $DOMAIN

cp /etc/letsencrypt/live/$DOMAIN/cert.pem /certs/cert.pem
cp /etc/letsencrypt/live/$DOMAIN/chain.pem /certs/chain.pem
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem /certs/fullchain.pem
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem /certs/privkey.pem
