#!/bin/bash -ex

# Let Berkshelf work in the temporary directory
export BERKSHELF_PATH="$WORKSPACE/.berkshelf"

# If we have a .bashrc, load it
if [ -f ~/chefdk-init.sh ]; then
  source ~/chefdk-init.sh
fi

# Launch foodcritic
foodcritic .

# Update local dependencies
berks install
berks update

kitchen test -d always
