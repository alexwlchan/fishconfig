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
fish_add_path ~/repos/scripts/wellcome
fish_add_path ~/repos/private-scripts

fish_add_path ~/.cargo/bin

fish_add_path ~/Library/Python/3.10/bin
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/Library/Python/3.8/bin
fish_add_path ~/Library/Python/3.7/bin

fish_add_path ~/repos/ttml2srt

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
