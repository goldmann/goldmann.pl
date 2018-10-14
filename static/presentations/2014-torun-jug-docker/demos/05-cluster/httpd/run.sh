#!/bin/sh

docker run -it --rm --name lb -p 9090:80 wildfly-cluster-httpd
