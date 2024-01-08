# xpla.proto

This project provides code generation from the proto files. 

# submodules

```sh
git submodule add https://github.com/cosmos/cosmos-sdk.git cosmos-sdk
cd cosmos-sdk
git checkout tags/v0.45.16
```

```sh
git submodule add https://github.com/xpladev/xpla.git
cd xpla
git checkout tags/v1.3.1
```

```sh
git submodule add https://github.com/evmos/evmos.git
cd evmos
git checkout tags/v9.1.0
```

```sh
git submodule add https://github.com/evmos/ethermint.git
cd ethermint
git checkout tags/v0.19.3
```

```sh
git submodule add https://github.com/CosmWasm/wasmd.git cosmwasm
cd cosmwasm
git checkout tags/v0.33.0
```

```sh
git submodule add https://github.com/cosmos/ibc-go.git ibc
cd ibc
git checkout tags/v4.5.1
```

# js build

```sh
git submodule init
git submodule update
cd js
npm i
./scripts/proto-gen.sh
npm run build
```

