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

fish_add_path ~/repos/.with-venv-python
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
    history save
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

###############################################################################
# Other fish config files
###############################################################################

. $DIR/_prompt.fish
. $DIR/_git.fish
. $DIR/_virtualenv.fish

# Load macOS-specific utilities
if [ (uname -s) = "Darwin" ]
    . $DIR/_macos.fish
end
