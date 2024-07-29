{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            # stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; [
              cmake
              gnumake
              steam-run
              ocl-icd
              khronos-ocl-icd-loader
              opencl-clang
              opencl-headers
              xorg.gccmakedep

              (pkgs.writeShellScriptBin "build" ''
                ${pkgs.cmake}/bin/cmake -B build; cmake --build build
              '')
            ];
          };
      });
    };
}
