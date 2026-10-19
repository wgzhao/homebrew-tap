# Homebrew tap

Formulae for [wgzhao](https://github.com/wgzhao)'s command-line tools.

## Install

```sh
brew tap wgzhao/tap
brew install lingbox   # or: brew install gohdfs
```

## lingbox

[lingbox](https://github.com/wgzhao/ling-box) (玲珑盒) is a cross-platform CLI toolbox for developers: URL/base64/bcrypt/QR/password utilities, terminal image display, and PDF rendering.

```sh
lingbox --help
```

## gohdfs

[gohdfs](https://github.com/wgzhao/hdfs-go) is a native Go client for HDFS. The formula installs the `hdfs` command-line client, which provides `ls`, `put`, `get`, `cat`, `mkdir`, `rm`, and other Hadoop FileSystem-like commands without requiring a JVM or a local Hadoop installation.

```sh
hdfs --version
hdfs ls /user
```

Prebuilt binaries are available for macOS on Intel and Apple Silicon, and for Linux on x86_64.

## Note

The lingbox formula is also prepared for submission to [homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core), which requires the repository to gain some traction first (see Homebrew's [notability policy](https://docs.brew.sh/Adding-Software-to-Homebrew#well-knownness)).
