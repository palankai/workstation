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

echo "[-] Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "[-] Install ansible..."
brew install ansible

echo "[-] Install gnupg..."
brew install gnupg pinentry-mac
echo "  [-] Initialise GPG"
gpg -k
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
echo "  [-] Start GPG Agent"
gpgconf --launch gpg-agent
echo "  [-] Setup temporary SSH Agent"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh


echo "[-] Install cloning workstation setup..."
mkdir -p ~/opt

if test ! -d "~/opt/workstation" ; then
  echo "[-] Clone workstation setup"
  (cd ~/opt; git clone git@gitlab.com:palankai/workstation.git)
else
  echo "[-] update workstation setup"
  (cd ~/opt/workstation; git pull)
fi

rm ~/.gnupg/gpg-agent.conf
rm ~/.gnupg/gpg.conf
ln -s ~/opt/workstation/dotfiles/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -s ~/opt/workstation/dotfiles/gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -s ~/opt/workstation/dotfiles/gnupg/scdaemon.conf ~/.gnupg/scdaemon.conf

killall gpg-agent
gpgconf --launch gpg-agent
# gpg-agent --daemon --homedir $HOME/.gnupg

ln -s ~/opt/workstation/bin/homebrew.gpg.gpg-agent.plist ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist
launchctl load -F ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist

export KEYID=0x4C4A8C7E5C4575B7

echo "[*] DONE."