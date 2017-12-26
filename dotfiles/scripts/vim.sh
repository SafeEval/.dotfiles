#!/bin/sh


# Install plugins
echo "\t Installing vim plugins";
echo -ne '\n' | vim +PlugInstall +qall;
