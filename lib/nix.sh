check_nix() {

if ! command -v nix &> /dev/null; then
	echo "Error: Nix Package Manager is not installed."
	exit 1
fi

}

setup_nix_flags() {
    NIX_FLAGS=()

    # Determinate Nix has flakes/nix-command enabled by default
    if nix --version 2>/dev/null | grep -qi "determinate"; then
        return
    fi

    # Normal Nix needs experimental features explicitly enabled
    NIX_FLAGS+=(--extra-experimental-features "nix-command flakes")
}

setup_nix_darwin() {

	local NIX_COMMAND
	local FLAKE_DIR="$DOTFILES_PATH/nix/nix-darwin/"
	
	if command -v darwin-rebuild &> /dev/null; then
		NIX_COMMAND=(darwin-rebuild)
	else
		NIX_COMMAND=(nix "${NIX_FLAGS[@]}" run nix-darwin/master#darwin-rebuild --)
	fi	
	
	if [[ -f "$FLAKE_DIR/flake.nix" ]] && "$GUM" confirm "is $FLAKE_DIR the correct path?"; then
		sudo "${NIX_COMMAND[@]}" switch --flake "$FLAKE_DIR"
	fi

}
