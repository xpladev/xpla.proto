#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

OUT_DIR="./proto"

mkdir -p "$OUT_DIR"

echo "Processing xpla proto files ..."
THIRD_PARTY_DIRS=("../googleapis/google" "../gogoproto/gogoproto" "../cosmos-proto/proto/cosmos_proto" "../cosmwasm/proto/cosmwasm" "../ics23/proto/cosmos" "../ethermint/proto/ethermint" "../ethermint/proto/evmos")
COSMOS_DIR="../cosmos-sdk/proto"
IBC_DIR="../ibc/proto"
XPLA_DIR="../xpla/proto"
OFFCHAIN_DIR="../offchain/proto"
TX_DIR="../tx/proto"

mkdir -p ../proto
pushd ../proto
rm -rf *
for dir in "${THIRD_PARTY_DIRS[@]}"; do
  ln -sf $dir ${dir##*\/}
done
popd

protoc \
  --swift_opt=Visibility=Public \
  --swift_opt=FileNaming=PathToUnderscores \
  --swift_out="$OUT_DIR" \
  --proto_path="$COSMOS_DIR" \
  --proto_path="$IBC_DIR" \
  --proto_path="$XPLA_DIR" \
  --proto_path="$OFFCHAIN_DIR" \
  --proto_path="$TX_DIR" \
  --proto_path="../proto" \
  $(find -L ${COSMOS_DIR} ${IBC_DIR} ${XPLA_DIR} ${OFFCHAIN_DIR} ${TX_DIR} ../proto -path -prune -o -name '*.proto' -print0 | xargs -0)

echo "✅ finsihed proto generation"

CODEC_FILE="./proto/codec.swift"

# codec.swift file generate
echo "import SwiftProtobuf" > "$CODEC_FILE"
echo "" >> "$CODEC_FILE"
echo "public func registerAllMessages() {" >> "$CODEC_FILE"

# find Msg struct and generate register code
grep -rhE "public struct [A-Za-z0-9_]+_Msg[A-Za-z0-9_]*: (@unchecked )?Sendable" "$OUT_DIR" | \
    awk '{print $3}' | \
    sed 's/:$//' | \
    grep -v "Response$" | \
    sed 's/^/    Google_Protobuf_Any.register(messageType: /; s/$/.self)/' >> "$CODEC_FILE"
echo "}" >> "$CODEC_FILE"

echo "✅ finsihed generating codec.swift"