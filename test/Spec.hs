{-# OPTIONS_GHC -F -pgmF hspec-discover #-}

main :: IO ()
main = putStrLn "Test suite not yet implemented"
{
  description = "Write amsthm theorems using Pandoc Markdown";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
      in {
        packages.default = haskellPackages.callCabal2nix "pandoc-theorem" self {};

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            haskellPackages.cabal-install
            haskellPackages.haskell-language-server
            haskellPackages.ghc
            pandoc
          ];
        };
      });
}
cabal-version:      2.4
name:               pandoc-theorem
version:            0.2.0
synopsis:           Write amsthm theorems using Pandoc Markdown
description:        A Pandoc filter to convert definition lists into amsthm theorem environments
homepage:           https://github.com/sliminality/pandoc-theorem
bug-reports:        https://github.com/sliminality/pandoc-theorem/issues
license:            BSD-3-Clause
license-file:       LICENSE
author:             Sarah Lim
maintainer:         slim@sarahlim.com
copyright:          2019 Sarah Lim
category:           Text
build-type:         Simple
extra-source-files:
    README.md
    ChangeLog.md
    examples/*.tex
    examples/*.md
    examples/*.png

source-repository head
  type: git
  location: https://github.com/sliminality/pandoc-theorem

library
    exposed-modules:    Env
    hs-source-dirs:    src
    default-language:  Haskell2010
    build-depends:    base >= 4.7 && < 5
                    , pandoc-types >= 1.20
                    , text
                    , containers

executable pandoc-theorem-exe
    main-is:          Main.hs
    hs-source-dirs:   app
    default-language: Haskell2010
    ghc-options:      -threaded
                      -rtsopts
                      -with-rtsopts=-N
    build-depends:    base >= 4.7 && < 5
                    , pandoc-theorem
                    , pandoc-types

test-suite pandoc-theorem-test
    type:             exitcode-stdio-1.0
    main-is:          Spec.hs
    other-modules:    EnvSpec
    hs-source-dirs:   test
    default-language: Haskell2010
    ghc-options:      -threaded
                      -rtsopts
                      -with-rtsopts=-N
    build-depends:    base >= 4.7 && < 5
                    , pandoc-theorem
                    , hspec
