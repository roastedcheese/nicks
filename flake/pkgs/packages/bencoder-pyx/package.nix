{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "bencoder-pyx";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "bencoder.pyx";
    hash = "sha256-MoTxO+KDX6gMY3uEEYvN13P2Nf813MOAgmYsd8jDPb8=";
  };

  nativeBuildInputs = with python3Packages; [cython setuptools wheel];
  nativeCheckInputs = with python3Packages; [pytest];
}
