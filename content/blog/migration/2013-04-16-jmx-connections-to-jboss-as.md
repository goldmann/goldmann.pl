---
title: "JMX connections to JBoss AS"
author: "Marek Goldmann"
date: 2013-04-16
tags: [ jboss_as ]
---

There are many tools that use JMX connections which can be useful for
debugging and performance tunning of your applications running on the JVM. The
most used are JConsole (shipped with every JDK) and VisualVM (available to
download on [Oracle page](http://visualvm.java.net/)).

But before I show how to connect them to JBoss AS we need to understand a few
concepts.

## Standalone and domain mode

JBoss AS can be run in either **standalone** or **domain** mode. I won't explain in
detail the difference between those two here because this is a topic for
another blog post.  The most important difference is that in domain mode you
can manage a set of JBoss AS instances using one management entry point
compared to starting just one server in standalone mode. It depends on your use
case which mode you should use - both have pros and cons.

No matter which mode you choose you will be able to connect to the instance(s)
using a remoting connector to access JMX. Please note that the connection
configuration is different depending on which mode you choose.

## Classpath changes

To be able to connect to the remote JMX you need to add a few libraries to the
classpath.

<div class="alert alert-info"><strong>Optional</strong><br/>You can skip this part if you're going to connect to local processes and don't want to have the JBoss CLI integrated with JConsole. In any other case this step is required.</div>

### JConsole

If you use JConsole, you're lucky, because the JBoss AS team ships
a wrapper script for JConsole. You can find it in
`$JBOSS_HOME/bin/jconsole.sh`. As a bonus you get access to the JBoss AS CLI
directly from JConsole.

<a class="picture" href="/images/jmx/jconsole.png" title="JConsole"><img style="width: 50%; border: 1px solid #eee; padding: 5px;" alt="VisualVM" src="/images/jmx/jconsole.png" /></a>

### VisualVM

If you want to use VisualVM, I
[adjusted](https://gist.github.com/goldmann/fdea19f156eff7b15f99) a wrapper
script, found originally on [akquinet
blog](http://blog.akquinet.de/2012/11/01/connecting-visualvm-with-a-remote-jboss-as-7-eap6-jvm-process/).
[This script](https://gist.github.com/goldmann/fdea19f156eff7b15f99) will
make it easy to launch VisualVM with the required libraries on the classpath for
both JBoss AS 7 and 8.

You may need to adjust the `VISUALVM` path to the VisualVM executable before
you proceed.

<a class="picture" href="/images/jmx/visualvm.png" title="VisualVM"><img style="width: 50%; border: 1px solid #eee; padding: 5px;" alt="VisualVM" src="/images/jmx/visualvm.png" /></a>

## Connections

Now, that we have our monitoring applications set up with the correct classpath, we're ready
to connect to a local or remote instance.

### Local processes

This is when the monitoring application and the JBoss AS instance are running on one host.

<div class="alert alert-warn"><h4>Mode</h4>This works in both <strong>standalone</strong> and <strong>domain</strong> mode.</div>

There are **no classpath preparations required** to connect JConsole or VisualVM to a
local process. But if you want to use the integrated CLI with JConsole you need
to use the `jconsole.sh` wrapper script mentioned earlier.

In this case, no authentication is necessary since connections from the same
host are automatically allowed.

To begin just start the selected application (JConsole or Visual VM), choose
the appropriate Java process from the list and you're ready.

<a rel="local" class="picture" href="/images/jmx/jconsole_local.png" title="JConsole local processes"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="JConsole local processes" src="/images/jmx/jconsole_local.png" /></a>
<a rel="local" class="picture" href="/images/jmx/visualvm_local.png" title="VisualVM local processes"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="VisualVM local processes" src="/images/jmx/visualvm_local.png" /></a>

### Remote process with password authentication and native port

This is when the monitoring application and the JBoss AS instance are running
on different hosts and we connect to the **native management port**.

<div class="alert alert-warn"><h4>Mode</h4>This works in <strong>standalone</strong> mode only.</div>

#### Port visibility

To connect using the native port you need to make sure the JBoss AS management
interface is visible from the client host.

By default the management interface is bound to `127.0.0.1`. To change the
management interface address to bind to, you can use the
`jboss.bind.address.management` property, like this:

    $ bin/standalone.sh -Djboss.bind.address.management=IP_ADDRESS

You can also make it persistent using the JBoss CLI (`$JBOSS_HOME/bin/jboss-cli.sh`) using this call:

    # /interface=management/:write-attribute(name=inet-address,value=IP_ADDRESS)

You can use the same call for domain mode, but please be aware this will not
make the native management port available for JMX connections. For remote
connections to JBoss AS running in domain mode see the remoting port described
below.

<div class="alert alert-warn"><h4>Restart required</h4>Please note that a JBoss AS restart is required to apply the above change.</div>

The native management endpoint is exposed by default on port `9999`.

#### Management user creation

To be able to authenticate with the remote host we need to create a
**management user** using the `$JBOSS_HOME/bin/add-user.sh` script.

    $ bin/add-user.sh

    What type of user do you wish to add?
     a) Management User (mgmt-users.properties)
     b) Application User (application-users.properties)
    (a): a

    Enter the details of the new user to add.
    Realm (ManagementRealm) :
    Username : test
    Password :
    Re-enter Password :
    About to add user 'test' for realm 'ManagementRealm'
    Is this correct yes/no? yes
    Added user 'test' to file '/home/jboss/standalone/configuration/mgmt-users.properties'
    Added user 'test' to file '/home/jboss/domain/configuration/mgmt-users.properties'
    Is this new user going to be used for one AS process to connect to another AS process e.g. slave domain controller?
    yes/no? yes
    To represent the user add the following to the server-identities definition <secret value="cWF6IUAjMTIz" />

#### Connection

Now we're ready to connect to the remote instance. The connection string should look similar to this:

    service:jmx:remoting-jmx://HOST:9999

<div class="alert alert-warn"><h4>Classpath entries</h4>This connection type requires the modified classpath changes described above.</div>

In the username and password fields please enter the valid credentials for the
management user you created earlier.

<a rel="native" class="picture" href="/images/jmx/jconsole_native.png" title="JConsole native"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="JConsole native" src="/images/jmx/jconsole_native.png" /></a>
<a rel="native" class="picture" href="/images/jmx/visualvm_native.png" title="VisualVM native"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="VisualVM native" src="/images/jmx/visualvm_native.png" /></a>

### Remote process with password authentication and remoting port

This is when the monitoring application and the JBoss AS instance are running
on different hosts and we connect to the **remoting port**.

<div class="alert alert-warn"><h4>Mode</h4>This works in both <strong>standalone</strong> and <strong>domain</strong> mode.</div>

#### Port visibility

To connect using the remoting port you need to make sure the JBoss AS instance
is visible from the client host.

<div class="alert alert-info"><h4>Difference</h4>Please note that the configuration described here is different from the native management configuration above.</div>

By default JBoss AS is bound to `127.0.0.1`. To change the address to bind to, you can use the
`-b` switch when starting JBoss AS, like this:

    $ bin/standalone.sh -b IP_ADDRESS

You can also make it persistent using the JBoss CLI (`$JBOSS_HOME/bin/jboss-cli.sh`) using this call:

    # /interface=public/:write-attribute(name=inet-address,value=IP_ADDRESS)

<div class="alert alert-warn"><h4>Restart required</h4>Please note that a JBoss AS restart is required to apply the above change.</div>

The remoting endpoint is exposed by default on port `4447`. If you start JBoss
AS in domain mode then the remoting port of the first instance will be
exposed on port `4447` but later instances will add an offset to this port. By
default the offset is equal to `150` so the second instance will use port `4597`
as the remoting port, the third `4747`, and so on.

#### Application user creation

To be able to authenticate with the remote host using the remoting port we need
to create an **application user** using the `$JBOSS_HOME/bin/add-user.sh`
script.

    $ bin/add-user.sh

    What type of user do you wish to add?
     a) Management User (mgmt-users.properties)
     b) Application User (application-users.properties)
    (a): b

    Enter the details of the new user to add.
    Realm (ApplicationRealm) :
    Username : test
    Password :
    Re-enter Password :
    What roles do you want this user to belong to? (Please enter a comma separated list, or leave blank for none)[  ]:
    About to add user 'test' for realm 'ApplicationRealm'
    Is this correct yes/no? yes
    Added user 'test' to file '/home/goldmann/jira/TORQUE-1039-remote-jmx/jboss-as-7.1.2.Final/standalone/configuration/application-users.properties'
    Added user 'test' to file '/home/goldmann/jira/TORQUE-1039-remote-jmx/jboss-as-7.1.2.Final/domain/configuration/application-users.properties'
    Added user 'test' with roles  to file '/home/goldmann/jira/TORQUE-1039-remote-jmx/jboss-as-7.1.2.Final/standalone/configuration/application-roles.properties'
    Added user 'test' with roles  to file '/home/goldmann/jira/TORQUE-1039-remote-jmx/jboss-as-7.1.2.Final/domain/configuration/application-roles.properties'
    Is this new user going to be used for one AS process to connect to another AS process e.g. slave domain controller?
    yes/no? yes
    To represent the user add the following to the server-identities definition <secret value="cWF6IUAjMTIz" />

#### Configuration

By default you can connect to JBoss AS to access JMX using the native
management interface. To use the remoting interface you need to manualy change
the JBoss AS configuration.

<div class="alert alert-warn"><h4>You cannot use both</h4>When you decide to change the configuration and use the remoting endpoint for JMX access, the native management endpoint will stop working. You cannot use both endpoints on one host.</div>

You can change this by using the JBoss CLI. For standalone mode:

    # /subsystem=jmx/remoting-connector=jmx/:write-attribute(name=use-management-endpoint,value=false)

Due to a bug in JBoss CLI you cannot set this for domain mode, but you
uncomment the following line from the `full` profile to enable it
(assuming that you are using the default configuration which utilizes the
`full` profile):

    <remoting-connector use-management-endpoint="false"/>

<div class="alert alert-warn"><h4>Restart required</h4>Please note that a JBoss AS restart is required to apply the above change.</div>

#### Connection

Now we're ready to connect to the remote instance. The connection string should look similar to this:

    service:jmx:remoting-jmx://HOST:4447

When you're trying to connect to the second instance of the JBoss AS in
domain mode, you'll need to add the default offset (150) to the port number.

<div class="alert alert-warn"><h4>Classpath entries</h4>This connection type requires the modified classpath changes described above.</div>

In the username and password fields please enter the valid credentials for the
application user you created earlier.

<a rel="remoting" class="picture" href="/images/jmx/jconsole_remoting.png" title="JConsole remoting"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="JConsole remoting" src="/images/jmx/jconsole_remoting.png" /></a>
<a rel="remoting" class="picture" href="/images/jmx/visualvm_remoting.png" title="VisualVM remoting"><img style="width: 30%; border: 1px solid #eee; padding: 5px;" alt="VisualVM remoting" src="/images/jmx/visualvm_remoting.png" /></a>

## Troubleshooting

You may encounter some issues while connecting, please check that:

1. The instance is running and the port you're trying to connect to reachable.
2. Make sure you choose the right port (management vs. remoting).
3. Make sure you made the required changes (if any) to the JBoss AS configuration.

<script type="text/javascript">
    $('.picture').colorbox();
</script>
