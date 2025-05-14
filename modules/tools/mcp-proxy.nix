{ pkgs }:

let
  arch = if pkgs.stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${arch}-apple-darwin";
  version = "0.1.1";
  sha256s = {
    aarch64 = "sha256-dkuoL7ndfkZPAoyyHnnGp98jMrk7ZC4jtdJEZIYyAy4=";
    x86_64 = "sha256-wUEqILHQx9kH0Tmn0QymSLdVO2A+OrUMqkpsh5g3m5o=";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "mcp-proxy";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/tidewave-ai/mcp_proxy_rust/releases/download/v${version}/mcp-proxy-${platform}.tar.gz";
    sha256 = sha256s.${arch};
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    chmod +x $out/bin/mcp-proxy
  '';

  meta = with pkgs.lib; {
    description = "Rust bidirectional MCP proxy between stdio and SSE";
    homepage = "https://github.com/tidewave-ai/mcp_proxy_rust";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.darwin;
  };
}
