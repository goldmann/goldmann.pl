#!/bin/sh

mkdir log
# sudo chown 1000:1000 log
chcon -t svirt_sandbox_file_t log
