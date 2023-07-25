###############################################################################
# macOS-specific shell config
###############################################################################

# Provide a convenient alias for the front URL in both browsers
alias furl="safari url"
alias gurl="osascript -e 'tell application \"Google Chrome\" to tell front window to get URL of tab (active tab index)'"


# Get the URL of the frontmost GitHub page and clone it
function gh-clone
    _ensure_ssh_key_loaded
    github-clone (furl)
end
