{
  python3Packages,
  fetchPypi,
  rustPlatform,
}:
python3Packages.buildPythonPackage rec {
  pname = "pyoxipng";
  version = "9.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ycPAh7DHRLqbcJoyHGEYNmjwJME4dIqNpWX+iaS/D7g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-wMCx6cujqM4q96b1mg4eovKjWmsv0FcaDBCxy0OodmA=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];
}
