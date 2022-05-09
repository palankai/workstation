include ~/.localenv
export $(shell sed 's/=.*//' ~/.localenv)

ALL: _upgrade setup goodcleanup

setup:
	ansible-playbook -l ${WORKSTATION} -K -v setup.yml

setup-debug:
	ansible-playbook -l ${WORKSTATION} -K -vvv setup.yml

setup-unsorted:
	ansible-playbook -l ${WORKSTATION} -v -t unsorted setup.yml

setup-unsorted-debug:
	ansible-playbook -l ${WORKSTATION} -vvvv -t unsorted setup.yml

setup-unsorted-debug-sudo:
	ansible-playbook -l ${WORKSTATION} -vvvv -K -t unsorted setup.yml


cleanup:
	brew cleanup -s -v

goodcleanup:
	brew cleanup --prune 7

deepcleanup:
	brew cleanup --prune 0
	#rm -rf "$(brew --cache)"

upgrade: _upgrade _manual goodcleanup

_upgrade: _taps _galaxy
	brew update
	brew upgrade
	brew upgrade --cask

_taps:
	brew tap homebrew/cask-drivers
	brew tap wix/brew

_galaxy:
	ansible-galaxy collection install community.general

_manual:
	echo "[-] Install RVM"
	curl -sSL https://get.rvm.io | bash

tag:
	ansible-playbook -l ${WORKSTATION} -v -t ${TAG} setup.yml


doctor:
	brew doctor

brewinfo:
	echo "Size of cache:"
	@du -sh $(brew --cache)
