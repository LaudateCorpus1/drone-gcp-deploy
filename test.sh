#!/bin/bash

BASE64_KEY=`cat /path/to/base64`

docker run -e BASE64_KEY="$BASE64_KEY" -e URL_MAP="$URL_MAP"
