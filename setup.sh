#!/bin/sh

# this script preps .env for docker-compose.yml

# rails wants a 32-byte key
railskeygen () {
    tr -dc a-f0-9 < /dev/urandom | head -c 32; echo
}

# if uuidgen does not exist, implement something similar
if [ -z "$(which uuidgen)" ]; then
  uuidgen () {
    tr -dc A-Za-z0-9 < /dev/urandom | head -c 40; echo
  }
fi

PG_PASS=$(uuidgen)
PG_USER=ratebeer
PG_DB=ratebeer

echo "\
# This file is read by docker-compose.yml

BEERMAPPING_APIKEY=_INSERT_YOUR_KEY_HERE_
WEATHER_APIKEY=_INSERT_YOUR_KEY_HERE_

RAILS_MASTER_KEY=$(railskeygen)
DATABASE_URL=postgresql://${PG_USER}:${PG_PASS}@db/${PG_DB}

POSTGRES_PASSWORD=${PG_PASS}
POSTGRES_USER=${PG_USER}
POSTGRES_DB=${PG_DB}
POSTGRES_DATA=./pg_data
" > .env
