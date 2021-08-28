#!/bin/bash
set -e

if [ -z "${ENVIRONMENT}" ]; then
    echo "Tipo de Ambiente: DEV"
    echo "Variável CORE_BASE: ${CORE_BASE}"

    echo "> Migrating Database"
    bundle exec rake db:prepare

    echo "> Migrating Test Database"
    bundle exec rails db:create RAILS_ENV=test
    bundle exec rails db:migrate RAILS_ENV=test

    if [ -n "${CORE_BASE}" ]
    then
        echo "> Populating Database with core_base true"
        bundle exec rails db:seed core_base=true
        apt-get install nano
    else
        echo "> Populating Database"
        bundle exec rails db:seed
    fi

    echo "> Clear tmp"
    rm -f /app/tmp/pids/server.pid
    rm -rf /app/tmp/cache/assets/sprockets/

    # bundle exec rake cache:fetch

    echo "> Running server"
    rdebug-ide --debug --skip_wait_for_start --host 0.0.0.0 --port 3001 --dispatcher-port 3001 -- bin/rails server -b 0.0.0.0 -p 3000
else
    echo "Tipo de Ambiente: ${ENVIRONMENT}"
    rm -rf /app/tmp/cache/assets/sprockets/
fi
