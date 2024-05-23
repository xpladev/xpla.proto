#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

OUT_DIR="./src"

# Path to this plugin, Note this must be an abolsute path on Windows (see #15)
PROTOC_GEN_TS_PROTO_PATH="./node_modules/.bin/protoc-gen-ts_proto"

mkdir -p "$OUT_DIR"

echo "Processing xpla proto files ..."
THIRD_PARTY_DIRS=("../googleapis/google" "../gogoproto/gogoproto" "../cosmos-proto/proto/cosmos_proto" "../cosmwasm/proto/cosmwasm" "../ics23/proto/cosmos" "../ethermint/proto/ethermint")
COSMOS_DIR="../cosmos-sdk/proto"
IBC_DIR="../ibc/proto"
XPLA_DIR="../xpla/proto"
OFFCHAIN_DIR="../offchain/proto"

mkdir -p ../proto
pushd ../proto
rm -f *
for dir in "${THIRD_PARTY_DIRS[@]}"; do
  ln -sf $dir ${dir##*\/}
done
popd

protoc \
  --plugin="protoc-gen-ts_proto=${PROTOC_GEN_TS_PROTO_PATH}" \
  --ts_proto_out="${OUT_DIR}" \
  --ts_proto_opt="esModuleInterop=true,forceLong=long,useExactTypes=false,outputClientImpl=grpc-web" \
  --proto_path="$COSMOS_DIR" \
  --proto_path="$IBC_DIR" \
  --proto_path="$XPLA_DIR" \
  --proto_path="$OFFCHAIN_DIR" \
  --proto_path="../proto" \
  $(find -L ${COSMOS_DIR} ${IBC_DIR} ${XPLA_DIR} ${OFFCHAIN_DIR} ../proto -path -prune -o -name '*.proto' -print0 | xargs -0)

#rm -f ../proto/*
#rmdir ../proto