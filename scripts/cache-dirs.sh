#!/bin/bash

ls -d /tmp > ~/.config/directories
ls -d /nettmp >> ~/.config/directories
ls -d ~/dotfiles >> ~/.config/directories
ls -d ~/shared/*/ >> ~/.config/directories
ls -d ~/projects/*/ >> ~/.config/directories
ls -d ~/work/*/ >> ~/.config/directories
ls -d ~/Pictures/*/ >> ~/.config/directories
ls -d ~/Documents/*/ >> ~/.config/directories
ls -d ~/Videos/*/ >> ~/.config/directories
ls -d ~/Music/*/ >> ~/.config/directories
ls -d ~/Music/byLanguage/ >> ~/.config/directories

exit 0
