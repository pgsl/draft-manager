# Configuring SSL

This SSL certificate is ONLY for development.  It is not to be used for production.  This is a self-signed certificate that must be added to your keychain.  It is valid for 10 years.

1. Customize the `openssl.cnf` file with the project name.
2. Run:

        $ openssl req \
          -new \
          -newkey rsa:2048 \
          -sha1 \
          -days 3650 \
          -nodes \
          -x509 \
          -keyout futurefund.dev.key \
          -out futurefund.dev.crt \
          -config openssl.cnf
