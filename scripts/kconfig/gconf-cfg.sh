#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

PKG_GTK4="gtk4 gtk-mac-integration"
PKG_GTK3="gtk+-3.0"
PKG_GTK2="gtk+-2.0 gmodule-2.0 libglade-2.0"

# Check for pkg-config availability
if [ -z "$(command -v pkg-config)" ]; then
    echo >&2 "*"
    echo >&2 "* 'make gconfig' requires 'pkg-config'. Please install it."
    echo >&2 "*"
    exit 1
fi

# Check for GTK+ 4.0 first
if pkg-config --exists $PKG_GTK4 && pkg-config --atleast-version=4.0.0 gtk4; then
    echo "* Found GTK+ 4.0"
    PKG_INSTALLED="$PKG_GTK4"

# If GTK+ 4.0 is not available, check for GTK+ 3.0
elif pkg-config --exists $PKG_GTK3 && pkg-config --atleast-version=3.0.0 gtk+-3.0; then
    echo "* Found GTK+ 3.0"
    PKG_INSTALLED="$PKG_GTK3"

# If GTK+ 3.0 is not available, check for GTK+ 2.0
elif pkg-config --exists $PKG_GTK2 && pkg-config --atleast-version=2.0.0 gtk+-2.0; then
    echo "* Found GTK+ 2.0"
    PKG_INSTALLED="$PKG_GTK2"

else
    echo >&2 "*"
    echo >&2 "* No compatible GTK version found. Ensure that the GTK development package is installed."
    echo >&2 "*"
    exit 1
fi

# Output the cflags and libs for the highest detected GTK version
echo "cflags=\"$(pkg-config --cflags $PKG_INSTALLED)\""
echo "libs=\"$(pkg-config --libs $PKG_INSTALLED)\""

