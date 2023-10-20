set -x DIR ~/repos/fishconfig
set -x ROOT (dirname $DIR)


###############################################################################
# Entry point for fish shell config
###############################################################################

# See https://github.com/alexwlchan/scripts
fish_add_path ~/repos/scripts/docker

fish_add_path ~/repos/scripts
fish_add_path ~/repos/scripts/aws
fish_add_path ~/repos/scripts/docker
fish_add_path ~/repos/scripts/fs
fish_add_path ~/repos/scripts/git
fish_add_path ~/repos/scripts/images
fish_add_path ~/repos/scripts/installers
fish_add_path ~/repos/scripts/macos
fish_add_path ~/repos/scripts/python
fish_add_path ~/repos/scripts/terraform
fish_add_path ~/repos/scripts/text
fish_add_path ~/repos/private-scripts

fish_add_path ~/.cargo/bin

fish_add_path ~/Library/Python/3.10/bin
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/Library/Python/3.8/bin
fish_add_path ~/Library/Python/3.7/bin

fish_add_path ~/repos/ttml2srt

# Quickly create and switch into a temporary directory
function tmpdir
    cd (mktemp -d)
end

function reload_fish_config
  . ~/.config/fish/config.fish
end

# Removes the last-typed command from my fish history.
#
# This means that if I mistype a command and it starts appearing in
# my suggested commands, I can type it one more time then purge it from
# my history, to prevent it being suggested again.
#
# See https://alexwlchan.net/2023/forgetful-fish/
# See https://github.com/fish-shell/fish-shell/issues/10066
function forget_last_command
    set last_typed_command (history --max 1)
    history delete --exact --case-sensitive "$last_typed_command"
    true
end

# Allow me to prevent certain dangerous commands from ever
# appearing in autocomplete.
#
# See https://alexwlchan.net/2023/forgetful-fish/
# See https://github.com/fish-shell/fish-shell/issues/10066
function forget_dangerous_history_commands
    set last_typed_command (history --max 1)

    if [ "$last_typed_command" = "git push origin (gcb) --force" ]
        history delete --exact --case-sensitive "$last_typed_command"
        history save
    end
end

# Only keep a single copy of my ~/.terraform plugins, rather than one copy
# per working directory
# See https://www.terraform.io/docs/configuration/providers.html#provider-plugin-cache
set -x TF_PLUGIN_CACHE_DIR ~/.terraform.d/plugin-cache


###############################################################################
# Other fish config files
###############################################################################

. $DIR/_prompt.fish
. $DIR/_git.fish

# Load macOS-specific utilities
if [ (uname -s) = "Darwin" ]
    . $DIR/_macos.fish
end

# Taken from https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e
#
# Thsi will automatically enable/disable my virtualenvs when I enter/leave directories.
#
# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.
# * Handle virtualenvs that are not located in the root of a git directory.

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return

  # Check if we are inside a git directory
  if git rev-parse --show-toplevel &>/dev/null
    set gitdir (realpath (git rev-parse --show-toplevel))
    set cwd (pwd)
    # While we are still inside the git directory, find the closest
    # virtualenv starting from the current directory.
    while string match "$gitdir*" "$cwd" &>/dev/null
      if test -e "$cwd/.venv/bin/activate.fish"
        source "$cwd/.venv/bin/activate.fish" &>/dev/null
        return
      else
        set cwd (path dirname "$cwd")
      end
    end
  end
  # If virtualenv activated but we are not in a git directory, deactivate.
  if test -n "$VIRTUAL_ENV"
    deactivate
  end
end

