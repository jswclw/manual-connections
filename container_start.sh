#!/bin/bash

echo -n "Waiting for network..." 
until curl -s http://google.com >/dev/null
    do echo -n "*"
    sleep 5
done
echo "ready!"

/pia/run_setup.sh

sleep infinity

