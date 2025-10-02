{
  description = "tmux-mem-cpu-load development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        tmux-mem-cpu-load = pkgs.stdenv.mkDerivation {
          pname = "tmux-mem-cpu-load";
          version = "show_cpu_show_ram";
          
          src = pkgs.fetchFromGitHub {
            owner = "ormandi";
            repo = "tmux-mem-cpu-load";
            rev = "2037bfd0c15b019346996331722714d324086767";
            sha256 = "sha256-E2oDoqKcCS+T1XBD4+2YrCYGZjyk8gb1h0iyxQxN0HA=";
          };
          
          nativeBuildInputs = [ pkgs.cmake ];
          
          buildInputs = [ ];
          
          # Standard CMake build
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
        
      in {
        packages.default = tmux-mem-cpu-load;
        packages.tmux-mem-cpu-load = tmux-mem-cpu-load;
        
        devShells.default = pkgs.mkShell {
          buildInputs = [
            tmux-mem-cpu-load
            pkgs.tmux
          ];
          
          shellHook = ''
            echo "tmux-mem-cpu-load is available"
          '';
        };
      }
    );
}
