#!/bin/bash
set -e
set +x

function installBrew()
{
	which -s brew
	if [[ $? != 0 ]] ; then
		echo "Installing brew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
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

function createBashProfile()
{
	echo "Creating ~/.bash_profile"
	content="
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ll='ls -FGlAhp'
alias less='less -FSRXc'
alias gw=./gradlew
"
	echo "$content" > ~/.bash_profile
}

function installProgramsAndTools()
{
	installBrew
  installBrewCask

  brewCaskInstall iterm2
  brewCaskInstall shiftit
  brewCaskInstall flycut
  brewCaskInstall "caskroom/cask/intellij-idea-ce"

  brewInstall tree
  brewInstall wget
	brewInstall docker
	brewInstall dockutil

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

	dockutil --add "/Applications/IntelliJ IDEA CE.app"
	dockutil --add /Applications/iTerm.app
}

function configureIterm2(){
  brewInstall "zsh zsh-completions"

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	# Load colors and font into iterm2
	curl -O https://raw.githubusercontent.com/MartinSeeler/iterm2-material-design/master/material-design-colors.itermcolors

	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
}

installProgramsAndTools
createBashProfile

createWorkspace

configureGit

#openApps

setupDock
