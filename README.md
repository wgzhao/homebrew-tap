# Homebrew tap

Formulae for [wgzhao](https://github.com/wgzhao)'s command-line tools.

## Formulae

| Formula | Installs | Description |
| --- | --- | --- |
| [lingbox](#lingbox) | `lingbox` | Developer CLI toolbox: encoding, hashing, QR codes, format conversion, terminal image display, and network/IP utilities |
| [gohdfs](#gohdfs) | `hdfs` | Native Go HDFS client with Hadoop FileSystem-like commands |
| [hive-go](#hive-go) | `hive` | Pure-Go HiveServer2 client and CLI |

## Install

```sh
brew tap wgzhao/tap
brew trust wgzhao/tap   # required on Homebrew 6+ for non-official taps
brew install lingbox
brew install gohdfs
brew install hive-go
```

Or install a single formula by fully qualified name, which trusts only that formula:

```sh
brew install wgzhao/tap/gohdfs
brew install wgzhao/tap/hive-go
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

## hive-go

[hive-go](https://github.com/wgzhao/hive-go) is a pure-Go HiveServer2 client and command-line tool. It speaks the Thrift `TCLIService` protocol directly, so it needs no JVM, Hadoop client libraries, CGO, or local Hive installation. The formula installs the `hive` command.

hive-go v0.1.0 is a pre-1.0 public preview. It supports `NONE`, `NOSASL`, and `LDAP` authentication, protocol V10/V6, a REPL and script mode, and table/vertical/CSV/TSV/JSON output.

```sh
hive --version
hive -u hive2://127.0.0.1:10000/default -n hive -e "SELECT 1"
```

> Homebrew core also provides Apache Hive as `hive`. If you already have that formula installed, both packages provide a `hive` executable; keep only one linked:
>
> ```sh
> brew unlink hive && brew link hive-go
> ```

## Platforms

All formulae install prebuilt static binaries from GitHub Releases:

| Formula | macOS Intel | macOS Apple Silicon | Linux x86_64 | Linux arm64 |
| --- | :-: | :-: | :-: | :-: |
| lingbox | yes | yes | yes | yes |
| gohdfs | yes | yes | yes | yes |
| hive-go | yes | yes | yes | yes |

## Note

The lingbox formula is also prepared for submission to [homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core), which requires the repository to gain some traction first (see Homebrew's [notability policy](https://docs.brew.sh/Adding-Software-to-Homebrew#well-knownness)).
