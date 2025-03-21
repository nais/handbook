{
  description = "dev env for handbook";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    inputs:
    inputs.flake-utils.lib.eachSystem
      # Systems supported
      [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]
      (
        system:
        let
          pkgs = import inputs.nixpkgs { localSystem = { inherit system; }; };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              # Development environment output
              python311
              poetry
            ];
          };
        }
      );
}
