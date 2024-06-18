{ inputs, ... }:
{
  perSystem = { pkgs, lib, ... }: {
    packages = let
      inherit (inputs.p2n.lib.mkPoetry2Nix { inherit pkgs; }) defaultPoetryOverrides mkPoetryApplication;
    in 
    {
      smoked-salmon = mkPoetryApplication { # broken
        projectDir = pkgs.fetchzip {
          url = "https://codeberg.org/xmoforf/smoked-salmon/archive/xmoforf.tar.gz";
          hash = "sha256-RwUeo3Hkab6s1RH8LcZZmwrBEBYDPorF/T0aBSOgkRI=";
        };
        patches = [ ./salmon.patch ];
        overrides = defaultPoetryOverrides.extend (self: super: {
          bencoder-pyx = super.bencoder-pyx.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools super.cython ];
          });
          pyimgurapi = super.pyimgurapi.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.poetry ];
          });
          heybrochecklog = super.heybrochecklog.overridePythonAttrs (old: {
            patches = (old.patches or []) ++ [ ./salmon.patch ]; # ffs
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools super.poetry ];
          });
          dottorrent = super.dottorrent.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools ];
          });
          bs4 = super.bs4.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools ];
          });
          pyimgur = super.pyimgur.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools ];
          });
        });
      };
      beets-filetote = mkPoetryApplication {
        projectDir = pkgs.fetchFromGitHub {
          owner = "gtronset";
          repo = "beets-filetote";
          rev = "f66d1e835e906b9b2ce9500104ae4cc2b70ddb7e";
          hash = "sha256-uxxhpTUk/1Ojy2ldgcXiNxhQ9BZg/Zud0omEbjLIFuE=";
        };
        overrides = defaultPoetryOverrides.extend (self: super: {
          beets = super.beets.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.setuptools ];
          });
          beets-audible = super.beets-audible.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.poetry ];
          });
          reflink = super.reflink.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [ super.pytest-runner ];
          });
        });
      };
    };
  };
}
