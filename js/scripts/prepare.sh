#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

DIRS="amino cosmos cosmos_proto cosmwasm ethermint gogoproto google ibc offchain tendermint xpla"

for dir in $DIRS; do
  rm -rf "$dir"
  cp -R "./build/$dir" ./
done

FILES=""

for file in $FILES; do
  rm -f $file
  cp ./build/$file ./
done

