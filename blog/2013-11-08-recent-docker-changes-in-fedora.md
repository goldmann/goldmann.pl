---
title: "Recent Docker changes in Fedora"
author: "Marek Goldmann"
layout: blog
timestamp: 2013-11-08t15:00:00.10+01:00
tags: [ fedora, docker ]
---

Lokesh, the `docker-io` package maintainer at Fedora, does a damn good job at
keeping it up to date. I think it's a good time to see what changed over the
last weeks in the Docker-Fedora world.

### Why Docker is still not available in Fedora?

##### Simple answer

There are some technical issues to overcome :)

##### Longer answer

The most important blocker  is lack of [AUFS](http://aufs.sourceforge.net/)
support in the kernel (upstream as well as Fedora's and RHEL's). Alex Larsson
is working on a replacement for AUFS using devicemapper. You can read more
about this work in a nice [blog
post](http://community.redhat.com/adventures-in-dockerland/) where Alex is
covering this area.

If you're interested in the actual code, please look at the [`dm`
branch](https://github.com/dotcloud/docker/tree/dm) in the official [Docker
GitHub repo](https://github.com/dotcloud/docker).

### Not yet in the official repos

At least not for Fedora 19 and 20. In Rawhide we do have a `docker-io` package
avaialable, but Rawhide is intended for testing, and this is what we do now
with the `docker-io` package. Additionally we agreed with upstream to **not push Docker
to Fedora repos before the `0.7.0` release**. This is very closely related to
Alex's work on devicemapper. We do not want to make avialable half-backed
solutions.

Please be patient.

<div class="alert alert-info"><strong>Updated repo</strong><br/>Today I've updated <a href="http://goldmann.fedorapeople.org/repos/docker.repo">my repository</a>. It contains the latest <code>0.7-0.13.dm</code> version of <code>docker-io</code> package.</div>

But if you really want to get your hands dirty with the latest version - use
[my repository](http://goldmann.fedorapeople.org/repos/docker.repo). You can of
course help with testing and by [reporting
bugs](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&component=docker-io)
you see, we appreciate it.

### Only 64 bit

This is **not** a Fedora choice, but it's [forced by
upstream](https://github.com/dotcloud/docker/issues/136). Docker currently
**works only on 64 bit** architectures, so there won't be any build for other
archs (including `i386` and `arm`), at least for now. I'm not sure where the
root of this problem lies, but I'll do some research over then next few days.

This is a quite big issue, since it technically prevents us from adding Docker
to Fedora, since all packages should be available on all supported
architectures.

I hope at that *should* is the key word here.

### Changes

Some other important changes made from `0.6.3-2.devicemapper` to `0.7-0.13.dm`.

1. Networking issues when accessing servers from an instance are now resolved.
Appropriate iptables rules are now created when starting the docker service.

2. The `docker -v` commands prints now correct version information.

3. If you're using zsh - you have now completion enabled!

