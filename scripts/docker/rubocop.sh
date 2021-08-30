#!/bin/bash

set -eu
cd ./

NETCAT="nc -N" # Remove the -N if you not using Linux
DAEMON_DIR="tmp/rubocop-daemon"

COMMAND="$(cat $DAEMON_DIR/token) /app exec $@"

STDIN_CONTENT="$(cat)"

printf '%s\n%s\n' "$COMMAND" "$STDIN_CONTENT" | $NETCAT 127.0.0.1 $(cat $DAEMON_DIR/port)

exit $(cat $DAEMON_DIR/status)