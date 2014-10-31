#!/bin/sh

docker run -it --rm -v `pwd`/log:/opt/wildfly/standalone/log jboss/wildfly

