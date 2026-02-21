class VisaJobsMcp < Formula
  desc "MCP server for finding visa-sponsoring jobs"
  homepage "https://github.com/neosh11/visa-jobs-mcp"
  version "0.3.1"
  license "MIT"
  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/neosh11/visa-jobs-mcp/releases/download/v0.3.1/visa-jobs-mcp-v0.3.1-macos-arm64.tar.gz"
    sha256 "26840097379949965ef96461366945847d0d9c9cc241a44b610c1290dcb4bc0f"
  else
    url "https://github.com/neosh11/visa-jobs-mcp/releases/download/v0.3.1/visa-jobs-mcp-v0.3.1-macos-x86_64.tar.gz"
    sha256 "e436f1aa7992154edff28624b189b9700df9ee6d000fef5799c443a2670da398"
  end

  def install
    if (buildpath/"visa-jobs-mcp").directory?
      bin.install "visa-jobs-mcp/visa-jobs-mcp"
      if (buildpath/"visa-jobs-mcp/data/companies.csv").exist?
        (pkgshare/"data").install "visa-jobs-mcp/data/companies.csv"
      end
    else
      bin.install "visa-jobs-mcp"
      (pkgshare/"data").install "data/companies.csv" if (buildpath/"data/companies.csv").exist?
    end
  end

  test do
    output = shell_output("#{bin}/visa-jobs-mcp --version")
    assert_match "0.3.1", output
  end
end
