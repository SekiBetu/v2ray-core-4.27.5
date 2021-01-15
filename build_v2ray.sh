#!/bin/bash

cur_dir="$(pwd)"

COMMANDS=( git go )
for CMD in "${COMMANDS[@]}"; do
    if [ ! "$(command -v "${CMD}")" ]; then
        echo "${CMD} is not installed, please install it and try again" && exit 1
    fi
done

cd ${cur_dir}
git clone https://github.com/SekiBetu/v2ray-core.git
cd v2ray-core || exit 2

echo "Building v2ray_linux_amd64 and v2ctl_linux_amd64"
env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -ldflags "-s -w" -o ${cur_dir}/v2ray_linux_amd64 ./main
env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -ldflags "-s -w" -tags confonly -o ${cur_dir}/v2ctl_linux_amd64 ./infra/control/main

echo "Building v2ray_linux_arm64 and v2ctl_linux_arm64"
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -ldflags "-s -w" -o ${cur_dir}/v2ray_linux_arm64 ./main
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -ldflags "-s -w" -tags confonly -o ${cur_dir}/v2ctl_linux_arm64 ./infra/control/main

echo "Building v2ray_macos_amd64 and v2ctl_macos_amd64"
env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -ldflags "-s -w" -o ${cur_dir}/v2ray_macos_amd64 ./main
env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -ldflags "-s -w" -tags confonly -o ${cur_dir}/v2ctl_macos_amd64 ./infra/control/main

echo "Building v2ray_macos_arm64 and v2ctl_macos_arm64"
env CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -ldflags "-s -w" -o ${cur_dir}/v2ray_macos_arm64 ./main
env CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -ldflags "-s -w" -tags confonly -o ${cur_dir}/v2ctl_macos_arm64 ./infra/control/main

echo "Building v2ray.exe and wv2ray.exe and v2ctl.exe"
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $HOME/v2ray.exe -trimpath -ldflags "-s -w -buildid=" ./main
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $HOME/wv2ray.exe -trimpath -ldflags "-s -w -H windowsgui -buildid=" ./main
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $HOME/v2ctl.exe -trimpath -ldflags "-s -w -buildid=" -tags confonly ./infra/control/main

chmod +x ${cur_dir}/v2ray_linux_* ${cur_dir}/v2ctl_linux_*
cd ${cur_dir}