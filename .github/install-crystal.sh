#!/bin/bash

set -e

case "$OS" in
    macos-latest)
        brew install openssl
        export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig

        brew install crystal
        ;;

    ubuntu-latest)
        echo "deb https://dl.bintray.com/crystal/deb all stable" \
            | sudo tee /etc/apt/sources.list.d/crystal.list

        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
        sudo apt-get update

        sudo apt-get install -y libyaml-dev crystal
        ;;
esac

printf "\n\n"
crystal --version
printf "\n"
