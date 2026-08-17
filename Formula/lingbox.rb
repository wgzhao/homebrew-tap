class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  # Build from source on every platform: cgo statically links MuPDF
  # from go-fitz's bundled libs, so no precompiled binaries are used.
  url "https://github.com/wgzhao/ling-box/archive/refs/tags/v0.6.0.tar.gz"
  version "0.6.0"
  sha256 "a2dc5f8983d411ee98c6b9e0b3e295cef8dbdc7af87929c1bbbc2d8615e165a9"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wgzhao/ling-box/cmd.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
