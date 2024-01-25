# tuleap

Thanks https://docs.tuleap.org/installation-guide/docker/docker_compose.html# for the docker-compose.yml.
Thanks https://github.com/Enalean/tuleap/tree/15.0 for the Dockerfile.

You may pull the image from
```
docker pull falltrades/tuleap:stable-15.0
```

Or rebuild (it took me 755s) with
```
docker build -t tuleap/tuleap-community-edition:stable-15.0 .
```

Beware that TULEAP_SYS_DBPASSWD in the .env does not support special characters. It is needed to add the TULEAP_FQDN to your /etc/hosts. 
```
docker-compose up -d
```

To cleanup the containers including volumes.
```
docker-compose down --volumes
```

