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
        ];


        # Simply just exec zsh
        shellHook = ''
          exec zsh
        '';
    };
  };
}
