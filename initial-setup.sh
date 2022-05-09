#!/bin/sh

set -e

if test ! -f "$HOME/.localenv" ; then
    PS3='Select workstation setup: '
    options=("personal" "work" "Quit")
        select opt in "${options[@]}"
    do
        case $opt in
            "personal")
                echo "Setting up for personal"
                WORKSTATION=personal
                break
                ;;
            "work")
                echo "Setting up for made"
                WORKSTATION=work
                break
                ;;
            "Quit")
                exit
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done

    echo "WORKSTATION=$WORKSTATION" >> $HOME/.localenv

else
    source $HOME/.localenv
fi

echo "[-] Make links folder"
mkdir -p ~/opt/links

echo "[-] Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "[-] Install ansible..."
brew install ansible

echo "[-] Install gnupg..."
brew install gnupg pinentry-mac

echo "  [-] Initialise GPG"
gpg -k

echo "  [-] Setup links"
ln -sF $(which pinentry-mac) ~/opt/links/pinentry-mac
ln -sF $(which gpgconf) ~/opt/links/gpgconf

# Fix this, this isn't idempotent
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
echo "  [-] Start GPG Agent"
killall gpg-agent
gpg-agent --daemon --homedir $HOME/.gnupg

echo "  [-] Setup temporary SSH Agent"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

echo "[-] Install cloning workstation setup..."
mkdir -p ~/opt

if test ! -d "~/opt/workstation" ; then
  echo "[-] Clone workstation setup"
  (cd ~/opt; git clone git@github.com:palankai/workstation.git)
else
  echo "[-] update workstation setup"
  (cd ~/opt/workstation; git pull)
fi

echo "[-] Clone sensitive workstation files"
(cd ~/opt; git submodule update --init --recursive)

rm ~/.gnupg/gpg-agent.conf
rm ~/.gnupg/gpg.conf
ln -s ~/opt/workstation/dotfiles/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -s ~/opt/workstation/dotfiles/gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -s ~/opt/workstation/dotfiles/gnupg/scdaemon.conf ~/.gnupg/scdaemon.conf

killall gpg-agent
# gpgconf --launch gpg-agent
gpg-agent --daemon --homedir $HOME/.gnupg

ln -s ~/opt/workstation/bin/homebrew.gpg.gpg-agent.plist ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist
launchctl load -F ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist

export KEYID=0x4C4A8C7E5C4575B7

echo "[*] DONE."
