Wymagane parametry do `docker run [...]`:

* istniejący pusty katalog `certs/`
* port `LOCAL_PORT`, który będzie wystawiony na świat jako port HTTP(=80) tak aby LetsEncrypt zweryfikował domenę `DOMAIN`
* parametr `EMAIL`
* parametr `DOMAIN`

Polecenie do wykonania
```
docker run --rm -p LOCAL_PORT:5000 -v $(pwd)/certs:/certs -e EMAIL=your@email.com -e DOMAIN=your.domain.com superprzemek/letsencrypt
```

Wynik: Pliki certyfikatów w katalogu `certs/`

## Szybki test poprawności certyfikatów

* Tworzymy plik `app/index.html`
* Tworzymy plik `confd/ssl.conf` o zawartości:

```
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name your.domain.com;

    ssl_certificate     /certs/fullchain.pem;
    ssl_certificate_key /certs/privkey.pem;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:20m;
    ssl_session_timeout 180m;

    root /app;
    index index.html;

    error_page 404 500 /error.html;
}
```

* Uruchamiamy obraz z `nginx`-em na pokładzie. Port `LOCAL_HTTPS_PORT` musi być dostępny ze świata jako HTTPS(=443).

```
docker run -d -v $(pwd)/confd:/etc/nginx/conf.d -v $(pwd)/app:/app -v $(pwd)/certs:/certs -p LOCAL_HTTPS_PORT:443 nginx
```

* Sprawdzamy działanie wchodząc na stronę `https://your.domain.com`
* Zatrzymujemy kontener dockera

### Wersje
Wersja + IMAGE ID + DIGEST

* 1.0 - f5decc4c0ae7 - sha256:89e1c2808e226c566f392f7f3ffaf1a622972ba930ca45808d815c8d368e5912
* 1.1 - 1f1909a96a3b - sha256:6c22a832ec0b3de9c5b3b6a2099e91c17caf50baf4b66478082ea42289d09d29
    Aktualizacja certbota z 0.9.3 do 0.12.0