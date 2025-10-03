{
  description = "Flake for tmux-mem-cpu-load";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          tmux-mem-cpu-load = pkgs.stdenv.mkDerivation {
            pname = "tmux-mem-cpu-load";
            version = "show_cpu_show_ram";

            src = self;  # Use the flake's own source.

            nativeBuildInputs = [ pkgs.cmake pkgs.clang_21 ];

            cmakeFlags = [
              "-DCMAKE_CXX_COMPILER=${pkgs.clang_21}/bin/clang++"
              "-DCMAKE_C_COMPILER=${pkgs.clang_21}/bin/clang"
            ];

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
          };

          default = self.packages.${system}.tmux-mem-cpu-load;
        };
      }
    );
}
