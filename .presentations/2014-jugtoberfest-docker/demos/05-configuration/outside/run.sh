#!/bin/sh

docker run -it --rm -p 8080:8080 -v `pwd`/configuration:/opt/wildfly/standalone/configuration jboss/wildfly
