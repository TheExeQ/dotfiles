ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$ROOT/bin"
GUM="$BIN_DIR/gum"

mkdir -p "$BIN_DIR"


install_gum() {
    if [[ -x "$GUM" ]]; then
        echo "gum already installed"
        return
    fi

    echo "Installing gum..."

    local os arch gum_os gum_arch version archive tmp_dir

    os="$(uname -s)"
    arch="$(uname -m)"

    case "$os" in
        Darwin)
            gum_os="Darwin"
            ;;
        Linux)
            gum_os="Linux"
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac

    case "$arch" in
        arm64|aarch64)
            gum_arch="arm64"
            ;;
        x86_64)
            gum_arch="x86_64"
            ;;
        *)
            echo "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    version="0.16.0"

    archive="gum_${version}_${gum_os}_${gum_arch}.tar.gz"

    tmp_dir="$(mktemp -d)"

    echo "Downloading gum ${version}..."

    curl -fsSL \
        "https://github.com/charmbracelet/gum/releases/download/v${version}/${archive}" \
        -o "$tmp_dir/gum.tar.gz"


    echo "Extracting..."

    tar -xzf "$tmp_dir/gum.tar.gz" -C "$tmp_dir"


    gum_binary="$(find "$tmp_dir" -type f -name gum | head -n 1)"

    if [[ -z "$gum_binary" ]]; then
        echo "Could not find gum binary after extraction"
        rm -rf "$tmp_dir"
        exit 1
    fi


    mv "$gum_binary" "$GUM"

    chmod +x "$GUM"

    rm -rf "$tmp_dir"


    if ! "$GUM" --version >/dev/null; then
        echo "gum installation failed"
        exit 1
    fi

    echo "Installed gum:"
    "$GUM" --version
}
