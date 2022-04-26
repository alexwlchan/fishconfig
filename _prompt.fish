###############################################################################
# My fish prompt
#
# This has been inspired by various examples from other people, not all
# of whom I kept notes of.
###############################################################################

set -g -x fish_greeting ''


function print_current_directory
  set_color green
  printf (echo -n (prompt_pwd))
  set_color normal
end


function print_git_information
  which git 2>&1 >/dev/null
  if [ $status = "0" ]
    set branch (git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$branch" ]
      set_color normal
      printf " on git:"
      set_color cyan
      printf "$branch"
    end
  end
  set_color normal
end


# If I'm running over SSH, prepend the name of the remote host to
# the context line.
function print_ssh_information
  if set -q SSH_CLIENT
    printf "("
    set_color purple
    printf (echo -n (hostname))
    set_color normal
    printf ") "
  end
end


function fish_prompt
  # Put a newline between new prompts for cleanliness, but not on the first run.
  #
  # This means the first prompt of a new session is right at the top of
  # the terminal window, not with a newline above it.
  if set -q SSH_CLIENT
    if test \( -f "/tmp/$SSH_CONNECTION" \)
      echo ''
    end

    touch "/tmp/$SSH_CONNECTION" 2>/dev/null
  else
    if test \( -f "/tmp/$TERM_SESSION_ID" -o -f "/tmp/$XDG_SESSION_ID" \)
      echo ''
    end

    touch "/tmp/$TERM_SESSION_ID" 2>/dev/null
    touch "/tmp/$XDG_SESSION_ID" 2>/dev/null
  end

  # Print some context about where I'm running this command.
  #
  # If I'm in my home directory, the context isn't very interesting (it's where
  # new shells open, and it's not in Git), so skip the context line to reduce
  # visual noise.
  if [ (prompt_pwd) = "~" ]
    if set -q SSH_CLIENT
      print_ssh_information
      echo ''
    end
    echo '$ '
    return
  end

  print_ssh_information
  print_current_directory
  print_git_information

  # Print the shell prompt.
  #
  # I have a different prompt for when I'm running as root; admittedly this
  # is extremely rare if I'm also using fish, but if I am I want a visual cue
  # that this terminal is unusual.
  #
  # I print the prompt on a separate line to the context information so it's
  # always in the same place: as I'm typing commands, I get the full width of
  # the terminal to use, rather than a variable amount based on the context line.
  set_color normal
  if [ "$USER" = "root" ]
    echo '' & echo '# '
  else
    echo '' & echo '$ '
  end
end
