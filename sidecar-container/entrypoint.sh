#!/usr/bin/env bash

set -ueo pipefail

echo -e "$CERT_PEM" > /etc/cloudflared/cert.pem

ORIGIN=http://localhost:3000/login

set +ex

for i in {1..60}
do
  wget $ORIGIN 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Attempt to connect to ${ORIGIN} failed."
    sleep 1
  else
    echo "Connected to origin ${ORIGIN} successfully."
    break
  fi
done

set -ex

cloudflared tunnel
