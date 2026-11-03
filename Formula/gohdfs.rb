class Gohdfs < Formula
  desc "Native HDFS client and command-line tool"
  homepage "https://github.com/wgzhao/hdfs-go"
  license "MIT"

  # Prebuilt static binaries from GitHub Releases, so no Go toolchain or
  # module downloads are needed on the client. The project is pure Go and
  # release.yml builds every target with CGO_ENABLED=0, so these are
  # self-contained and have no runtime dependencies.
  on_macos do
    on_arm do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.6.0/gohdfs-v2.6.0-darwin-arm64.tar.gz"
      sha256 "6afab2fe1664dde804d64b446e8cbcb06f84b7a5b32a0068e005f2480e0d949e"
    end
    on_intel do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.6.0/gohdfs-v2.6.0-darwin-amd64.tar.gz"
      sha256 "8fe627e1f4ef600fc281b2eec525a3fe3ca1a4b80153f4edb28dd610a7e39ee8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.6.0/gohdfs-v2.6.0-linux-arm64.tar.gz"
      sha256 "8b0673cde25d4f4948f6f27eee31019dc27b7c8964022ac3cb7191398f75609f"
    end
    on_intel do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.6.0/gohdfs-v2.6.0-linux-amd64.tar.gz"
      sha256 "2b2d228b2697581e1cd2d3c3f96ada9412a82b959c9d93ffeb21b54f295eb013"
    end
  end

  def install
    bin.install "hdfs"
    bash_completion.install "bash_completion" => "hdfs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hdfs --version")
  end
end
