inputs:
let
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system; };
  
  asdfVersion = inputs.asdfVersion or "0.14.0";
  asdfSha256 = inputs.asdfSha256 or "sha256-PLACEHOLDER";
  
  asdf = pkgs.stdenv.mkDerivation {
    pname = "asdf-vm";
    version = asdfVersion;
    
    src = pkgs.fetchFromGitHub {
      owner = "asdf-vm";
      repo = "asdf";
      rev = "v${asdfVersion}";
      sha256 = asdfSha256;
    };
    
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
      chmod +x $out/bin/asdf
    '';
  };
  
in pkgs.mkShell {
  buildInputs = with pkgs; [
    asdf
    git
    curl
  ];
  shellHook = ''
    export ASDF_DIR="${asdf}"
    export ASDF_DATA_DIR="$PWD/.asdf-test"
    export PATH="$ASDF_DIR/bin:$PATH"
    
    # Source asdf
    source $ASDF_DIR/asdf.sh
    
    # Create function file and source it
    cat > /tmp/asdf_functions.sh << 'EOF'
install_asdf_plugins() {
      if [ -f ".tool-versions" ]; then
        echo "📦 Installing asdf plugins from .tool-versions..."
        while IFS= read -r line; do
          # Skip empty lines and comments
          [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
          
          # Extract plugin name (first word)
          plugin=$(echo "$line" | awk '{print $1}')
          
          if [ -n "$plugin" ]; then
            echo "Installing plugin: $plugin"
            asdf plugin add "$plugin" 2>/dev/null || echo "Plugin $plugin already installed or failed to install"
          fi
        done < ".tool-versions"
        echo "✅ Plugin installation complete"
      else
        echo "❌ No .tool-versions file found"
      fi
    }
EOF
    source /tmp/asdf_functions.sh
    
    echo "ASDF test environment loaded"
    echo "📦 asdf version: ${asdfVersion}"
    echo "💡 Run 'install_asdf_plugins' to install plugins from .tool-versions"
  '';
}