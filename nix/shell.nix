{ pkgs, ... }:
{
  packages =
    let
      inherit (pkgs) nil lua-language-server;
    in
    [
      nil
      lua-language-server
    ];
}
