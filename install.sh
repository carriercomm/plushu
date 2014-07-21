#!/usr/bin/env bash
set -eo pipefail

# Setup parameters
: ${PLUSHU_ROOT:=$(cd "$(dirname "$0")" && pwd)}
: ${PLUSHU_SCRIPT:=$PLUSHU_ROOT/bin/plushu}

# Directory to install plushu script to, unset to disable
BIN_DIR=${BIN_DIR-/usr/local/bin}

# Create the plushu user if they do not exist
if ! id -u plushu >/dev/null 2>&1; then
  useradd -Md $PLUSHU_ROOT -s $PLUSHU_SCRIPT plushu
fi

# Initialize the ssh settings
mkdir -p $PLUSHU_ROOT/.ssh
touch $PLUSHU_ROOT/.ssh/authorized_keys

# Create an empty .plushurc to mark the PLUSHU_ROOT as valid and live
touch $PLUSHU_ROOT/.plushurc

# Link the plushu script into the bin dir
if [ -n $BIN_DIR ]; then
  ln -s $PLUSHU_SCRIPT $BIN_DIR
fi

# If the root is a git clone, set it to ignore new files
if [ -d $PLUSHU_ROOT/.git/info ]; then
  echo '*' > $PLUSHU_ROOT/.git/info/exclude
fi

# Set appropriate ownership and permissions
chown -R plushu $PLUSHU_ROOT
chmod g-w $PLUSHU_ROOT $PLUSHU_ROOT/.ssh $PLUSHU_ROOT/.ssh/authorized_keys
