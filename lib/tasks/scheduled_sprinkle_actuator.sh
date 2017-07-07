#!/bin/bash
# set -vx
#
# change the state of a valve by posting to the server in json
#
# invocation: sh scheduled_sprinkle_actuator.sh scheduled_sprinkle_id sprinkle_id gpio_command http_host 
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
SCHEDULED_SPRINKLE_EVENT_ID=$1
SPRINKLE_ID=$2
VALVE_CMD=$3
HTTP_HOST=$4
/usr/bin/curl -H 'Content-Type: application/json' -X PUT \
    -d '{ \
    "valve_cmd": "'"$VALVE_CMD"'", \
    "sprinkle_id": "'"$SPRINKLE_ID"'" }' \
    http://$HTTP_HOST/scheduled_sprinkle_events/$SCHEDULED_SPRINKLE_EVENT_ID.json


