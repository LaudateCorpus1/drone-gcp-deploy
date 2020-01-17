#!/bin/bash

BASE64_KEY=`cat unison-cloud-admin-base64`
URL_MAP="adelphic-ui"

docker run -e BASE64_KEY="$BASE64_KEY" -e URL_MAP="$URL_MAP" viant/drone-gcp-deploy
