#!/bin/sh

while true; do
  curl -s http://localhost:9090/node-info/ | grep Hostname
  sleep 1
done
