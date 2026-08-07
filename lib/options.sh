# Bootstrap.sh options
_bootstrap_usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help              Show this help message
  -D, --uninstall         Uninstall stow setup
EOF
  exit 0
}

bootstrap_parse_args() {
  DRY_RUN=""
  VERBOSE=""
  UNINSTALL=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      _bootstrap_usage
      ;;
    -D | --uninstall)
      UNINSTALL="-D"
      ;;
    *)
      echo "Error: Unknown option '$1'" >&2
      _bootstrap_usage
      ;;
    esac
    shift
  done
}
