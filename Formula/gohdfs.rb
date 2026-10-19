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
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.5.0/gohdfs-v2.5.0-darwin-arm64.tar.gz"
      sha256 "8f390760a4ef59202219c94017a0f3b5a58c4d4d6e639ca888b272001ba86725"
    end
    on_intel do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.5.0/gohdfs-v2.5.0-darwin-amd64.tar.gz"
      sha256 "d421f17a756a2b556de26c9df7479ca9d2aba037887153b6ee75239698d11082"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/wgzhao/hdfs-go/releases/download/v2.5.0/gohdfs-v2.5.0-linux-amd64.tar.gz"
      sha256 "457e86dd7c60b9d31b79db76d729f9e6eb60fa3ed7613c18f56a6c5bb1dc5b0e"
    end
  end

  def install
    bin.install "hdfs"
    bash_completion.install "bash_completion" => "hdfs"
  end

  test do
    # The CLI prints its version to stderr and exits with status 1.
    assert_match version.to_s, shell_output("#{bin}/hdfs --version 2>&1", 1)
  end
end
