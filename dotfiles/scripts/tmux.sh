#!/bin/sh

pip_path=`which pip || which pip3`;
if [ $? = 0 ]; then
  echo "\t Found 'pip' in $pip_path";
  echo "\t Installing tmuxp";
  $pip_path install tmuxp > /dev/null;
  if [ $? != 0 ]; then
    echo "\t Problem installing tmuxp";
  fi
else
  echo "\t Python's 'pip' not found. Skipping tmuxp";
fi


# Compile .terminfo files.
# This updates the terminfo database, allowing all
# terminal types and tmux to show italics.
# https://sookocheff.com/post/vim/italics/
tic -o $HOME/.terminfo/ $HOME/.terminfo/tmux.terminfo
tic -o $HOME/.terminfo/ $HOME/.terminfo/tmux-256color.terminfo
tic -o $HOME/.terminfo/ $HOME/.terminfo/xterm-256color.terminfo
