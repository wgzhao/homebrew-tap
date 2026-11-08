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
      url "https://github.com/wgzhao/ling-box/releases/download/v0.10.0/lingbox-macos-arm64"
      sha256 "e27f9386e1a419f5cf8c92648673895feb6f8e92c6fefda99c7c0473af8f30db"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.10.0/lingbox-macos-x86-64"
      sha256 "77e395d94e0c2d8a126013768310483ee5c246cf2902b0333c7362fd39c37901"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.10.0/lingbox-linux-arm64"
      sha256 "2eca077ac12f7d88e28e17619ce9c34d12141fe23694cd738245350f82f9fc64"
    end
    on_intel do
      url "https://github.com/wgzhao/ling-box/releases/download/v0.10.0/lingbox-linux-x86-64"
      sha256 "9f7d7c32e3e258cdbe57ff41264cb793cdb6ddb60c3d51dd15b779b540694cfa"
    end
  end

  def install
    bin.install cached_download => "lingbox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lingbox --version")
  end
end
