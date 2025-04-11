from os import mkdir, remove
from pathlib import Path
from shutil import rmtree


def wipe(dir: Path) -> None:
    if dir.is_symlink():
        dir.unlink()
    elif dir.is_dir():
        rmtree(dir)
    elif dir.exists():
        remove(dir)


def main() -> None:
    home_dir = Path().home()
    __dirname = Path(__file__).parent.absolute()

    with home_dir.joinpath(".zshenv").open("w") as zshenv_write:
        zshenv_write.writelines(
            [
                'export ZDOTDIR="${HOME}/.config/zsh"\n',
                '[[ -f "${ZDOTDIR}/.zshenv" ]] && source "${ZDOTDIR}/.zshenv"\n',
            ]
        )

    config_dir = home_dir.joinpath(".config")
    if not config_dir.is_dir():
        mkdir(config_dir)

    dotfiles_dir = __dirname.joinpath("dotfiles")
    for source_dir in dotfiles_dir.iterdir():
        dest_dir = config_dir.joinpath(source_dir.parts[-1])

        wipe(dest_dir)
        dest_dir.symlink_to(source_dir, True)

    bin_dir = __dirname.joinpath("bin")
    dest_bin_dir = home_dir.joinpath(".local", "bin")
    wipe(dest_bin_dir)
    dest_bin_dir.symlink_to(bin_dir)


if __name__ == "__main__":
    main()
