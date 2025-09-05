# Blueprint Manipulation Library

bplib is a set of tools for use by other Factorio mods that need to manipulate blueprints.

Its primary purpose is to address the following pain points for developers working with custom entities that need advanced interaction with blueprints:

- Abstracting over blueprints within or without books, in the library, in the inventory, etc. and treating them in a unified fashion.

- Correctly identifying and updating pre-existing entities in the world when an overlapping blueprint is stamped down.

- Correctly extracting blueprint tags from world entities into blueprints, including when blueprints are updated via "select new contents."

- Doing all of the above while supporting absolute and relative snapping, offsets, books, libraries, the kitchen sink, etc.

## Contributing

Please use the [GitHub repository](https://github.com/project-cybersyn/bplib) for questions, bug reports, or pull requests.

## Usage

[**Read the example code here!**](https://github.com/project-cybersyn/bplib/blob/main/doc/example.lua)

Download the latest release from the [mod portal](https://mods.factorio.com/mod/bplib) unzip it, and put it in your mods directory. You can import the primary API of bplib by using `require("__bplib__.blueprint")`.

bplib is self-documenting, via LuaLS type annotations and comments. We recommend installing the [Factorio modding toolkit](https://github.com/justarandomgeek/vscode-factoriomod-debug) and [LuaLS](https://github.com/sumneko/lua-language-server). Adding bplib to the LuaLS library list will give you code completion and in-editor documentation.
