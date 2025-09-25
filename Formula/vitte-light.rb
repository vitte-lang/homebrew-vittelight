class VitteLight < Formula
  desc "Lightweight C runtime and CLI for the Vitte language"
  homepage "https://github.com/vitte-lang/VitteLight"
  url "https://github.com/vitte-lang/VitteLight/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "aa45ec45ae1128e8bd8c0351eec5825863979f4df56a0dd42889ac4cc9472125"
  license "MIT"
  head "https://github.com/vitte-lang/VitteLight.git", branch: "main"

  depends_on "cmake" => :build

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_C_STANDARD=11"
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"

    # Alias utilisateur court
    bin.install_symlink "vitte-cli" => "vitl"
  end

  test do
    assert_match("--help", shell_output("#{bin}/vitte-cli --help"))
    assert_match("--help", shell_output("#{bin}/vitl --help"))
  end
end