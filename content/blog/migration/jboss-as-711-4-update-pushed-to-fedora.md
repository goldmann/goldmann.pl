---
title: "JBoss AS 7.1.1-4 update pushed to Fedora"
author: "Marek Goldmann"
date: 2012-07-04
tags: [ fedora, jboss_as ]
---

I'm very happy to let you know that I [pushed today a new update](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-4.fc17) for `jboss-as` package to Fedora.

## New stuff

The `7.1.1-4` version **includes a lot of new modules** as well as some design changes, let's go briefly over them.

### Stability

The most important change from a RPM/build stability POV is the move from building *minimalistic* to *default* profile. This let me know to **drop about 60** (sic!) patches from the `jboss-as.spec`.

Since the change wasn't's trivial because it required rebasing and manual merging of previous patches I **hereby ask you for help with testing**. I did my best to eliminate bugs, but... Please install the [new update](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-4.fc17) and check if everything works for you. It is very important that you add karma on that page (remember to log in first!). This package will go into stable **only** if it hits the threshold of 4 positive karma, I'm not going to force push it like I did previously. Keep that in mind and encourage others.

### New subsystem available

New update, new modules added. Mostly OSGi stuff, but also some [Arquillian](http://arquillian.org/) goodness.

* org.jboss.as.modcluster module
* org.jboss.as.jsr77 module
* org.jboss.as.arquillian
* org.jboss.as.osgi
* org.jboss.as.configadmin
* org.jboss.as.spec-api

If you're interested in some of them, please test the integration.

### A few bugs fixed

There were few bugs reported, one was hanging for some time in my queue.

* RHBZ#827571 - jboss-as-cp script is missing argument placeholder for c optarg
* RHBZ#827588 - Create a startup script when creating a new user instance (jboss-as-cp)
* RHBZ#827589 - The user instance create script (jboss-as-cp) should allow a port offset to be specified
* RHBZ#812522 - Add ExampleDS based on H2 database

## How to get it

The simplest way is to wait for the package to hit  Fedora's `updates-testing` repository. This should be done by tomorrow. Remember that you'll need to have `updates-testing` repository enabled on your system. **Do not** install `jboss-as-7.1.1-4` without `updates-testing` enabled and without up to date packages on your system. You have been warned.

## One more thing...

    "Don't mess with coders"

In the early days of packaging JBoss AS into Fedora I had a conversation with [Alexander Kurtakov](http://akurtakov.blogspot.com/) (aka *The Fedora Eclipse Guy*). He told me that he'll take a picture of himself in the JBoss AS t-shirt once the `jboss-as` package hits Fedora repositories. Well, this is now reality, so here is the pic :)

<div style="text-align: center;">
<img style="border: 1px solid #eee; padding: 5px;" alt="Alexander in JBoss AS t-shirt" src="/images/akurtakov_jboss_as.jpg" />
</div>

## Need help?

Feel free to report any bugs in [#fedora-java](irc://irc.freenode.net/fedora-java) IRC channel or [directly in Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&amp;version=17&amp;component=jboss-as).
