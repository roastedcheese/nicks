{
  python3Packages,
  fetchPypi,
  bencoder-pyx,
}: 
python3Packages.buildPythonPackage rec {
  pname = "dottorrent";
  version = "1.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xZX4ZNRmYAV9hKpLm1gUVNN5guXuVBcZgkHB35Gf/CA=";
  };

  nativeBuildInputs = [ python3Packages.setuptools ];
  propagatedBuildInputs = [ bencoder-pyx ];
}
