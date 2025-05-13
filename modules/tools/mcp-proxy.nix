{ pkgs }:

pkgs.python3Packages.buildPythonApplication {
  pname = "mcp-proxy";
  version = "0.3.2";

  src = pkgs.fetchFromGitHub {
    owner = "sparfenyuk";
    repo = "mcp-proxy";
    rev = "v0.3.2";
    sha256 = "sha256-dgSKFhSDRf+2swFuIAMgbCu5F2izfR+WIz8JFSkt4Rg="; # replace after first run
  };

  format = "pyproject";

  nativeBuildInputs = with pkgs.python3Packages; [ setuptools wheel ];
  propagatedBuildInputs = with pkgs.python3Packages; [ requests uvicorn mcp ];

  # ⛑️ THIS is what removes "mcp not installed" error
  pythonRemoveDeps = [ "mcp" ];

  doCheck = false;

  meta = {
    description = "MCP Proxy server for Tidewave";
    homepage = "https://github.com/sparfenyuk/mcp-proxy";
    license = pkgs.lib.licenses.mit;
  };
}
