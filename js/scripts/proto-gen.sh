#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

OUT_DIR="./src"

# Path to this plugin, Note this must be an abolsute path on Windows (see #15)
PROTOC_GEN_TS_PROTO_PATH="./node_modules/.bin/protoc-gen-ts_proto"

mkdir -p "$OUT_DIR"

echo "Processing xpla proto files ..."
COSMOS_DIR="../cosmos-sdk/proto"
COSMOS_THIRD_PARTY_DIR="../cosmos-sdk/third_party/proto"
COSMWASM_DIR="../cosmwasm/proto"
ETHER_DIR="../ethermint/proto"
EVMOS_DIR="../evmos/proto"
XPLA_DIR="../xpla/proto"

protoc \
  --plugin="protoc-gen-ts_proto=${PROTOC_GEN_TS_PROTO_PATH}" \
  --ts_proto_out="${OUT_DIR}" \
  --ts_proto_opt="esModuleInterop=true,forceLong=long,useExactTypes=false,outputClientImpl=grpc-web" \
  --proto_path="$COSMOS_DIR" \
  --proto_path="$COSMOS_THIRD_PARTY_DIR" \
  --proto_path="$COSMWASM_DIR" \
  --proto_path="$ETHER_DIR" \
  --proto_path="$EVMOS_DIR" \
  --proto_path="$XPLA_DIR" \
  $(find ${COSMOS_DIR} ${COSMOS_THIRD_PARTY_DIR} ${COSMWASM_DIR} ${ETHER_DIR} ${EVMOS_DIR} ${XPLA_DIR} -path -prune -o -name '*.proto' -print0 | xargs -0)
