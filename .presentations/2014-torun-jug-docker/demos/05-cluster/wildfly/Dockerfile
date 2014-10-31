FROM wildfly-app
ADD standalone-ha.xml /opt/jboss/wildfly/standalone/configuration/
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-c", "standalone-ha.xml", "-Djboss.node.name=`hostname -s`", "-b", "`hostname -i`", "-DjvmRoute=`hostname -s`", "-Djboss.modcluster.proxylist=$LB_PORT_80_TCP_ADDR:80"]
