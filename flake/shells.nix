{
  perSystem = { self', pkgs, ... }: {
    devShells.python = pkgs.mkShell { # Stuff I need to run some python scripts
      packages = builtins.attrValues {
        inherit (pkgs) python3 flac fish;
        inherit (pkgs.python3Packages) requests click beautifulsoup4 colorama musicbrainzngs mutagen pyperclip pycryptodome aiohttp
          aiohttp-jinja2 jinja2 yaspin ratelimit rich poetry-core bitstring mechanicalsoup;
        inherit (self'.packages) pyimgurapi heybrochecklog dottorrent bcoding packaging;
      };

      # I like fish
      shellHook = ''
        fish
      '';
    };
  };
}
