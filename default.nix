{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "tmux-mem-cpu-load";
  version = "show_cpu_show_ram";

  src = builtins.fetchGit {
    url = "https://github.com/ormandi/tmux-mem-cpu-load";
    ref = "show_cpu_show_ram";
  };

  nativeBuildInputs = [ pkgs.cmake ];

  configurePhase = ''
    cmake .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tmux-mem-cpu-load $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "CPU, RAM memory, and load monitor for use with tmux";
    homepage = "https://github.com/ormandi/tmux-mem-cpu-load/tree/show_cpu_show_ram";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
