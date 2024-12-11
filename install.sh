#!/usr/bin/env bash

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_GRAY}========================================${COLOR_NONE}"
    echo -e "${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}========================================${COLOR_NONE}\n"
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

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

setup_all() {
    setup_symlinks
    setup_homebrew
    setup_tpm
    setup_zsh
}

setup_symlinks() {
    title "Setting up symlinks"

    # create $HOME symlinks
    for file in $(get_linkables); do
        target="$HOME/.$(basename "$file" '.symlink')"
	if [ -e "$target" ]; then
	    info "~${target#$HOME} already exists. Skipping."
	else
	    info "Creating symlink for $file."
	    ln -s "$file" "$target"
	fi
    done

    VIMFILES=( 
        "$HOME/.vim/autopair.vim:$DOTFILES/vim/autopair.vim"
        "$HOME/.vim/coc-settings.json:$DOTFILES/vim/coc-settings.json"
    )

    FILES+=( "${VIMFILES[@]}" )

    for file in "${FILES[@]}"; do
        KEY=${file%%:*}
        VALUE=${file#*:}
        if [ -e "${KEY}" ]; then
            info "$KEY already exists. Skipping."
        else
            info "Creating symlink for $KEY"
            ln -s "${VALUE}" "${KEY}"
	fi
    done
}

setup_homebrew() {
    title "Setting up Homebrew"

    if test ! "$(command -v brew)"; then
	info "Installing Homebrew..."
	# Run as a login shell (non-interactive) so that the script doesn't pause for user input
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    else
	info "Homebrew already installed. Skipping."
    fi

    # install brew dependencies from Brewfile
    info "Installing brew bundle..."
    brew bundle
}

setup_tpm() {
    title "Setting up TPM"

    if test ! "$(command -v git)"; then
        warn "git command not installed. Skipping."
    else
	info "Installing TPM..."
	git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
    fi
}

setup_zsh() {
    title "Setting up ZSH and oh-my-zsh"

    if test ! "$(command -v brew)"; then
        warning "Homebrew not installed. Please install Homebrew to set up ZSH."
    elif test ! "$(command -v zsh)"; then
	info "Installing ZSH..."
	brew install zsh
    else
	info "ZSH already installed. Skipping."
    fi	

    if test ! "$(command -v zsh)"; then
        warning "ZSH not installed. Please install ZSH before setting up oh-my-zsh."
    elif test ! "$HOME/.oh-my-zsh"; then
	info "Installing oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
	info "Oh-My-ZSH already installed. Skipping."
    fi
}

setup_rust() {
    title "Setting up Rust"

    if test ! "$(command -v rustup)"; then
        info "Installing Rustup..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
	info "Rust already installed. Skipping."
    fi
}

case "$1" in
    help)
	echo -e $"\nUsage: $(basename "$0") [homebrew|symlinks|zsh]\n"
	exit 1
	;;
    homebrew)
        setup_homebrew
	;;
    rust)
	setup_rust
	;;
    symlinks)
	setup_symlinks
	;;
    tpm)
	setup_tpm
	;;
    zsh)
	setup_zsh
	;;
    *)
	setup_all
	;;
esac

echo -e
success "Done."
