---
title: "WildFly is approaching Fedora"
author: "Marek Goldmann"
layout: blog
timestamp: 2013-09-18t11:15:00.10+02:00
tags: [ jboss_as, fedora, wildfly ]
---

In April 2013 the [JBoss Application Server rename to
WildFly](https://community.jboss.org/blogs/mark.little/2013/04/19/and-the-winner-is)
was announced at Devoxx. Since then the [WildFly](http://wildfly.org/) team
made a couple of Alpha releases. They all start with version `8.0.0` to
highlight the fact that WildFly is the successor of JBoss AS.

<img style="padding: 5px; float: left; margin-right: 10px; width: 60%;" alt="WildFly" src="/images/wildfly.png" />

Immediately after the first release of WildFly I've started to think about
getting it into [Fedora](http://fedoraproject.org/).

A few days ago I finished upgrading all required components and finally
packaged `Alpha3` version of WildFly. It's already available in Rawhide and in
[Fedora 20
updates-testing](https://admin.fedoraproject.org/updates/FEDORA-2013-16408)
repository.

#### Changes

As you can imagine the name change triggered some changes to the Fedora
`jboss-as` package. The most visible one is the package rename. In Fedora 20+
the `jboss-as` package **is replaced** with `wildfly`. Other than dependencies
upgrade and some scripts name changes nothing was dramatically changed - you
can still expect thing to work as you're used to.

If you hit any issues - please [let me
know](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&component=wildfly)!

Of course WildFly is a brand new application server with some new great features
like Java EE 7 support, so do not forget to test your new apps on it!

Today I [submitted a new update for Fedora
20](https://admin.fedoraproject.org/updates/wildfly-8.0.0-0.9.Alpha4.fc20) that
includes the `Alpha4` version. It fixes also a few bugs reported to me
(thanks!). I personally feel that this update is pretty stable. Give it a shot
and don't forget to bump the karma!

#### The future

The plan is simple - package the most recent version of WildFly and make it
available in the shortest period of time after the upstream release. With the
Fedora 20 Final release approaching ([planned
2013.11.19](http://fedoraproject.org/wiki/Releases/20/Schedule)) - I'm going to
make everything possible to package `8.0.0.Final` before so Fedora 20 can ship
stable version of WildFly since the beginning. This will be a *very* tough task
since the release dates are [very close to each
other](https://issues.jboss.org/browse/WFLY#selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel).
If not - the `8.0.0.Final` will be a 0-day update.
