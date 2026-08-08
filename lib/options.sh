# Bootstrap.sh options
_bootstrap_usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help              Show this help message
  -y, --yes               Skip confirmations
  -D, --uninstall         Uninstall dotfiles setup
EOF
  exit 0
}

bootstrap_parse_args() {
  UNINSTALL=""
  YES=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      _bootstrap_usage
      ;;
    -y | --yes)
      YES=1
      ;;
    -D | --uninstall)
      UNINSTALL=1
      ;;
    *)
      echo "Error: Unknown option '$1'" >&2
      _bootstrap_usage
      ;;
    esac
    shift
  done
}
