#!/bin/bash
nohup redis-server /usr/local/etc/redis.conf > log/redis.log &
nohup sidekiq -C config/sidekiq.yml > log/sidekiq.log &
