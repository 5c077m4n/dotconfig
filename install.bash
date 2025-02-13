#!/usr/bin/env bash

set -euxo pipefail

cd ./dotfiles/
stow --target "$HOME" --adopt --restow .
