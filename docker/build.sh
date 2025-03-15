#!/bin/bash

VERSION=$(grep VERSION= .env | cut -d '=' -f2)
REGISTRY=$(grep REGISTRY= .env | cut -d '=' -f2)

function build() {
  # web
  docker build --platform linux/arm64 -t ${REGISTRY}/document-web:${VERSION} .
  # service
  docker build --platform linux/x86_64 -t ${REGISTRY}/office-service:${VERSION} .
}

function save() {
  docker save ${REGISTRY}/document:${VERSION} >./document-${VERSION}.tar
  docker save ${REGISTRY}/document-web:${VERSION} >./document-web-${VERSION}.tar
}

case "$1" in
"build")
  build
  ;;
"save")
  save
  ;;
esac
