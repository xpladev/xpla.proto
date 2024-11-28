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

```sh
git submodule add https://github.com/CosmWasm/wasmd.git cosmwasm
cd cosmwasm
git checkout tags/v0.53.0
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
git checkout tags/v8.4.0
cd ..
```

```sh
git submodule add https://github.com/xpladev/ethermint.git
cd ethermint
git checkout tags/v0.24.0-xpla-rc3
cd ..
```

```sh
git submodule add https://github.com/cosmos/cosmos-sdk.git cosmos-sdk
cd cosmos-sdk
git checkout tags/v0.50.10
cd ..
```

```sh
git submodule add https://github.com/xpladev/xpla.git xpla
cd xpla
git checkout tags/v1.7.0-rc2
cd ..
```

# js build

```sh
git submodule update --init --recursive
cd js
npm i
./scripts/proto-gen.sh
npm run build
```
