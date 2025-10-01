#!/usr/bin/env bash

set -euxo pipefail

(cd ./dotfiles/ && stow --target "$HOME" --adopt --restow .)
(cd ./dotfiles-etc/ && sudo stow --target /etc --adopt --restow .)
