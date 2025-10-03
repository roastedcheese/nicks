{
  python3Packages,
  fetchFromGitHub,
  pyoxipng,
  pycambia,
}:
python3Packages.buildPythonApplication rec {
  pname = "smoked-salmon";
  version = "0.9.7.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "smokin-salmon";
    repo = "smoked-salmon";
    tag = version;
    sha256 = "sha256-JOwqu/Hu7BjYLo3DdL6o+9TI/OQvlgj5Xu8WQ0cujwo=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyoxipng
    requests
    click
    beautifulsoup4
    musicbrainzngs
    mutagen
    pyperclip
    aiohttp
    aiohttp-jinja2
    jinja2
    bitstring
    ratelimit
    rich
    unidecode
    setuptools
    wheel
    httpx
    tqdm
    filetype
    qbittorrent-api
    send2trash
    platformdirs
    msgspec
    torf
    setuptools-scm
    transmission-rpc
    deluge-client
    pycambia
    ffmpeg-python
    humanfriendly
    pillow
  ];
}
