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


function fish_prompt
  # Put a newline between new prompts for cleanliness, but not on the first run.
  #
  # This means the first prompt of a new session is right at the top of
  # the terminal window, not with a newline above it.
  if test \( -f "/tmp/$TERM_SESSION_ID" -o -f "/tmp/$XDG_SESSION_ID" \)
    echo ''
  end

  touch /tmp/$TERM_SESSION_ID 2>/dev/null
  touch /tmp/$XDG_SESSION_ID 2>/dev/null

  # Print some context about where I'm running this command.
  #
  # If I'm in my home directory, the context isn't very interesting (it's where
  # new shells open, and it's not in Git), so skip the context line to reduce
  # visual noise.
  if [ (prompt_pwd) = "~" ]
    echo '$ '
    return
  end

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
