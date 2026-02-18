FROM nixos/nix:latest

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
WORKDIR /app
COPY . .

RUN nix profile add ./dotfiles/.config/nix#roee@nixos-vivo
RUN bash ./install.bash
ENTRYPOINT ["fish"]
