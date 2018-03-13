# What is this?
SSL termination via letsencrypt for a single host using containers.

This is useful if you want a setup like this:
```
      :80                 :443
+-------------+     +-------------+
|    nginx    |     |    nginx    | (example.org)
|     for     |     |   with SSL  | (foo.example.org)
|   certbot   |     | termination | (bar.example.org)
+-------------+     +-------------+
                      |         |
                      |  proxy  |
                      V         V
                  +-----+     +-----+
                  | foo |     | bar |
                  +-----+     +-----+
```

The "nginx for certbot" does two things:

1. serve certbot's `/.well-known`
2. redirect everthing else to HTTPS


# Usage
Start up the "nginx for certbot":
```
./nginx_for_certbot
```

Issue a cert:
```
./issue example.org
```

Afterwards, check `/etc/letsencrypt/live` for your new cert.


# Example
Let's encrypt `foo.felixhummel.de`.

Get the cert:
```
./nginx_for_certbot
./issue foo.felixhummel.de
```

The "service":
```
mkdir /tmp/foo
cd /tmp/foo
wget https://raw.githubusercontent.com/felixhummel/skeletons/gh-pages/html-minimal/index.html
python3 -mhttp.server --bind 127.0.0.1 8080
```

The "nginx with SSL termination":
```
[[ -f /etc/ssl/dhparam.pem ]] \
  || openssl dhparam -out /etc/ssl/dhparam.pem 2048 \
  && chmod 644 /etc/ssl/dhparam.pem

docker run --rm \
  --name nginx-terminator \
  --net=host \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  -v /var/www/letsencrypt:/var/www/letsencrypt:ro \
  -v ${PWD}/share/etc/nginx:/etc/nginx:ro \
  -v /etc/ssl/dhparam.pem:/etc/ssl/dhparam.pem:ro \
  nginx
```


# Renewal
First, make sure that "nginx for certbot" is always running.

Next, copy the renew script to a well-known location, e.g.:
```
cp renew /usr/local/sbin/
```

Then add a cron job that renews certs and reloads nginx, e.g.:
```
30 23 * * * /usr/local/sbin/renew 2>&1 | logger -t certbot && docker kill -s HUP nginx-terminator
```
