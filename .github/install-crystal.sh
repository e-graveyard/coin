#!/bin/bash

set -e

case "$OS" in
    macos-latest)
        brew install openssl
        export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig

        brew install crystal
        ;;

    ubuntu-latest)
        sudo apt-get update
        sudo apt-get install -y libssl-dev libxml2-dev libyaml-dev libgmp-dev libz-dev

        curl -fsSL https://crystal-lang.org/install.sh | sudo bash
        ;;
esac

printf "\n\n"
crystal --version
printf "\n"
