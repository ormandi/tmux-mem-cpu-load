{ pkgs ? import <nixpkgs> {} }:

let
  tmux-mem-cpu-load = import ./default.nix { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = [
    tmux-mem-cpu-load
    pkgs.tmux
  ];

  shellHook = ''
    echo "tmux-mem-cpu-load is available"
  '';
}
