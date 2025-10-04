class Vitl < Formula
  desc "Vitl — lightweight runtime and CLI for the Vitte programming language"
  homepage "https://github.com/vitte-lang/vitte-light"
  url "https://github.com/vitte-lang/vitte-light/releases/download/v0.1.0/vitl-v0.1.0.tar.gz"
  sha256 "b1e2a947bbf22b77f2f14f9129c782be8fd39c11cc9a9b66ab47d01c6b3f084f"
  license "MIT"

  head "https://github.com/vitte-lang/vitte-light.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    # Binaire principal (command: vitl)
    bin.install "bin/vitl"

    # Ressources partagées (sources ou stdlib)
    pkgshare.install "share/vitl-src" => "vitl-src" if Dir.exist?("share/vitl-src")

    # Completions facultatives
    bash_completion.install "completions/vitl.bash" if File.exist?("completions/vitl.bash")
    zsh_completion.install "completions/_vitl" if File.exist?("completions/_vitl")
    fish_completion.install "completions/vitl.fish" if File.exist?("completions/vitl.fish")
  end

  test do
    # Vérifie la version
    output = shell_output("#{bin}/vitl --version")
    assert_match version.to_s, output

    # Vérifie l’exécution d’un petit programme
    (testpath/"hello.vitl").write('print("Hello, Vitl!")')
    run_output = shell_output("#{bin}/vitl run hello.vitl")
    assert_match "Hello, Vitl!", run_output
  end
end