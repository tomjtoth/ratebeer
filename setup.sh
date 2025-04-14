#!/bin/sh

# if uuidgen does not exist, implement something similar
if [ -z "$(which uuidgen)" ]; then
  uuidgen () {
    tr -dc A-Za-z0-9 < /dev/urandom | head -c 40; echo
  }
fi

PG_PASS=$(uuidgen)
PG_USER=beer-rater
PG_DB=ratebeer

echo "\
# This file is read by docker-compose.yml

BEERMAPPING_APIKEY=_INSERT_YOUR_KEY_HERE_
WEATHER_APIKEY=_INSERT_YOUR_KEY_HERE_

RAILS_MASTER_KEY=$(uuidgen)
DATABASE_URL=postgresql://${PG_USER}:${PG_PASS}@db/${PG_DB}

POSTGRES_PASSWORD=${PG_PASS}
POSTGRES_USER=${PG_USER}
POSTGRES_DB=${PG_DB}
POSTGRES_DATA=./pg_data
" > .env
