#!/bin/sh

mkdir log
sudo chown 431:433 log
chcon -t svirt_sandbox_file_t log
