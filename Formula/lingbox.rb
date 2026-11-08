class Lingbox < Formula
  desc "Cross-platform CLI toolbox for developers"
  homepage "https://github.com/wgzhao/ling-box"
  license "Apache-2.0"

  # Prebuilt static binaries from GitHub Releases, so no Go toolchain or
  # module downloads are needed on the client. The codebase is pure Go
  # (built with CGO_ENABLED=0 in .github/workflows/release.yml), so these
  # are self-contained and have no runtime dependencies.
  on_macos do
    on_arm do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.9.0/lingbox-macos-arm64"
      sha256 "535234b98b2f133108bd5eb7f72683a18061f786f87cfb017c30dac73c244c07"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.9.0/lingbox-macos-x86-64"
      sha256 "543b34309d7c7b2f79b3a080c7a9cd3005c9de0dca63c8a30297fb40beee13e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.9.0/lingbox-linux-arm64"
      sha256 "b786a0b8012ca4b312a10d99aac9b8dd9563b74cea6c8a7ea194132638453e77"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.9.0/lingbox-linux-x86-64"
      sha256 "1be3be01c8ae09a1b733ee912c70498ec898a5a559689468de128967b36c8781"
    end
  end

  def install
    bin.install cached_download => "lingbox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
