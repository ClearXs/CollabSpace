#!/bin/bash

VERSION=$(grep VERSION= .env | cut -d '=' -f2)
REGISTRY=$(grep REGISTRY= .env | cut -d '=' -f2)

function build() {
  docker login -u admin -p Harbor12345 192.168.5.201:7080

  # web
  docker build --platform linux/arm64 -t ${REGISTRY}/document-web:${VERSION} .

  docker push ${REGISTRY}/document-web:${VERSION}

  # service
  docker build --platform linux/x86_64 -t ${REGISTRY}/document:${VERSION} .

  docker push ${REGISTRY}/document:${VERSION}
}

function save() {
  docker save ${REGISTRY}/document:${VERSION} > ./document-${VERSION}.tar
  docker save ${REGISTRY}/document-web:${VERSION} > ./document-web-${VERSION}.tar
}

case "$1" in
"build")
  build
  ;;
"save")
  save
  ;;
esac
