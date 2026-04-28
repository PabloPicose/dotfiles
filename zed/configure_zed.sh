#!/bin/bash 
rm -rf ~/.config/zed
# cp -r ./zed ~/.config
# Create a symlink from here 
ln -s "$(pwd)/zed" ~/.config/zed
