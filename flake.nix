{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    devShell.${system} = pkgs.mkShell {
       packages = with pkgs; [
          zsh
          git
          odin
          ols
          ncurses
        ];


        # Simply just exec zsh
        shellHook = ''
          git submodule update --init --recursive

          export LD_LIBRARY_PATH=\"${pkgs.lib.makeLibraryPath [ pkgs.ncurses ]}:$LD_LIBRARY_PATH\"
          exec zsh
        '';
    };
  };
}
