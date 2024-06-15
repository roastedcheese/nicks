{
  perSystem = { pkgs, config, ... }: {
    devShells.python = pkgs.mkShell { # Stuff I need to run some python scripts
      packages = let
        packaging = let # Ahah imagine if you could override a python package wouldn't that be cool
          inherit (pkgs.python311Packages) buildPythonPackage fetchPypi setuptools pyparsing six pytestCheckHook pretend wheel;
        in buildPythonPackage rec {
          pname = "packaging";
          version = "20.9";
          format = "pyproject";

          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-WzJ6wTINyGPcpy9FFOzAhvMRhnRLhKIwN0zB/Xdv6uU=";
          };

          nativeBuildInputs = [
            setuptools
          ];

          propagatedBuildInputs = [ pyparsing six wheel ];

          checkInputs = [
            pytestCheckHook
            pretend
          ];

          # Prevent circular dependency
          doCheck = false;
        };
      in 
      with pkgs; [
        python3 flac fish python311Packages.mutagen python311Packages.mechanicalsoup packaging
      ];

      # I like fish
      shellHook = ''
        fish
      '';
    };
  };
}
