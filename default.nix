# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `overlays`,
# `nixosModules`, `homeModules`, `darwinModules` and `flakeModules`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `overlays`, `nixosModules`, `homeModules`,
  # `darwinModules` and `flakeModules` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  nixosModules = import ./nixos-modules; # NixOS modules
  # homeModules = { }; # Home Manager modules
  # darwinModules = { }; # nix-darwin modules
  # flakeModules = { }; # flake-parts modules
  overlays = import ./overlays; # nixpkgs overlays

  example-package = pkgs.callPackage ./pkgs/example-package { };
  bakaxl-bunny = pkgs.callPackage ./pkgs/bakaxl-bunny { };
  horizon-bin = pkgs.callPackage ./pkgs/horizon { };
  octocode = pkgs.callPackage ./pkgs/octocode { };
  # `zenity` is a top-level package on current nixpkgs but only exists as
  # `pkgs.gnome.zenity` on older revisions, such as the ones the CI matrix
  # builds against through NIX_PATH.
  lzc-client-desktop-bin = pkgs.callPackage ./pkgs/lzc-client-desktop-bin {
    zenity = pkgs.zenity or pkgs.gnome.zenity;
  };
  hclient-cli-bin = pkgs.callPackage ./pkgs/hclient-cli-bin { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
