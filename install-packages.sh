#!/bin/bash
echo "Installing user packages..."
if [ -f "user-installed-packages.txt" ]; then
    sudo dnf install -y $(cat user-installed-packages.txt | tr '\n' ' ')
else
    echo "Package list file not found!"
fi
