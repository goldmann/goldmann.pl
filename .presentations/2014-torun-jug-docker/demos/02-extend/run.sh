#!/bin/sh

docker run -it --rm -p 8080:8080 -p 9990:9990 wildfly-management /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
