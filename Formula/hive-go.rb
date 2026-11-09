class HiveGo < Formula
  desc "Pure-Go HiveServer2 client and command-line tool"
  homepage "https://github.com/wgzhao/hive-go"
  license "MIT"

  # Prebuilt static binaries from GitHub Releases, so no Go toolchain or
  # module downloads are needed on the client. The project is pure Go and
  # release.yml builds every target with CGO_ENABLED=0, so these are
  # self-contained and have no runtime dependencies.
  on_macos do
    on_arm do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.2.0/hive-v0.2.0-darwin-arm64.tar.gz"
      sha256 "1fdf14096f9dfc5a82913b6e7c289198ae9162feafe382c059432274b8772300"
    end
    on_intel do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.2.0/hive-v0.2.0-darwin-amd64.tar.gz"
      sha256 "d3ec137a434ae476759feff332cf4a6a43d78b110d9b263fae704d7d0c6cbcdd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.2.0/hive-v0.2.0-linux-arm64.tar.gz"
      sha256 "3105fd5605b61c4f6633fed84915139f7d1c5859f8883141bdcba5fba53343dc"
    end
    on_intel do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.2.0/hive-v0.2.0-linux-amd64.tar.gz"
      sha256 "325a22f6f13da582592308a1dd6575592ebf6cf6da14cc6ddb89dabd2e5228af"
    end
  end

  def install
    bin.install "hive"
  end

  def caveats
    <<~EOS
      This formula installs the `hive` command. Homebrew core also provides
      Apache Hive as `hive`; keep only one linked at a time:
        brew unlink hive && brew link hive-go

      hive-go #{version} is a pre-1.0 public preview. Its flags and Go API may
      change without notice.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hive --version")
  end
end
