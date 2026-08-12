class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  url "https://github.com/wgzhao/ling-box/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4fd7c5e96151cb66650bf7f2b3d377230c1dc983462bfcb107237f9c678e9137"
  license "Apache-2.0"
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wgzhao/ling-box/cmd.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
