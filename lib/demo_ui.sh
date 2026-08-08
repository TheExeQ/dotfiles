demo_ui() {
  clear

  echo
  echo "================================"
  echo "       Dotfiles UI Demo"
  echo "================================"
  echo

  echo "Multi-select:"
  selections=$(
    run_gum choose \
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
    run_gum choose \
      "Minimal" \
      "Developer" \
      "Full Setup"
  )

  echo "Profile: $profile"

  echo
  echo "Text input:"
  username=$(
    run_gum input \
      --placeholder "Your name"
  )

  echo "Username: $username"

  echo
  if run_gum confirm "Continue?"; then
    echo "Continuing..."
  else
    echo "Cancelled"
  fi

  echo
  run_gum spin \
    --spinner dot \
    --title "Running fake installation..." \
    -- sleep 3

  echo

  run_gum style \
    --foreground 212 \
    --border double \
    --padding "1 3" \
    "Setup complete!"
}
