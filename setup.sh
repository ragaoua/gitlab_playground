#!/bin/bash

if [ -z "$GITLAB_HOME" ] ; then
    read -p "GITLAB_HOME : " GITLAB_HOME
fi
readonly GITLAB_HOME

if [ -z "$GITLAB_HOST" ] ; then
    read -p "GITLAB_HOST : " GITLAB_HOST
fi
readonly GITLAB_HOST

mkdir ${GITLAB_HOME}/{logs,config,data}
sudo podman run --detach \
   --hostname ${GITLAB_HOST} \
   --env GITLAB_OMNIBUS_CONFIG="external_url 'http://${GITLAB_HOST}'" \
   --publish 443:443 --publish 80:80 --publish 2222:22 \
   --name gitlab \
   --restart always \
   --volume ${GITLAB_HOME}/config:/etc/gitlab:Z \
   --volume ${GITLAB_HOME}/logs:/var/log/gitlab:Z \
   --volume ${GITLAB_HOME}/data:/var/opt/gitlab:Z \
   --shm-size 256m \
   gitlab/gitlab-ce:latest
