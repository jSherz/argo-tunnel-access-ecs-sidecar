#!/usr/bin/env bash

set -uexo pipefail

docker build -t grafana-tunnel-sidecar .

REPOSITORY_URL=$(
  aws ecr \
    describe-repositories \
    --repository-names grafana-tunnel-sidecar \
    --query "repositories[0].repositoryUri" \
    --output text
)

docker tag grafana-tunnel-sidecar:latest ${REPOSITORY_URL}:latest
docker push ${REPOSITORY_URL}:latest
