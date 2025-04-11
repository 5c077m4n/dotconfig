from os import mkdir, remove
from pathlib import Path
from shutil import rmtree


def wipe(dir: Path):
    if dir.is_symlink():
        dir.unlink()
    elif dir.is_dir():
        rmtree(dir)
    elif dir.exists():
        remove(dir)


def main():
    home_dir = Path().home()
    __dirname = Path(__file__).parent.absolute()

    with home_dir.joinpath(".zshenv").open("w") as zshenv_write:
        zshenv_write.writelines(
            [
                'export ZDOTDIR="${HOME}/.config/zsh"\n',
                '[[ -f "${ZDOTDIR}/.zshenv" ]] && source "${ZDOTDIR}/.zshenv"\n',
            ]
        )

    with home_dir.joinpath(".gitconfig").open("w") as gitconfig_append:
        gitconfig_append.writelines(
            ["[include]\n", "\tpath = ~/.config/git/config.toml"]
        )

    config_dir = home_dir.joinpath(".config")
    if not config_dir.is_dir():
        mkdir(config_dir)

    dotfiles_dir = __dirname.joinpath("dotfiles")
    for source_dir in dotfiles_dir.iterdir():
        dest_dir = config_dir.joinpath(source_dir.parts[-1])

        wipe(dest_dir)
        dest_dir.symlink_to(source_dir, True)


if __name__ == "__main__":
    main()
