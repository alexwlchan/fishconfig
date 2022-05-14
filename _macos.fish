###############################################################################
# macOS-specific shell config
###############################################################################

# Provide a convenient alias for the front URL in both browsers
alias furl="safari url"
alias gurl="osascript -e 'tell application \"Google Chrome\" to tell front window to get URL of tab (active tab index)'"


# Open the current working directory as a Git repository in GitUp
function gup
    set top_level (git rev-parse --show-toplevel)
    if [ "$status" -eq "0" ]
        open -a GitUp.app $top_level
        return 0
    else
        return 1
    end
end


# Get the URL of the frontmost GitHub page and clone it
function gh-clone
    github-clone (furl)
end
