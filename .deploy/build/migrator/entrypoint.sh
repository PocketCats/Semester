#!/bin/bash

trap 'echo "Received SIGTERM, shutting down..."; exit 0' SIGTERM SIGINT

while true; do
    sleep 3
done
