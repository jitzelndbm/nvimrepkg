{
  lib,
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,

  startPlugins ? [ ],
  name ? "my_nvim",
  config ? "-- default config --",
}:
let
  # Write the configuration to the nix store
  configpath = builtins.toFile "init.lua" config;

  # Remove nested list of plugins
  foldPlugins = builtins.foldl' (
    acc: next:
    acc
    ++ [
      next
    ]
    ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  # Generate a runtime path from the start plugins.
  packpath =
    let
      inherit (lib) concatMapStringsSep getName;
    in
    runCommandLocal "packpath" { } ''
      mkdir -p $out/pack/${name}/{start,opt}

      ${concatMapStringsSep "\n" (
        plugin: "ln -vsfT ${plugin} $out/pack/${name}/start/${getName plugin}"
      ) startPluginsWithDeps}
    '';
in
symlinkJoin {
  name = "nvim";
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '--cmd' \
      --add-flags "'set runtimepath^=${packpath} | set packpath^=${packpath}'" \
      --add-flags '--cmd' \
      --add-flags '"source ${configpath}"' \
      --set-default NVIM_APPNAME ${name}
  '';
}
