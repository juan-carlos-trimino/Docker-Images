Usage
=====
Create self-signed certificate on Windows using openssl inside docker.
>`>` docker container run -it --rm -v c:/jct/certs:c:/openssl-certs [name-of-container-image][:version-or-variation]

<br>

OpenSSL Quick Reference Guide
=============================
OpenSSL Information
-------------------
**Check OpenSSL Version**
>`OpenSSL>` version -a

<br>

Generate keys for the Certificate Authority (CA)
------------------------------------------------
**Private key**<br>
The *genrsa* command generates an RSA private key. This command generates a private key of 4,096 bits and encrypts it with AES-256 and the provided passphrase. The generated key is created using the OpenSSL format PEM.
>`OpenSSL>` genrsa -aes256 -passout pass:"ca-pwd" -out ./openssl-certs/ca/ca_key.pem 4096<br>

**Review the certificate**<br>
*-noout* prevents output of the encoded version of the key.<br>
*-text* prints out the various public or private key components in plain text in addition to the encoded version.
>`OpenSLL>` rsa -text -passin pass:"ca-pwd" -in ./openssl-certs/ca/ca_key.pem -noout

**Public key**
>`OpenSSL>` req -new -passin pass:"ca-pwd" -key ./openssl-certs/ca/ca_key.pem -x509 -days 365 -out ./openssl-certs/ca/ca_cert.pem -subj "/CN=ca.web.com"

**Review the certificate**
>`OpenSLL>` x509 -in ./openssl-certs/ca/ca_cert.pem -text

**Extract the Public Key**<br>
The private key file contains both the private key and the public key. To extract the public key from the private key file.
>`OpenSSL>` rsa -passin pass:"ca-pwd" -in ./openssl-certs/ca/ca_key.pem -pubout -out ./openssl-certs/ca/ca1_cert.pem

<br>

Generate keys for applications
------------------------------
**Private key**<br>
>`OpenSSL>` genrsa -aes256 -passout pass:"app-pwd" -out ./openssl-certs/app/app_key.pem 4096

**Certificate-Signing Request**<br>
Once the private key is generated, create a *certificate-signing request (CSR)* to have the CA sign it.
>`OpenSSL>` req -new -passin pass:"app-pwd" -key ./openssl-certs/app/app_key.pem -out ./openssl-certs/app/csr.pem -subj "/CN=app.web.com"

**Application's CA signed certificate**
>`OpenSSL>` x509 -req -in ./openssl-certs/app/csr.pem -days 365 -passin pass:"ca-pwd" -CAkey ./openssl-certs/ca/ca_key.pem -CA ./openssl-certs/ca/ca_cert.pem -set_serial 01 -out ./openssl-certs/app/app_cert.pem

xxxxxxxxNow the application has a private key and signed certificate.

