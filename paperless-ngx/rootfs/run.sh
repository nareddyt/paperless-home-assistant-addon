#!/usr/bin/env bashio
# shellcheck disable=SC2086

#start redis
redis-server --daemonize yes

# Replace env
PAPERLESS_FILENAME_FORMAT=$(bashio::config 'filename')
PAPERLESS_OCR_LANGUAGE=$(bashio::config 'language')
PAPERLESS_OCR_LANGUAGES=$(bashio::config 'language_packages')
PAPERLESS_ADMIN_USER=$(bashio::config 'default_superuser.username')
PAPERLESS_ADMIN_MAIL=$(bashio::config 'default_superuser.email')
PAPERLESS_ADMIN_PASSWORD=$(bashio::config 'default_superuser.password')
PAPERLESS_TIME_ZONE=$(bashio::info.timezone)
PAPERLESS_CONSUMPTION_DIR=/share/paperless/consume
PAPERLESS_DATA_DIR=/share/paperless/data
PAPERLESS_MEDIA_ROOT=/share/paperless/media

#This set the URL of paperless
if bashio::config.has_value 'url'; then
  PAPERLESS_URL=$(bashio::config 'url')
  bashio::log.info "Use custom defined URL $PAPERLESS_URL"
else
  PAPERLESS_URL="http://"+$(bashio::info.hostname)+":8000"
fi

export PAPERLESS_URL
export PAPERLESS_FILENAME_FORMAT
export PAPERLESS_OCR_LANGUAGE
export PAPERLESS_OCR_LANGUAGES
export PAPERLESS_ADMIN_USER
export PAPERLESS_ADMIN_MAIL
export PAPERLESS_ADMIN_PASSWORD
export PAPERLESS_TIME_ZONE
export PAPERLESS_CONSUMPTION_DIR
export PAPERLESS_DATA_DIR
export PAPERLESS_MEDIA_ROOT

mkdir -p $PAPERLESS_CONSUMPTION_DIR
mkdir -p $PAPERLESS_DATA_DIR
mkdir -p $PAPERLESS_MEDIA_ROOT

chown -R paperless:paperless /usr/src/paperless

/sbin/docker-entrypoint.sh $1