if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval "$(/opt/homebrew/bin/brew shellenv fish)"
set -x SSH_AUTH_SOCK ~/.ssh/proton-pass-agent.sock

#fastfetch
