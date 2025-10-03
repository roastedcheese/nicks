{
  fetchPypi,
  python3Packages,
  rustPlatform,
  pkg-config,
  openssl,
}:
python3Packages.buildPythonPackage rec {
  pname = "pycambia";
  version = "0.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vt3S+E8VMhlpIhYy/VEYZlMTbdeOTTzgrhPOfFkllCA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-7xZZidujoCgdyFXR9PQ3sEr2QKI6v3VQs9DEHqEXncg=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];
  buildInputs = [ openssl.dev ];
}
