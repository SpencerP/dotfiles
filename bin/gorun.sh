#!/usr/bin/env bash

GOOS=$(go env GOOS)
GOARCH=$(go env GOARCH)
if [ $# -lt 1 ]; then
    echo "Usage: gorun [pkg1, ...] <main.go> [arg1, ...]"
    exit 1
fi

set -e
set -x

# create dirs
mkdir -p dist
mkdir -p pkg

# build given packages
until [[ $1 =~ \.go$ ]]; do
    echo "Building $1..."
    GOPATH=$PWD:$GOPATH go build -o pkg/"$GOOS"_"$GOARCH"/$1.a $1
    shift
done

main=$1
shift

# build main and run it with args
GOPATH=$PWD:$GOPATH go build -o dist/${main/.go/} $main && dist/${main/.go/} $*
