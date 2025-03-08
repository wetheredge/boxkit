#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

grep -v '^#' ./coprs | xargs -n 1 dnf copr enable -y

# Update the container and install packages
dnf update -y
grep -v '^#' ./packages | xargs dnf install -y
