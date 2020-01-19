# drone-gcp-deploy
[![Build Status](https://cloud.drone.io/api/badges/viant/drone-gcp-deploy/status.svg)](https://cloud.drone.io/viant/drone-gcp-deploy)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/viant/drone-gcp-deploy/blob/master/LICENSE)

Drone plugin to do blue/green deployments in Google Cloud using a HTTP(S) load balancer with two backend buckets. 

## Setup

Only the Google side you need to setup two buckets with the following naming convention:

* URL_MAP_NAME-blue
* URL_MAP_NAME-green

Then setup a HTTP(S) LB to initial point to either the blue or green bucket

## Usage

The following parameter is required:

* `base64_key` base64 encoded JSON key

* `url_map` the URL map name. This is the name given to the LB during creation.


Optional:

* `source_dir` By default the plugin will copy the contents of the root git directory. Use this to change it to a different directory.

Note the project is pulled from the JSON key.

## Example

```yaml
kind: pipeline
name: default

steps:

- name: website
  image: viant/drone-gcp-deploy
  settings:
    base64_key:
      from_secret: base64_key
    url_map: my-website-name
```
