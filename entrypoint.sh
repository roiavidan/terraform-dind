#!/bin/sh

install -m 600 -t /root/.ssh /.ssh/*

exec terraform "$@"