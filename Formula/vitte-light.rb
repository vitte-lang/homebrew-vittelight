class VitteLight < Formula
  desc "Lightweight C runtime and CLI for the Vitte language"
  homepage "https://github.com/vitte-lang/VitteLight"
  url "https://github.com/vitte-lang/VitteLight/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "18c12aa6280f858f9b273f41955fc0d7f41d8611ca9883fe6debfff2875fdb45"
  license "MIT"
  head "https://github.com/vitte-lang/VitteLight.git", branch: "main"

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc" => :build
  end

  def install
    rm_rf "build"
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_C_STANDARD=11
      -DCMAKE_SKIP_INSTALL_RPATH=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"

    # Alias pratique si le binaire principal s'appelle vitte-cli
    bin.install_symlink "vitte-cli" => "vitte-light" if (bin/"vitte-cli").exist?
  end

  test do
    if (bin/"vitte-light").exist?
      assert_match "--help", shell_output("#{bin}/vitte-light --help")
    elsif (bin/"vitte-cli").exist?
      assert_match "--help", shell_output("#{bin}/vitte-cli --help")
    else
      odie "No executable installed"
    end
  end
end