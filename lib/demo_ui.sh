demo_ui() {
  clear

  echo
  echo "================================"
  echo "       Dotfiles UI Demo"
  echo "================================"
  echo

  echo "Multi-select:"
  selections=$(
    "$GUM" choose \
      --no-limit \
      "Install Homebrew" \
      "Install Fish Shell" \
      "Install Neovim" \
      "Install Fonts"
  )

  echo
  echo "Selected:"
  echo "$selections"

  echo
  echo "Single selection:"
  profile=$(
    "$GUM" choose \
      "Minimal" \
      "Developer" \
      "Full Setup"
  )

  echo "Profile: $profile"

  echo
  echo "Text input:"
  username=$(
    "$GUM" input \
      --placeholder "Your name"
  )

  echo "Username: $username"

  echo
  if "$GUM" confirm "Continue?"; then
    echo "Continuing..."
  else
    echo "Cancelled"
  fi

  echo
  "$GUM" spin \
    --spinner dot \
    --title "Running fake installation..." \
    -- sleep 3

  echo

  "$GUM" style \
    --foreground 212 \
    --border double \
    --padding "1 3" \
    "Setup complete!"
}
