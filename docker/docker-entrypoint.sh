#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Waiting for MySQL to start..."
while ! nc -z database 3306; do sleep 0.1; done
echo "MySQL is up"

exec bundle exec "$@"
