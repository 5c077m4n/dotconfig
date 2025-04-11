#!/bin/sh

cat >>/etc/apk/repositories <<END
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
https://ftp.halifax.rwth-aachen.de/alpine/edge/main
https://ftp.halifax.rwth-aachen.de/alpine/edge/community
https://ftp.halifax.rwth-aachen.de/alpine/edge/testing
END

sudo apk update
sudo apk upgrade

sudo apk add curl
sudo apk add wget
sudo apk add openssl
sudo apk add openssh
sudo apk add git
sudo apk add python3
sudo apk add zsh

add_pkg() {
	sudo apk add "$1"
	sudo apk add "$1"-doc
	sudo apk add "$1"-zsh-completion
}

# Replacement to default tools
add_pkg fd
add_pkg ripgrep
add_pkg exa
add_pkg bat
add_pkg neovim

(
	mkdir -p "${HOME}/repos/"
	cd "${HOME}/repos/" || exit

	git clone https://github.com/5c077m4n/dotconfig.git
	cd dotconfig || exit

	sudo python3 install.py
)

# Oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
