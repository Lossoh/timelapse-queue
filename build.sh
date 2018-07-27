#!/bin/bash

GOROOT=$HOME/go/src

set -x
set -e

# Install polymer deps if missing.
if ! [ -x "$(command -v yarn)" ]; then
  echo "Missing yarn. https://yarnpkg.com/lang/en/docs/install"
  exit 1
fi
if ! [ -d "web/node_modules" ]; then
  (cd web && yarn install)
fi

# Compile polymer frontend
if ! [ -x "$(command -v polymer)" ]; then
  echo "Missing polymer CLI. https://www.polymer-project.org/3.0/start/install-3-0"
  exit 1
fi
(cd web && polymer build --js-minify --css-minify --html-minify)

# Generate bindata.go file from polymer output
if ! [ -x "$(command -v polymer)" ]; then
  echo "Missing go-bindata. On ubuntu: sudo apt-get install go-bindata"
  exit 1
fi
go-bindata web/build/default/...

# Build standalone binary with resources embedded
if ! [ -x "$(command -v polymer)" ]; then
  echo "Missing go. https://golang.org/doc/install"
  exit 1
fi
go build
