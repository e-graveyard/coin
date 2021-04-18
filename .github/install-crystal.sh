#!/bin/bash

set -e

case "$OS" in
    macos-latest)
        brew install crystal
        ;;

    ubuntu-latest)
        curl -fsSL https://crystal-lang.org/install.sh | sudo bash
        ;;
esac

printf "\n\n"
crystal --version
printf "\n"
