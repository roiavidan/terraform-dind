#!/bin/sh

[ -d /.ssh ] && busybox install -m 600 -t /root/.ssh /.ssh/*

exec terraform "$@"
