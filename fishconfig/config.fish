set DIR (cd (dirname (status -f)); and pwd) 


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

# Add pipsi install path
append_dir_to_path ~/.local/bin

# Add Cargo install path
append_dir_to_path ~/.cargo/bin

# A useful alias for quickly tallying a set of data
alias tally "sort | uniq -c | sort"

# Quickly create and cd to a temporary directory
function tmpdir
    set dir (mktemp -d)
    cd $dir
end

# Alias for finding out which subdirectories of the current dir contain
# the most files.  Useful when trying to find wasted disk space.
alias cdir 'for l in (ls); if [ -d $l ]; echo (find $l | wc -l)"  $l"; end; end | sort'


###############################################################################
# virtualfish -- a fish wrapper for virtualenv
# https://github.com/adambrenecki/virtualfish
###############################################################################
eval (python -m virtualfish auto_activation) >> /dev/null 2>&1


###############################################################################
# Other fish config files
###############################################################################

# Load my custom Fish prompt
. $DIR/prompt.fish

# Load my Git aliases
. $DIR/git.fish

# Load macOS-specific utilities
if [ (uname -s) = "Darwin" ]
    . $DIR/macos.fish
end
