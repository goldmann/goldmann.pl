---
title: "JBoss projects as Docker images"
date: 2014-07-08T16:25:00.10+01:00
draft: false
tags: [ docker, jboss ]
---

[I recently
announced the availability](https://twitter.com/marekgoldmann/status/474867431736082432) of the official [WildFly](http://wildfly.org/)
Docker image. Since then, [our
portfolio of images has grown a bit](https://hub.docker.com/u/jboss/) - as of today, we have 8 images. But this
is not the end. We want to have **a nice collection** of JBoss projects shipped as
Docker images.

## Automated builds

All of our images are hooked up to
[automated builds](https://docs.docker.com/docker-hub/builds/). When we push
an update to [the repository](https://github.com/jboss/dockerfiles), a new
image will be created and pushed to the global registry. I also set up links
between the images so if a base image is updated, our dependent images will be
rebuilt. This is a fully **automated** process that ensures you get the latest
available software.

## Docker microsite

Today I’m happy to announce the [Docker dedicated microsite on jboss.org](http://www.jboss.org/docker/).

[![JBoss Docker microsite](/images/jboss-docker-microsite.png)](http://www.jboss.org/docker/)

We crafted the <http://jboss.org/docker> website to show, in one place,
all the images we currently ship. It additionally provides basic
information about each project and detailed information about each
image.

Of course, the list of all repositories is also available from [hub.docker.com](https://registry.hub.docker.com/repos/jboss/)!

## Help us to help you!

We’re happy to add new images! You can even help us by
[opening a pull request](https://github.com/jboss/dockerfiles/pulls) or just
[let us know](https://github.com/jboss/dockerfiles/issues) what projects you
would like to see in the portfolio. Do not hesitate to create bug reports (if
you find any) too!
