{
  system,
  nixpkgs,
  redisVersion,
  redisSha256,
}:
let

  pkgs = import nixpkgs { inherit system; };

  redis = pkgs.redis.overrideAttrs (oldAttrs: {
    version = redisVersion;
    src = pkgs.fetchurl {
      url = "https://download.redis.io/releases/redis-${redisVersion}.tar.gz";
      sha256 = redisSha256;
    };
  });
in
pkgs.mkShell {
  buildInputs = [
    redis
  ];

  shellHook = ''
    echo "📦 Redis Server $(${redis}/bin/redis-server --version)"
    echo "🔧 Redis CLI $(${redis}/bin/redis-cli --version)"
  '';
}
