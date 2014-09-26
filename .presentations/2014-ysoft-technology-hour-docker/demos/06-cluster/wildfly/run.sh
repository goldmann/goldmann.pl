#!/bin/sh

docker run -it --rm --link lb:lb wildfly-cluster-app
