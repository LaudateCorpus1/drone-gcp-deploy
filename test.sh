#!/bin/bash

BASE64_KEY=`cat keyfile`
URL_MAP="my-website"

docker run -e BASE64_KEY="$BASE64_KEY" -e URL_MAP="$URL_MAP" viant/drone-gcp-deploy
