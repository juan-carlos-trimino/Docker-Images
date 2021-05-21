Usage
=====
Windows
-------
Create self-signed certificate on Windows using OpenSSL inside docker.
>`>` docker run -d --rm -v C:\jct\Repos\Volumes\OpenSSL:c:/openssl-certs veni-vidi-vici/openssl-1.1.1i:nanoserver-20H2<br>
>`>` docker run -it --rm -v C:\jct\Repos\Volumes\OpenSSL:c:/openssl-certs veni-vidi-vici/openssl-1.1.1i:nanoserver-20H2

Linux
-----
>`\>` docker build -t veni-vidi-vici/openssl-1.1.1k:alpine-3.13 -f ./OpenSSL/Dockerfile.linux ./OpenSSL<br>
>`\>` docker run -it --rm -v /jct/Repos/Volumes/OpenSSL:/openssl-certs veni-vidi-vici/openssl-1.1.1k:alpine-3.13<br><br>
To use the shell, remove the following line from Dockerfile.linux:<br>
**ENTRYPOINT ["openssl"]**<br>
>`\>` docker run -it --rm -v /jct/Repos/Volumes/OpenSSL:/openssl-certs veni-vidi-vici/openssl-1.1.1k:alpine-3.13 sh<br>
Then from the command prompt, type:<br>
`\>` openssl

<br>

Useful Docker Commands
----------------------
List local images
>`PS>` docker image ls

Remove given image (force removal)
>`PS>` docker image rm -f [container-name-or-id]

Remove given container (it must be stopped first)
>`PS>` docker rm [container-name-or-id]

Kill a running container
>`PS>` docker container kill [container-name-or-id]

List running containers
>`PS>` docker container ls
>`PS>` docker ps

List all containers
>`PS>` docker container ls -a

Remove all containers (active and non-active)
>`PS>` docker container ls -aq | foreach { docker rm -f $_ }

Remove images with TAG=<none>
>`PS>` docker rmi $(docker images -f "dangling=true" -q)

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

**Certificate-Signing Request (CSR)**<br>
Once the private key is generated, create a *certificate-signing request* to have the CA sign it.
>`OpenSSL>` req -new -passin pass:"app-pwd" -key ./openssl-certs/app/app_key.pem -out ./openssl-certs/app/csr.pem -subj "/CN=app.web.com"

**Application's CA signed certificate**<br>
Get the CSR sign by the CA; now the application has a private key and signed certificate.
>`OpenSSL>` x509 -req -in ./openssl-certs/app/csr.pem -days 365 -passin pass:"ca-pwd" -CAkey ./openssl-certs/ca/ca_key.pem -CA ./openssl-certs/ca/ca_cert.pem -set_serial 01 -out ./openssl-certs/app/app_cert.pem
