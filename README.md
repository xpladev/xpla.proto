# xpla.proto

This project provides code generation from the proto files. 

# prerequisite

install protoc

```sh
sudo apt install -y protobuf-compiler
```

# submodules

```sh
git submodule add https://github.com/gogo/googleapis.git googleapis
cd googleapis
git checkout tags/v1.4.1
cd ..
```

```sh
git submodule add https://github.com/cosmos/gogoproto.git gogoproto
cd gogoproto
git checkout tags/v1.7.0
cd ..
```

```sh
git submodule add https://github.com/cosmos/cosmos-proto.git cosmos-proto
cd cosmos-proto
git checkout tags/v1.0.0-beta.5
cd ..
```

Note: Although XPLA is on CosmWasm v0.60.1, we are using the v0.55.1 tag.
This is because the protos are the same as in v0.55.1, and the v0.60.1 tag is not available for checkout.
```sh
git submodule add https://github.com/CosmWasm/wasmd.git cosmwasm
cd cosmwasm
git checkout tags/v0.55.1
cd ..
```

```sh
git submodule add https://github.com/cosmos/ics23.git ics23
cd ics23
git checkout tags/go/v0.11.0
cd ..
```

```sh
git submodule add https://github.com/cosmos/ibc-go.git ibc
cd ibc
git checkout tags/v10.3.0
cd ..
```

Remove the existing ethermint proto.
For backward compatibility, use the protos from the `/legacy/ethermint/proto` directory in the `xpla` module.
```sh
git rm ethermint
```

```sh
git submodule add https://github.com/cosmos/evm.git evm
cd evm
git checkout tags/v0.3.0
cd ..
```

```sh
git submodule add https://github.com/cosmos/cosmos-sdk cosmos-sdk
cd cosmos-sdk
git checkout tags/v0.53.4
cd ..
```

```sh
git submodule add https://github.com/xpladev/xpla.git xpla
cd xpla
git checkout tags/v1.8.0-rc0
cd ..
```

# common
```sh
git submodule update --init --recursive
```

# js build

```sh
cd js
npm i
./scripts/proto-gen.sh
npm run build
```

# swift build

```sh
cd swift
./scripts/proto-gen.sh
```