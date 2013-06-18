---
title: "Domain mode in Fedora's JBoss AS"
author: "Marek Goldmann"
layout: blog
timestamp: 2013-05-24t11:30:00.10+02:00
tags: [ jboss_as, fedora ]
---

[JBoss Application Server](http://www.jboss.org/jbossas) shipped in
[Fedora](https://fedoraproject.org/) makes it easy to run it as a system
service. So far you could launch only the `standalone` mode, there was no easy
way to run it in the `domain` mode. This is going to change.

If you're not familiar with the operating modes, I highly recommend you reading
the [introduction to
it](https://docs.jboss.org/author/display/AS71/Operating+modes). In short, in
domain mode you can launch more than one server on one host easily. But this
is not everything &#8211; you get a single entry point for management for all
these instances. This means that you can deploy applications one all instances
by just executing one command!

<div class="alert alert-info"><strong>Available with the next jboss-as package update</strong><br/>Domain mode will be available with the next jboss-as package update <strong>7.1.1-19</strong> on <strong>Fedora 19+</strong>.</div>

## Configuration

With the
[`jboss-as-7.1.1-19`](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-19.fc19)
update you'll be able to select which mode should be used when running the
systemd service for JBoss AS. To do this you need to edit the
`/etc/jboss-as/jboss-as.conf` file.

You can choose the mode by setting the `JBOSS_MODE` environment variable. Do
not forget to select a valid configuration file by setting the `JBOSS_CONFIG`
variable.

    # The configuration you want to run
    #
    # JBOSS_CONFIG=standalone.xml
    JBOSS_CONFIG=domain.xml

    # The mode you want to run
    # JBOSS_MODE=standalone
    JBOSS_MODE=domain

    # The address to bind to
    #
    JBOSS_BIND=0.0.0.0

Afterwards you can restart the server by simply using the `systemctl` command:

    $ systemctl restart jboss-as.service

And voila &#8211; domain mode is running with two JBoss AS instances (default case):

    $ systemctl status jboss-as.service
    jboss-as.service - The JBoss Application Server
       Loaded: loaded (/usr/lib/systemd/system/jboss-as.service; disabled)
       Active: active (running) since pią 2013-05-24 10:56:30 CEST; 7s ago
     Main PID: 1325 (launch.sh)
       CGroup: name=systemd:/system/jboss-as.service
               ├─1325 /bin/sh /usr/share/jboss-as/bin/launch.sh domain domain.xml 0.0.0.0
               ├─1326 /bin/sh /usr/share/jboss-as/bin/domain.sh -c domain.xml -b 0.0.0.0
               ├─1368 java -D[Process Controller] -server -Xms64m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true -Dorg.jboss.resolver.warning=true -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.modules.system.pkgs=org.jboss.byt...
               ├─1382 java -D[Host Controller] -Dorg.jboss.boot.log.file=/usr/share/jboss-as/domain/log/host-controller.log -Dlogging.configuration=file:/usr/share/jboss-as/domain/configuration/logging.properties -server -Xms64m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Sta...
               ├─1433 /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.19.x86_64/jre/bin/java -D[Server:server-one] -XX:PermSize=256m -XX:MaxPermSize=256m -Xms64m -Xmx512m -server -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.bind.address=0.0.0.0 -Dsun...
               └─1451 /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.19.x86_64/jre/bin/java -D[Server:server-two] -XX:PermSize=256m -XX:MaxPermSize=256m -Xms64m -Xmx512m -server -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.bind.address=0.0.0.0 -Dsun...


## Domain management examples

The JBoss AS domain is so powerful that you can launch another server instance by using just the CLI:

    [domain@localhost:9999 /] /host=master/server-config=server-three:start
    {
        "outcome" => "success",
        "result" => "STARTING"
    }
    [domain@localhost:9999 /] /host=master/server-config=server-three:read-resource(include-runtime=true)
    {
        "outcome" => "success",
        "result" => {
            "auto-start" => false,
            "group" => "other-server-group",
            "interface" => undefined,
            "jvm" => undefined,
            "name" => "server-three",
            "path" => undefined,
            "socket-binding-group" => undefined,
            "socket-binding-port-offset" => 250,
            "status" => "STARTED",
            "system-property" => undefined
        }
    }

You can check the status of the service to confirm that the server is actually a new instance:

    $ systemctl status jboss-as.service
    jboss-as.service - The JBoss Application Server
       Loaded: loaded (/usr/lib/systemd/system/jboss-as.service; disabled)
       Active: active (running) since pią 2013-05-24 10:56:30 CEST; 8min ago
     Main PID: 1325 (launch.sh)
       CGroup: name=systemd:/system/jboss-as.service
               ├─1325 /bin/sh /usr/share/jboss-as/bin/launch.sh domain domain.xml 0.0.0.0
               ├─1326 /bin/sh /usr/share/jboss-as/bin/domain.sh -c domain.xml -b 0.0.0.0
               ├─1368 java -D[Process Controller] -server -Xms64m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true -Dorg.jboss.resolver.warning=true -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.modules.system.pkgs=org.jboss.byt...
               ├─1382 java -D[Host Controller] -Dorg.jboss.boot.log.file=/usr/share/jboss-as/domain/log/host-controller.log -Dlogging.configuration=file:/usr/share/jboss-as/domain/configuration/logging.properties -server -Xms64m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Sta...
               ├─1433 /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.19.x86_64/jre/bin/java -D[Server:server-one] -XX:PermSize=256m -XX:MaxPermSize=256m -Xms64m -Xmx512m -server -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.bind.address=0.0.0.0 -Dsun...
               ├─1954 /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.19.x86_64/jre/bin/java -D[Server:server-two] -XX:PermSize=256m -XX:MaxPermSize=256m -Xms64m -Xmx512m -server -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.bind.address=0.0.0.0 -Dsun...
               └─2076 /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.19.x86_64/jre/bin/java -D[Server:server-three] -XX:PermSize=256m -XX:MaxPermSize=256m -Xms64m -Xmx512m -server -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djboss.bind.address=0.0.0.0 -Ds...

Now you can use the JBoss AS CLI to deploy application to **all running instances** in one step:

    [domain@localhost:9999 /] deploy node-info.war --all-server-groups

Nice, isn't?

Of course there is more stuff you can do with it, please read [the
documentation](https://docs.jboss.org/author/display/AS71/Admin+Guide).

The update was [submitted to Fedora
19](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-19.fc19) and is
already available in Rawhide. Please give it a shot and add some karma!

### Update 28.05.2013

Please make sure you install the
[jacorb-2.3.1-5](https://admin.fedoraproject.org/updates/FEDORA-2013-9359)
bugfix update available now in `updates-testing` repository. This fixes some
issues when running JBoss AS in high-availability and in domain mode.

