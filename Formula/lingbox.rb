class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  # Build from source on every platform: cgo statically links MuPDF
  # from go-fitz's bundled libs, so no precompiled binaries are used.
  url "https://github.com/wgzhao/ling-box/archive/refs/tags/v0.8.0.tar.gz"
  version "0.8.0"
  sha256 "592b7d3ba55ffc894285b799017eeec39b7ed391434784a723956d112d7344d2"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wgzhao/ling-box/cmd.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
