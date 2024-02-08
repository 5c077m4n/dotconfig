#!/usr/bin/env python3

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

    # Link legacy config files into `$HOME`
    home_dotfiles_dir = __dirname.joinpath("home_dotfiles")
    for source_dir in home_dotfiles_dir.iterdir():
        dest_dir = home_dir.joinpath(source_dir.parts[-1])

        wipe(dir=dest_dir)
        dest_dir.symlink_to(target=source_dir, target_is_directory=False)

    config_dir = home_dir.joinpath(".config")
    if not config_dir.is_dir():
        mkdir(config_dir)

    # Link config files into `$XDG_CONFIG_HOME`
    dotfiles_dir = __dirname.joinpath("dotfiles")
    for source_dir in dotfiles_dir.iterdir():
        dest_dir = config_dir.joinpath(source_dir.parts[-1])

        wipe(dir=dest_dir)
        dest_dir.symlink_to(target=source_dir, target_is_directory=True)

    # Link scripts to appear in `$PATH`
    bin_dir = __dirname.joinpath("dotlocal").joinpath("bin")
    local_dir = home_dir.joinpath(".local")
    if not local_dir.exists():
        mkdir(local_dir)
    dest_bin_dir = local_dir.joinpath("bin")
    wipe(dir=dest_bin_dir)
    dest_bin_dir.symlink_to(target=bin_dir, target_is_directory=True)


if __name__ == "__main__":
    main()
