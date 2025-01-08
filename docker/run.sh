#!/bin/bash

set -a
. .env
set +a

check_image_exist() {
        local image_name=$1
        if docker image inspect "$image_name" >/dev/null 2>&1; then
                return 0
        else
                return 1
        fi
}

## stopping current running container
COUNT=$(docker-compose ps -q | wc -l)
if [ "$COUNT" -gt 0 ]; then
        docker-compose down
fi

## remove exist office service images
office_service_name="$REGISTRY"/office-service:"$VERSION"
if check_image_exist "$office_service_name"; then
        docker rmi "$office_service_name"
fi

office_web_name="$REGISTRY"/office-web:"$VERSION"
if check_image_exist "$office_web_name"; then
        docker rmi "$office_web_name"
fi

## run
docker-compose up -d
