#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

DIRS="cosmos cosmos_proto cosmwasm ethermint evmos gogoproto google ibc tendermint xpla offchain"

for dir in $DIRS; do
  rm -rf "$dir"
  cp -R "./build/$dir" ./
done

FILES="proofs.*"

for file in $FILES; do
  rm -f $file
  cp ./build/$file ./
done

