#!/bin/bash
set -e
set +x

function installBrew()
{
	if ! hash brew 2>/dev/null; then
		echo "Installing brew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Updating brew"
		brew update
	fi
}

function installBrewCask()
{
	if ! brew info cask &>/dev/null; then
		echo "Installing brew cask"
		brew tap caskroom/cask
	fi
}

# $1 is the formula to install
function brewCaskInstall()
{
	if brew cask info $1 | grep "Not installed" &>/dev/null; then
		echo "Installing application using brew: $1"
		brew cask install $1
	else
		echo "Application $1 is already installed"
	fi
}

# $1 is the formula to install
function brewInstall()
{
	if brew info $1 | grep "Not installed" &>/dev/null; then
		echo "Installing using brew: $1"
		brew install $1
	else
		echo "$1 is already installed"
	fi
}

function configureGit()
{
	echo "Configuring git"
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status

  git config --global user.name "Tony Batard"
  git config --global user.email "tbatard@pivotal.io"

	git config --global core.editor "atom --wait"
}

# $1 is the package name
function installAtomPackage() {
	if ! apm list | grep atom-beautify &>/dev/null; then
		apm install $1
	else
		echo "$1 atom package is already installed"
	fi
}

function configureAndInstallAtom()
{
  brewCaskInstall atom
	echo "Configuring atom"
	installAtomPackage Sublime-Style-Column-Selection
	installAtomPackage atom-beautify
	installAtomPackage atom-ternjs
	installAtomPackage atom-transpose
	installAtomPackage atom-wrap-in-tag
	installAtomPackage autoclose-html
	installAtomPackage autocomplete-modules
	installAtomPackage busy-signal
	installAtomPackage change-case
	installAtomPackage color-picker
	installAtomPackage copy-path
	installAtomPackage duplicate-line-or-selection
	installAtomPackage file-icons
	installAtomPackage highlight-selected
	installAtomPackage hyperclick
	installAtomPackage intentions
	installAtomPackage js-hyperclick
	installAtomPackage language-babel
	installAtomPackage linter
	installAtomPackage linter-ui-default
	installAtomPackage local-history
	installAtomPackage pigments
	installAtomPackage prettier-atom
	installAtomPackage project-manager
	installAtomPackage related
	installAtomPackage sort-lines
	installAtomPackage tab-foldername-index
	installAtomPackage toggle-quotes
}

function copyUserZshrc()
{
	cp .zshrc ~/
}

function installProgramsAndTools()
{
	installBrew
  installBrewCask

  brewCaskInstall iterm2
  brewCaskInstall shiftit
  brewCaskInstall flycut
  brewCaskInstall "caskroom/versions/java8"
  brewCaskInstall "caskroom/cask/intellij-idea"

  brewInstall tree
  brewInstall wget
	brewInstall docker
	brewInstall dockutil

	brew tap cloudfoundry/tap
	brewInstall cf-cli

  configureAndInstallAtom
}

function openApps()
{
	open -a ShiftIt
	open -a Flycut
	open -a "IntelliJ IDEA CE"
}

function createWorkspace() {
	mkdir -p ~/workspace
}

function setupDock() {
	defaults write com.apple.dock autohide-time-modifier -float 1; killall Dock

	dockutil --remove Mail
	dockutil --remove Contacts
	dockutil --remove Calendar
	dockutil --remove Notes
	dockutil --remove Reminders
	dockutil --remove Maps
	dockutil --remove Photos
	dockutil --remove Messages
	dockutil --remove FaceTime
	dockutil --remove iTunes
	dockutil --remove iBooks

	dockutil --add "/Applications/IntelliJ IDEA.app"
	dockutil --add /Applications/iTerm.app
}

function configureIterm2(){
  brewInstall "zsh zsh-completions zsh-syntax-highlighting"

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	ZSH_CUSTOM=~/.oh-my-zsh/custom/
	if [ ! -d "$ZSH_CUSTOM/themes/powerlevel9k" ]; then
		git clone https://github.com/bhilburn/powerlevel9k.git $ZSH_CUSTOM/themes/powerlevel9k
	fi
	if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
		git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
	fi
}

# installProgramsAndTools

# configureIterm2
copyUserZshrc

# createWorkspace

# configureGit

# setupDock

#openApps
