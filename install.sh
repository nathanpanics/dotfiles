#!/usr/bin/env bash

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

setup_homebrew() {
    title "Setting up Homebrew"

    if test ! "$(command -v brew)"; then
	info "Homebrew not installed. Installing..."
	# Run as a login shell (non-interactive) so that the script doesn't pause for user input
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    else
	info "Homebrew already installed. Skipping..."
    fi
}

case "$1" in
    homebrew)
        setup_homebrew
	;;
    all)
	setup_homebrew
	;;
    *)
	echo -e $"\nUsage: $(basename "$0") {homebrew|all}\n}"
	exit 1
	;;
esac

echo -e
success "Done."
