#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-homebrew.sh
##  Desc:  Install Homebrew
################################################################################

source ~/utils/utils.sh

arch=$(get_arch)

echo "Installing Homebrew..."
homebrew_installer_path=$(download_with_retry "https://raw.githubusercontent.com/Homebrew/install/master/install.sh")
/bin/bash $homebrew_installer_path

if [[ $arch == "arm64" ]]; then
  /opt/homebrew/bin/brew update
  /opt/homebrew/bin/brew upgrade
  /opt/homebrew/bin/brew upgrade --cask
  /opt/homebrew/bin/brew cleanup
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

git clone https://github.com/Homebrew/homebrew-cask $(brew --repository)/Library/Taps/homebrew/homebrew-cask --origin=origin --template= --config core.fsmonitor=false --depth 1
git clone https://github.com/Homebrew/homebrew-core $(brew --repository)/Library/Taps/homebrew/homebrew-core --origin=origin --template= --config core.fsmonitor=false --depth 1

brew tap homebrew/cask
brew tap homebrew/core

echo "Disabling Homebrew analytics..."
brew analytics off

# jq is required for further installation scripts
echo "Installing jq..."
brew_smart_install jq

echo "Installing curl..."
brew_smart_install curl

echo "Installing wget..."
brew_smart_install "wget"
