This is a [docker container](https://github.com/gene1wood/postsrsd/pkgs/container/postsrsd) that's based off of the [linuxserver.io alpine base image](https://github.com/linuxserver/docker-baseimage-alpine)
which runs [postsrsd](https://github.com/roehling/postsrsd), the Postfix Sender 
Rewriting Scheme daemon.

This repo contains
* `Dockerfile` : The Dockerfile to create the container
* `root/` : The files to copy into the container
* `docker-compose.yml` : An example docker compose file showing how to deploy the container

The domain name that you want to use is set with the `SRS_DOMAIN` environment 
variable.
You can see this set in the example `docker-compose.yml` file as `set-this-to-yourdomain.example.com`.
The example `docker-compose.yml` file mounts the `/etc/postsrsd` host directory 
in the container and must contain a `postsrsd.secret` file containing your 
generated SRS secret.
Make sure the `/etc/postsrsd` directory on the host and the `postsrsd.secret` 
file within it are owned and readable and writable by the user that you create
(e.g. a unix user called `postsrsd`) and that you set the `PUID` and `GUID` 
environment variables in the `docker-compose.yml` to the UID and GID of that
user. This way the daemon can read and write to the secret file on the host.

# Usage

* Create a user on your host, for example called `postsrsd`
* Create a `/etc/postsrsd` directory on your host and make the `postsrsd` user the owner. `chown postsrsd:postsrsd /etc/postsrsd`
* Create a `/etc/postsrsd/postsrsd.secret` file with an SRS secret in it (32 character string). `tr -dc '1-9a-zA-Z' < /dev/urandom | head -c 32 > /etc/postsrsd/postsrsd.secret`
* Set the `postsrsd` user as the owner of the file. `chown postsrsd:postsrsd /etc/postsrsd/postsrsd.secret`
* Using the example `docker-compose.yml` file create a `docker-compose.yml` file
on your host.
  * Set the `SRS_DOMAIN` environment variable in the docker compose file to the 
    domain you want to send as
  * Set the `GUID` and `PUID` environment variables to the GID an PID of your `postsrsd` user
* Start the docker container with docker compose
* Configure `postfix` to use the new SRS daemon by setting these variables in your `/etc/postfix/main.cf` file
  * `sender_canonical_maps = tcp:localhost:10001`
  * `sender_canonical_classes = envelope_sender`
  * `recipient_canonical_maps = tcp:localhost:10002`
  * `recipient_canonical_classes = envelope_recipient,header_recipient`
* Restart postfix and test
