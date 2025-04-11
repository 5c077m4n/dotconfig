#!/bin/sh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH="${HOME}/.oh-my-zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/zcompdump"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh/cache"

export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/config.toml"
export MAILCHECK=0
