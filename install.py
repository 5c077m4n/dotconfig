import shutil
from os import environ, listdir, mkdir, path, remove, symlink, unlink


def main():
    home_dir = environ.get("HOME")
    if home_dir is None:
        raise Exception("The $HOME param is not set")

    with open(path.join(home_dir, ".zshenv"), "w") as zshenv_write:
        zshenv_write.writelines(
            [
                'export ZDOTDIR="${HOME}/.config/zsh"\n',
                '[[ -f "${ZDOTDIR}/.zshenv" ]] && source "${ZDOTDIR}/.zshenv"\n',
            ]
        )

    with open(path.join(home_dir, ".gitconfig"), "a") as gitconfig_append:
        gitconfig_append.writelines(
            ["[include]\n" "\tpath = ~/.config/git/config.toml"]
        )

    config_dir = path.join(home_dir, ".config")
    if not path.isdir(config_dir):
        mkdir(config_dir)

    for dir in listdir("./dotfiles"):
        source_dir = path.abspath(path.join("./dotfiles", dir))
        dest_dir = path.join(config_dir, dir)

        if path.islink(dest_dir):
            unlink(dest_dir)
        elif path.isdir(dest_dir):
            shutil.rmtree(dest_dir)
        elif path.exists(dest_dir):
            remove(dest_dir)

        symlink(source_dir, dest_dir, True)


if __name__ == "__main__":
    main()