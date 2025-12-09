# scripts/default.nix
{ pkgs, pog }:
let
  call = f: import f { inherit pkgs pog; };
in
{
  tools = call ./tools.nix;
}
