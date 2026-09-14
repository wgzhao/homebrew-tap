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
      url "https://github.com/wgzhao/ling-box/releases/download/v0.8.1/lingbox-macos-arm64"
      sha256 "53b91b5360b113a4413623dd110b45f65128987e48b1ab1cf1dbd49be4028270"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.8.1/lingbox-macos-x86-64"
      sha256 "abda7e093e78c1fedaa69ccff672fa3a58d27425a89a31c0fe93674228b220d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.8.1/lingbox-linux-arm64"
      sha256 "94702c437e0ced1504e8febe0f2d9b9849a89499573763744649dfee1e127e68"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.8.1/lingbox-linux-x86-64"
      sha256 "f978c73e6e17b960cc26a24b4e1ef9bac498adf20b47de06f4666d7889b6bf1e"
    end
  end

  def install
    bin.install cached_download => "lingbox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
