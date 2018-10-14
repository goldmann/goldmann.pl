#!/bin/sh

sudo chown -R 431:433 configuration
chcon -R -t svirt_sandbox_file_t configuration
