---
title: "Docker and Fedora"
author: "Marek Goldmann"
date: 2013-09-25
tags: [ fedora, docker ]
---

<img style="padding: 5px; float: left; margin-right: 10px; width: 30%;" alt="WildFly" src="/images/docker.png" />

For the last couple of days I have been playing with
[Docker](https://www.docker.io/). Docker is a project that helps you create
images and run containers. This sounds like virtualization, but it
isn't. It uses [Linux Containers](http://lxc.sourceforge.net/) (LXC) under the
hood to do all the magic. What kind of magic? Read on.

### Linux Containers

The first question you might ask is: *how is Docker/LXC different from virtualization?*

LXC is something between chroot and full virtualization. You don't run your
applications in a virtual machine (inside a process controlled by the
virtualization engine). Instead your applications are run in **isolated** (by the
kernel itself) environments. Processes that run in one container do not have
any access to processes in other containers. From a cointainer POV it looks
like virtualization, but when you look from the host side - you can see all
of the processes (applications) running on the host, directly. I'm pretty new to the
LXC technology, but it's very promising, especially with regards to speed.

The most visible difference between virtualization and LXC for the end user is boot
time. **LXC overhead is literally zero** compared to the few seconds up to
minutes to boot your operating system in a virtualized environment. When you
run a container, it's ready to do the stuff immediately - you don't need to
wait at all.

This single feature is a great reason to take a look at LXC. But there is
also Docker, which is a great extension of what we already have in LXC.

### Hello Docker

Docker builds upon LXC. It uses it to create images and later run and manage
them. What makes Docker especially nice is its lightweight and easy to use. The
good folks at Docker made Ubuntu their distribution of choice, but Fedora isn't
sleeping. Just recently Lokesh Mandvekar created a `docker-io` package and it
was [reviewed and
accepted](https://bugzilla.redhat.com/show_bug.cgi?id=1000662) for Fedora.
It'll take a week or two for it become available in the Fedora 19+ repos. If
you're eager (and brave) - I prepared my own [Docker
repository](http://goldmann.fedorapeople.org/repos/docker/) with RPMs for
Fedora 19, 20 and Rawhide. This repo will become unavailable after the official
Docker RPMs hit Fedora repos.

<div class="alert alert-info"><strong>Fedora 20 host</strong><br/>Please note that I used a Fedora 20 host, but it should work on Fedora 19 too.</div>
<div class="alert alert-info"><strong>Superuser privileges</strong><br/>All commands below should be executed with root privileges.</div>

    curl http://goldmann.fedorapeople.org/repos/docker.repo > /etc/yum.repos.d/docker-goldmann.repo
    yum install docker-io

When the install finishes - start the `docker` systemd service:

    systemctl start docker.service

And if you want to enable it on boot:

    systemctl enable docker.service

Docker should be running now.

### Run your first container

Docker offers a [central repository with images](https://index.docker.io/).
This makes it easy to download (and publish) images. Matthew Miller (Fedora
Cloud Architect) [prepared a Fedora 19
image](https://index.docker.io/u/mattdm/fedora/). This image will be updated to
Fedora 20 once it is released.

Let's grab the `fedora` image:

    $ docker pull mattdm/fedora
    Pulling repository mattdm/fedora
    22a514a5aa4c: Download complete
    50f374c05c2c: Download complete
    97fc5bf7f8d4: Download complete

Done! Now you have the image locally (in `/var/lib/docker`) and you can immediately start a container based on it:

    docker run -i -t mattdm/fedora /bin/bash

Let's look at the parameters:

* `run` - runs a container,
* `-i` - keeps the stdin open, even if there is nothing attached,
* `-t` - allocates a pseudo terminal, so we can interact with the container directly,
* `mattdm/fedora` - ID of the image, it can be a tag or a hash (`22a514a5aa4c` in this case),
* `/bin/bash` - the command to run after the container boots.

After you run the command, you'll be greeted by the bash prompt from inside the
container, where you can do whatever you want. There are different types of
images, some of them have an [entry
point](http://docs.docker.io/en/latest/use/builder/#id12), some not. I hope to
discuss this further in a different blog post.

    $ docker run -i -t mattdm/fedora /bin/bash
    bash-4.2#

If you see an error similar to this, try again.

    2013/09/25 13:22:02 Error: Error starting container 4b9cdcc43f43: fork/exec /usr/bin/unshare: operation not permitted

This is a known bug and I hope it will be fixed soon.

#### Basic container management

To stop the container, just press `CTRL+D`. Please note that the container is
now stopped, but that does not mean that it no longer exists. Stopped container
can be started or removed.

To remove a stopped container you need to know the container ID. You can see it
by using the `docker ps` command. By default the `docker ps` command will show
only running containers. To see all containers (including stopped) run `docker
ps -a`:

    $ docker ps -a
    ID                  IMAGE                  COMMAND                CREATED             STATUS              PORTS
    15bd697c7174        mattdm/fedora:latest   /bin/bash              22 minutes ago      Exit 0                                  
    5ab7c7a95885        mattdm/fedora:latest   /bin/bash              23 minutes ago      Exit 0                                  
    4b9cdcc43f43        mattdm/fedora:latest   /bin/bash              23 minutes ago      Exit 0                                  
    0fdab01e4eaa        mattdm/fedora:latest   /bin/bash              24 minutes ago      Exit 0                                  

Now you can remove the container by executing the `docker rm` command and
specifying the ID, for example `docker rm 15bd697c7174`. The `15bd697c7174`
container is now gone.

#### Network connectivity

By default Fedora disables IP forwarding which will prevent you from accessing
the Internet from inside of the container. In most (all?) cases **this is not
what you want**. To enable IP forwarding you can run this command:

    sysctl -w net.ipv4.ip_forward=1

After restarting, forwarding will be disabled again. To make it persistent,
create a `/etc/sysctl.d/80-docker.conf` file and put the following line in it:

    net.ipv4.ip_forward = 1

There is an [open bug](https://bugzilla.redhat.com/show_bug.cgi?id=1011680) to
fix this in Fedora.

### Build your first image

What we have done so far is run an image made by someone else. Let's create our
own image now.

Docker uses plain text files to describe the image which can contain [various
commands](http://docs.docker.io/en/latest/use/builder/). To build an image,
let's create an empty directory and place a file in it called `Dockerfile` with
following content:

    # Base on the Fedora image created by Matthew
    FROM mattdm/fedora

    # Install the JBoss Application Server 7
    RUN yum install -y jboss-as

    # Run the JBoss AS after the container boots
    ENTRYPOINT /usr/share/jboss-as/bin/launch.sh standalone standalone.xml 0.0.0.0

The [`FROM`](http://docs.docker.io/en/latest/use/builder/#from) command is
required and tells Docker which image should be used as a base for our new
image.

The [`RUN`](http://docs.docker.io/en/latest/use/builder/#run) command is used
to modify the image by running a command inside the container *at the time of
building it*.

The [`ENTRYPOINT`](http://docs.docker.io/en/latest/use/builder/#entrypoint)
command specifies which command should be executed after the container fully
boots.

The next step is to build the image itself. In the directory execute the
`docker build .` command:

    $ docker build .
    Uploading context 10240 bytes
    Step 1 : FROM mattdm/fedora
     ---> 22a514a5aa4c
     Step 2 : RUN yum install -y jboss-as
      ---> Running in 4e4d90823207
      Resolving Dependencies
      --> Running transaction check
      ---> Package jboss-as.noarch 0:7.1.1-21.fc19 will be installed
      --> Processing Dependency: wss4j >= 1.6.7 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: wsdl4j >= 1.6.2-5 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: resteasy >= 2.3.2-7 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: mod_cluster-java >= 1.2.1-2 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: jython >= 2.2.1-9 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: jbossws-spi >= 2.1.0 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: jbossws-native >= 4.1.0 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: jbossws-cxf >= 4.1.0 for package: jboss-as-7.1.1-21.fc19.noarch
      --> Processing Dependency: jbossws-common >= 2.0.4-3 for package: jboss-as-7.1.1-21.fc19.noarch

    [....SNIP...]

      xpp3.noarch 0:1.1.3.8-8.fc19
      xpp3-minimal.noarch 0:1.1.3.8-8.fc19
      xsom.noarch 0:0-9.20110809svn.fc19
      xstream.noarch 0:1.3.1-5.fc19
      zip.x86_64 0:3.0-7.fc19

    Complete!
     ---> fafccbe2bffc
    Step 3 : ENTRYPOINT /usr/share/jboss-as/bin/launch.sh standalone standalone.xml 0.0.0.0
     ---> Running in 055d264ab953
     ---> 366ff524eea0
    Successfully built 366ff524eea0

Please note that after every command Docker **commits the changes** (in a manner similar
to Git). Future executions of the same command will use the cached result.

Now if we run `docker run -i -t 366ff524eea0` (please note that we don't
specify the `/bin/bash` command, since our image has an entry point and it will
be executed for us) we'll see JBoss AS booting:

    $ docker run -i -t 366ff524eea0
    =========================================================================

      JBoss Bootstrap Environment

      JBOSS_HOME: /usr/share/jboss-as

      JAVA: java

    [...SNIP...]

    13:28:15,433 WARN  [org.jboss.as.domain.http.api] (MSC service thread 1-4) JBAS015102: Unable to load console module for slot main, disabling console
    13:28:15,442 INFO  [org.jboss.as.server.deployment.scanner] (MSC service thread 1-1) JBAS015012: Started FileSystemDeploymentService for directory /usr/share/jboss-as/standalone/deployments
    13:28:15,520 INFO  [org.jboss.as.connector.subsystems.datasources] (MSC service thread 1-2) JBAS010400: Bound data source [java:jboss/datasources/ExampleDS]
    13:28:15,552 INFO  [org.jboss.as] (Controller Boot Thread) JBAS015951: Admin console listening on http://127.0.0.1:9990
    13:28:15,553 INFO  [org.jboss.as] (Controller Boot Thread) JBAS015874: JBoss AS 7.1.1.Final "Brontes" started in 2328ms - Started 133 of 208 services (74 services are passive or on-demand)

That's it, JBoss AS is running.

### What's next

I highly recommend the try-and-fail method. Read the [Docker
docs](http://docs.docker.io/en/latest/), try to build your own images. In
future blog posts I'll get a bit more into Docker details (and we'll build a cluster).

Hope you enjoyed this quick ride with Docker and Fedora!
