set -x DIR ~/repos/fishconfig
set -x ROOT (dirname $DIR)


# Add a directory to the path, if it exists
function append_dir_to_path
    set dir $argv[1]
    if [ -d "$dir" ]
        set -g -x PATH $PATH $dir
    end
end


###############################################################################
# Entry point for fish shell config
###############################################################################

# Add Cargo install path
append_dir_to_path ~/.cargo/bin

append_dir_to_path ~/Library/Python/3.7/bin
append_dir_to_path ~/Library/Python/3.8/bin
append_dir_to_path ~/Library/Python/3.9/bin

append_dir_to_path ~/repos/ttml2srt

append_dir_to_path ~/repos/pathscripts

# A useful alias for quickly tallying a set of data
alias tally "sort | uniq -c | sort"

# Quickly create and cd to a temporary directory
function tmpdir
    cd (mktemp -d)
end

function reload_fish_config
  . ~/.config/fish/config.fish
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
