# Blueprint Library

bplib is a set of tools for use by other Factorio mods that need to manipulate
blueprints.

bplib contains many tools, but its primary purpose is to address the following
pain points:

- Correctly applying blueprint tags to pre-existing entities in the world when
an overlapping blueprint is stamped down.

- Correctly extracting blueprint tags from world entities into blueprints,
including when blueprints are updated via "select new contents."

- Correctly abstracting over blueprints within or without books, in the
library, in the inventory, etc. and treating them in a unified fashion.

## Usage

Download the latest release from the
[mod portal](https://mods.factorio.com/mod/bplib) unzip it, and put it in your
mods directory. You can access libraries provided by bplib with
`require("__bplib__.blueprint")`, etc.

Add the bplib directory to your language server's library. We recommend
installing the [Factorio modding
toolkit](https://github.com/justarandomgeek/vscode-factoriomod-debug) and
setting it up with the [Sumneko Lua language
server](https://github.com/sumneko/lua-language-server) to get cross-mod
autocomplete and type checking.

You can view the online documentation
[here](https://project-cybersyn.github.io/bplib/).

## Contributing

Please use the [GitHub repository](https://github.com/project-cybersyn/bplib) for
questions, bug reports, or pull requests.
