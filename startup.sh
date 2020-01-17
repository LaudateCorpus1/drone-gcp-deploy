#!/bin/bash

# Decode key
echo $BASE64_KEY | base64 -d - > /gcloud.json

# Auth with JSON key
if [ -n "$DEBUG" ]
then
    gcloud auth activate-service-account --key-file /gcloud.json 
else
    gcloud auth activate-service-account --key-file /gcloud.json > /dev/null 2>&1
fi
if [[ $? == 0 ]]
then
    echo "JSON auth      : Success"
else
    echo "Unable to auth"
    exit 1 
fi

# Set project
PROJECT=`cat /gcloud.json | jq -r .project_id`
if [ -n "$DEBUG" ]
then
    gcloud config set project $PROJECT
else
    gcloud config set project $PROJECT > /dev/null 2>&1
fi

if [[ $? == 0 ]]
then
    echo "Project set to : $PROJECT"
else
    echo "Unable to set project: $PROJECT"
    exit 1
fi

# Get source dir name or set to current if not given 
if [ -z $SOURCE_DIR ]
then 
  SOURCE_DIR="."
fi

CURRENT_BUCKET=none

# Get current bucket
gcloud compute url-maps describe $URL_MAP | grep -q green
if [ $? -eq 0 ]
then
  CURRENT_BUCKET=green
fi

gcloud compute url-maps describe $URL_MAP | grep -q blue
if [ $? -eq 0 ]
then
  CURRENT_BUCKET=blue
fi

# Exit if can't find bucket
if [ $CURRENT_BUCKET == none ]
then
  echo "Can't find bucket"
  exit 1
fi

# Set to blue if green
if [ $CURRENT_BUCKET == green ]
then
  echo "Blue: $DRONE_BUILD_NUMBER" > $SOURCE_DIR/drone_build_version.html
  echo "Setting bucket to $URL_MAP-blue"
  gsutil -m cp -R $SOURCE_DIR/* gs://$URL_MAP-blue
  gcloud compute url-maps set-default-service $URL_MAP --default-backend-bucket=$URL_MAP-blue
  if [[ $? == 0 ]]
  then
    exit 0
  else
    exit 1
  fi
fi

# Set to green if blue
if [ $CURRENT_BUCKET == blue ]
then
  echo "Green: $DRONE_BUILD_NUMBER" > $SOURCE_DIR/drone_build_version.html
  echo "Setting bucket to $URL_MAP-green"
  gsutil -m cp -R $SOURCE_DIR/* gs://$URL_MAP-green
  gcloud compute url-maps set-default-service $URL_MAP --default-backend-bucket=$URL_MAP-green
  if [[ $? == 0 ]]
  then
    exit 0
  else
    exit 1
  fi
fi
