
# Jak kompilowac/uruchomic:
#
# \> docker build -t superprzemek/letsencrypt .
# lub
# \> docker build --no-cache -t superprzemek/letsencrypt .
# 
# Wrzucenie na hub.docker.com:
#
# \> docker tag IMAGE_ID superprzemek/letsencrypt:v1.1
# \> docker tag IMAGE_ID superprzemek/letsencrypt:latest
# \> docker push superprzemek/letsencrypt:v1.1
# \> docker push superprzemek/letsencrypt:latest
#
# Pobranie najnojwszej wersji
#
# \> docker pull superprzemek/letsencrypt:latest
#
# Uruchamianie:
#
# \> mkdir certs/
# \> docker run --rm -p LOCAL_PORT:5000 -v $(pwd)/certs:/certs -e EMAIL=your@email.com -e DOMAIN=your.domain.com superprzemek/letsencrypt
#

# microsoft/dotnet - 93cfb3181bc1 - sha256:f6542ad66665a715452a6d79ef3392000bd6bf1482da719e81abbfed9a3d7d8a
# dotnet --version: 1.0.0-preview2-003131
FROM microsoft/dotnet@sha256:f6542ad66665a715452a6d79ef3392000bd6bf1482da719e81abbfed9a3d7d8a

MAINTAINER superprzemek

RUN ["mkdir", "/certbot"]
WORKDIR /certbot
RUN ["wget", "https://dl.eff.org/certbot-auto"]
RUN ["chmod", "a+x", "certbot-auto"]
RUN ./certbot-auto --dry-run --text --non-interactive --staging || true

COPY . /app
WORKDIR /app

RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]

EXPOSE 5000/tcp
VOLUME /certs

CMD ["/bin/bash", "run.sh"]
