class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  # Build from source on every platform. The codebase is pure Go (no cgo),
  # so the binary is static and dependency-free with no external C libraries.
  url "https://github.com/wgzhao/ling-box/archive/refs/tags/v0.8.1.tar.gz"
  version "0.8.1"
  sha256 "d9e18f384e3474fdd98ec2b99ea650caad4a8afdb77fa0cc31be567240e7921d"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wgzhao/ling-box/cmd.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
