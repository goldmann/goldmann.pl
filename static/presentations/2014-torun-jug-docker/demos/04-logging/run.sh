#!/bin/sh

docker run -it --rm -v `pwd`/log:/opt/jboss/wildfly/standalone/log jboss/wildfly

