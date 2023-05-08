from pathlib import Path
# import subprocess

from ranger.api.commands import Command
from cornerboi import (
    lnstore,
    ranger_exts,
)


# load and expose custom cmds
lnwks = ranger_exts.lnwks
