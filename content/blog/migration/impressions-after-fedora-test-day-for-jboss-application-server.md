---
title: "Impressions after Fedora Test Day for JBoss Application Server"
author: "Marek Goldmann"
date: 2012-04-18
tags: [ fedora, jboss_as ]
---

[Yesterday](/blog/2012/04/17/jboss-as-fedora-test-day-today/) we had JBoss AS Test Day. Since the early morning hours we received help with testing the [RPM packaged](http://fedoraproject.org/wiki/JBossAS7) [JBoss AS](http://www.jboss.org/jbossas).

And what's the general impression?

**It works!**

Almost all [test cases we prepared](https://fedoraproject.org/wiki/Test_Day:2012-04-17_JBoss_Application_Server#Test_Cases) were successfully finished by our community members. We found one issue with not preserving the permission on files when adding new users to JBoss AS management interface. I've created a fix for that and [sent a pull request](https://github.com/jbossas/jboss-as/pull/2067). Expect to have it fixed in `jboss-as-7.1.0-4` package.

Other than that - we haven't found any issues with running AS7 on Fedora. Which is obviously good. But if you find some, please [report them imemdiately](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&version=17&component=jboss-as) as we want to have a great platform for developers.

> Please note that the shipped AS is not a full AS7 you can [download from the website](http://www.jboss.org/jbossas/downloads/). It is a web profile, but lacking the [JPA2 implementation](http://hibernate.org/). We're working *really hard* on extending it.

Thanks to all testers for a **good job**!
