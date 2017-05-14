#!/bin/sh

NO_COLOR="\033[0m";
RED="\033[0;31m";
GREEN="\033[0;32m";
LIGHT_BLUE="\033[1;34m";

AUTO=$1

replace_dotfile()
{
  current_target=`readlink -f $link_path`;
  if [ $target_path != $current_target ]; then
    if [ $AUTO = '-a' ]; then
      rm -r $link_path;
      ln -s $target_path $link_path;
      echo "$PREFIX \t ${LIGHT_BLUE} $target ${NO_COLOR} linked";
    else
      echo -n "$PREFIX \t ${RED}$target exists${NO_COLOR}. Replace (y/n)? ";
      read answer;
      case $answer in
        [Yy]* )
          rm -r $link_path;
          ln -s $target_path $link_path;
          echo "$PREFIX \t ${LIGHT_BLUE} $target ${NO_COLOR} linked";
          ;;
        [Nn]* ) ;;
        * ) ;;
      esac
    fi
  fi
}


link_dotfiles()
{
  for target in $DOTFILES
  do
    target_path="$(pwd)/files/$target";
    link_path="$HOME/$target";

    # Link exists
    if [ -L ${link_path} ]; then
      replace_dotfile;
    # Directory exists
    elif [ -d ${link_path} ]; then
      replace_dotfile;
    # File exists
    elif [ -f ${link_path} ]; then
      replace_dotfile;
    else
      ln -s $target_path $link_path;
      echo "$PREFIX \t ${LIGHT_BLUE} $target ${NO_COLOR} linked";
    fi
  done
}


run_scripts()
{
  for script in $SCRIPTS
  do
    echo "$PREFIX Executing $script";
    sh scripts/$script;
  done
}


for config in `ls config/*.dot`
do
  if [ $AUTO = '-a' ]; then
    DOTFILES=`grep "DOTFILES" $config | cut -d= -f2`;
    SCRIPTS=`grep "SCRIPTS" $config | cut -d= -f2`;
    link_dotfiles;
    run_scripts;
  else
    NAME=`echo $config | cut -d/ -f2 | cut -d. -f1`;
    PREFIX="[${GREEN}${NAME}${NO_COLOR}]";
    echo -n "$PREFIX Configure $NAME (y/n)? ";
    read answer;
    case $answer in
      [Yy]* )
        DOTFILES=`grep "DOTFILES" $config | cut -d= -f2`;
        SCRIPTS=`grep "SCRIPTS" $config | cut -d= -f2`;
        link_dotfiles;
        run_scripts;
        ;;
      [Nn]* ) ;;
      * ) echo "[*] yes (y) or no (n)";;
    esac
  fi
done

