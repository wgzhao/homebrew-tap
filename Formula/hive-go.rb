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
      url "https://github.com/wgzhao/hive-go/releases/download/v0.1.0/hive-v0.1.0-darwin-arm64.tar.gz"
      sha256 "30480aff24d4829275226b75320e213298072278a9d7cd87d4336b2d3e8d6d37"
    end
    on_intel do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.1.0/hive-v0.1.0-darwin-amd64.tar.gz"
      sha256 "c48731174eeca18cc893fb51886bb3c775011eb5c5928d0c64ef5e572f0dd5ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.1.0/hive-v0.1.0-linux-arm64.tar.gz"
      sha256 "2d94edb68131580a6bbdb7ff81695705737bcfa2ab3a3d087449d95f5eb12d4d"
    end
    on_intel do
      url "https://github.com/wgzhao/hive-go/releases/download/v0.1.0/hive-v0.1.0-linux-amd64.tar.gz"
      sha256 "36afed4308401d3a3795121470a5bdebb293ab377ed2df803a02d5fe680c0682"
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
