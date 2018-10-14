FROM wildfly-app
ADD standalone-ha.xml /opt/wildfly/standalone/configuration/
CMD ["/opt/wildfly/bin/standalone.sh", "-c", "standalone-ha.xml", "-Djboss.node.name=`hostname -s`", "-b", "`hostname -i`", "-DjvmRoute=`hostname -s`", "-Djboss.modcluster.proxylist=$LB_PORT_80_TCP_ADDR:80"]
