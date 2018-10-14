FROM jboss/wildfly

ADD augeas.cmd /opt/wildfly/
RUN augtool -LA -e -f /opt/wildfly/augeas.cmd
