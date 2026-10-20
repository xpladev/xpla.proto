#!/usr/bin/env bash
set -euo pipefail

JS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(cd -- "$JS_DIR/.." && pwd)"
PLUGIN="$JS_DIR/node_modules/.bin/protoc-gen-ts_proto"
command -v protoc >/dev/null
[[ -x "$PLUGIN" ]] || { echo 'Run npm ci in js before generating.' >&2; exit 1; }

# Include roots and input directories are separate to avoid generating upstream tests.
ROOTS=(
  cosmos-sdk/proto ibc/proto xpla/proto offchain/proto
  ics23/proto evm/proto googleapis gogoproto cosmos-proto/proto
  cosmwasm/proto xpla/legacy/ethermint/proto
  ibc-apps/middleware/packet-forward-middleware/proto
  ibc-apps/modules/rate-limiting/proto
)
INPUTS=(
  cosmos-sdk/proto ibc/proto xpla/proto offchain/proto
  ics23/proto/cosmos/ics23 evm/proto/cosmos/evm googleapis/google gogoproto/gogoproto
  cosmos-proto/proto/cosmos_proto cosmwasm/proto/cosmwasm xpla/legacy/ethermint/proto
  ibc-apps/middleware/packet-forward-middleware/proto
  ibc-apps/modules/rate-limiting/proto
)
ARGS=()
for dir in "${ROOTS[@]}"; do
  [[ -d "$ROOT_DIR/$dir" ]] || { echo "Missing submodule proto directory: $dir" >&2; exit 1; }
  ARGS+=("--proto_path=$ROOT_DIR/$dir")
done
SOURCES=()
for dir in "${INPUTS[@]}"; do
  SOURCES+=("$ROOT_DIR/$dir")
done

TEMP_DIR="$(mktemp -d "$JS_DIR/.proto-gen.XXXXXX")"
trap 'rm -rf -- "$TEMP_DIR"' EXIT
mkdir "$TEMP_DIR/src"
# Preserve filenames, sort deterministically, and propagate find/sort failures.
find "${SOURCES[@]}" -type f -name '*.proto' -print0 | sort -z > "$TEMP_DIR/inputs"
mapfile -d '' -t FILES < "$TEMP_DIR/inputs"
((${#FILES[@]})) || { echo 'No proto input files found.' >&2; exit 1; }
protoc \
  "--plugin=protoc-gen-ts_proto=$PLUGIN" \
  "--ts_proto_out=$TEMP_DIR/src" \
  --ts_proto_opt=esModuleInterop=true,forceLong=string,useExactTypes=false,outputClientImpl=grpc-web,useDate=false,useJsonTimestamp=raw \
  "${ARGS[@]}" "${FILES[@]}"

# A failed generation must leave the last usable sources intact.
rm -rf -- "$JS_DIR/src"
mv -- "$TEMP_DIR/src" "$JS_DIR/src"
