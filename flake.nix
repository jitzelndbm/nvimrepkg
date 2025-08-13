{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      pre-commit-hooks,
      ...
    }:
    let
      name = "nvimrepkg";

      fa = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      pkgsBySystem = fa (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = false;
        }
      );

      treefmtEval = fa (system: treefmt-nix.lib.evalModule pkgsBySystem.${system} ./nix/formatters.nix);
    in
    {
      packages = fa (system: {
        default = self.packages.${system}.${name};
        ${name} = pkgsBySystem.${system}.callPackage ./src/${name}.nix { };
        my-config = pkgsBySystem.${system}.callPackage ./src/${name}.nix {
          config = builtins.readFile ./init.lua;
          startPlugins = import ./plugins.nix { vimPlugins = pkgsBySystem.${system}.vimPlugins; };
        };
      });

      devShells = fa (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          default =
            let
              inherit (pkgs) mkShell nil;
              inherit (pkgs.lib) concatLines;
              inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;

              treefmt = treefmtEval.${system}.config.build.wrapper;
              shell = import ./nix/shell.nix { inherit pkgs; };
            in
            mkShell (
              shell
              // {
                packages = (shell.packages or [ ]) ++ [
                  treefmt
                  nil
                  enabledPackages
                ];

                shellHook = concatLines [
                  (shell.shellHook or "")
                  shellHook
                ];
              }
            );
        }
      );

      formatter = fa (system: treefmtEval.${system}.config.build.wrapper);

      checks = fa (system: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = (import ./nix/pre-commit-hooks.nix) // {
            treefmt = {
              enable = true;
              package = treefmtEval.${system}.config.build.wrapper;
            };
          };
        };
      });
    };
}
