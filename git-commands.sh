#!/usr/bin/env bash -eu

# git log formats
git log --relative-date --pretty=format:"%cd %ad %s" --grep=bash
git log --relative-date --pretty=format:"%ad %s" --until="12 hours ago"
git log --relative-date --pretty=format:"%cd %ad %s" -Sbash

# show details on the remote origin
git remote show origin

# Alias Examples
git config --global alias.co checkout  # git co
git config --global alias.br branch    # git br
git config --global alias.ci commit    # git ci
git config --global alias.st status    # git st

git config --global alias.unstage 'reset HEAD --' # git unstage <filename>
git config --global alias.last 'log -1 HEAD'      # git last

# Alias External Command
git config --global alias.visual '!gitk'  #  git visual;  <-- Opens gitk external program

# show branch and tag pointers
git log --oneline --decorate --graph --all

