# What is this?
SSL termination via letsencrypt for a single host using containers.

This is useful if you want a setup like this:
```
         :80   :443
       +-------------+
       |    nginx    | (example.org)
       |   with SSL  | (foo.example.org)
       | termination | (bar.example.org)
       +-------------+
         |         |
         V         V
     +-----+     +-----+
     | foo |     | bar |
     +-----+     +-----+
```

The `nginx` above does two things:

1. serve certbot's `/.well-known` on `:80`
2. terminate SSL for apps

It has to serve on `:80`, so certbot can issue new certs without disrupting
traffic for existing domains. It also redirects everything else from `:80`
to `:443` by default.


# Usage
Start up the example nginx:
```
./example_nginx`
```

Issue a cert:
```
./issue example.org
```
