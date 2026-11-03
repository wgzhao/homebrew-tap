# Homebrew tap

Formulae for [wgzhao](https://github.com/wgzhao)'s command-line tools.

## Formulae

| Formula | Installs | Description |
| --- | --- | --- |
| [lingbox](#lingbox) | `lingbox` | Developer CLI toolbox: encoding, hashing, QR codes, format conversion, terminal image display, and network/IP utilities |
| [gohdfs](#gohdfs) | `hdfs` | Native Go HDFS client with Hadoop FileSystem-like commands |

## Install

```sh
brew tap wgzhao/tap
brew trust wgzhao/tap   # required on Homebrew 6+ for non-official taps
brew install lingbox
brew install gohdfs
```

Or install a single formula by fully qualified name, which trusts only that formula:

```sh
brew install wgzhao/tap/gohdfs
```

## lingbox

[lingbox](https://github.com/wgzhao/ling-box) (玲珑盒) is a cross-platform CLI toolbox for developers: URL/base64/unicode encoding, bcrypt hashing, QR codes, password/UUID generation, JSON/YAML/CSV conversion, terminal image display, and network/IP utilities.

```sh
lingbox --help
```

## gohdfs

[gohdfs](https://github.com/wgzhao/hdfs-go) is a native Go client for HDFS. The formula installs the `hdfs` command-line client, which provides `ls`, `put`, `get`, `cat`, `mkdir`, `rm`, and other Hadoop FileSystem-like commands without requiring a JVM or a local Hadoop installation.

```sh
hdfs --version
hdfs ls /user
```

## Platforms

Both formulae install prebuilt static binaries from GitHub Releases:

| Formula | macOS Intel | macOS Apple Silicon | Linux x86_64 | Linux arm64 |
| --- | :-: | :-: | :-: | :-: |
| lingbox | yes | yes | yes | yes |
| gohdfs | yes | yes | yes | - |

## Note

The lingbox formula is also prepared for submission to [homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core), which requires the repository to gain some traction first (see Homebrew's [notability policy](https://docs.brew.sh/Adding-Software-to-Homebrew#well-knownness)).
