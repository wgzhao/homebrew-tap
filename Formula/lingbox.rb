class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  # Default (Linux): build from source so MuPDF links statically against the host libc.
  url "https://github.com/wgzhao/ling-box/archive/refs/tags/v0.5.0.tar.gz"
  version "0.5.0"
  sha256 "4fd7c5e96151cb66650bf7f2b3d377230c1dc983462bfcb107237f9c678e9137"
  license "Apache-2.0"

  # macOS: precompiled binaries from GitHub Releases (MuPDF statically linked
  # via cgo), no Go toolchain required.
  on_macos do
    on_arm do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.5.0/lingbox-0.5.0-darwin-arm64.tar.gz"
      sha256 "4ca37f56df6c9b19c9b62cd0948e6b72654df8d9f73ca5d5675205f7663124af"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.5.0/lingbox-0.5.0-darwin-amd64.tar.gz"
      sha256 "3c45b4e9bc5ab4c3612e65009bce58259ef00d1791007fc6d9f61f265e1e1aa5"
    end
  end

  on_linux do
    depends_on "go" => :build
  end

  def install
    if OS.mac?
      bin.install "lingbox"
    else
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wgzhao/ling-box/cmd.version=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
