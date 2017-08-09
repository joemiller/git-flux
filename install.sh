#!/bin/bash

NAME="git-flux"
INSTALL_PATH=${INSTALL_PATH:="/usr/local/bin"}
INSTALL_PATH_LOCAL=${INSTALL_PATH_LOCAL:="$HOME/bin/"}
WHEREAMI=$(dirname "$0")

EXEC_FILES="git-flux"
SRC_FILES="git-flux-checkout git-flux-env git-flux-feature \
git-flux-init git-flux-publish git-flux-up git-flux-version \
gitflux-common"

case "$1" in
    install)
        echo "Installing $NAME to $INSTALL_PATH"
        install -v -d -m 0755 "$INSTALL_PATH"
        for file in $EXEC_FILES ; do
            install -v -m 0755 "$WHEREAMI/$file" "$INSTALL_PATH"
        done
        for file in $SRC_FILES ; do
            install -v -m 0644 "$WHEREAMI/$file" "$INSTALL_PATH"
        done
        exit
        ;;
    uninstall)
        echo "Uninstalling $NAME from $INSTALL_PATH"
        for file in $EXEC_FILES $SRC_FILES ; do
            echo "rm -f $INSTALL_PATH/$file"
            rm -f "$INSTALL_PATH/$file"
        done
        exit
        ;;
    local_install)
        echo "Installing locally $NAME to $INSTALL_PATH_LOCAL"
        if [ ! -d  "$INSTALL_PATH_LOCAL" ]; then
            mkdir -p "$INSTALL_PATH_LOCAL"
        fi
        for file in $EXEC_FILES ; do
            install -v -m 0755 "$WHEREAMI/$file" "$INSTALL_PATH_LOCAL"
        done
        for file in $SRC_FILES ; do
            install -v -m 0644 "$WHEREAMI/$file" "$INSTALL_PATH_LOCAL"
        done
        exit
      ;;
    *)
        echo "Usage: [environment] $0 [install|uninstall|local_install]"
        echo "Environment:"
        echo "   INSTALL_PATH=$INSTALL_PATH for option install"
        echo "   INSTALL_PATH_LOCAL=$INSTALL_PATH_LOCAL for option local_install"
        exit
        ;;
esac
