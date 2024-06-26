#!/usr/bin/env bash

# Creates a new file in TIL folder, adds a comment with the date and tags,
# and opens it in VS Code.
#
# This script should be used from Alfred workflow.
#
# Author: Artem Sapegin, sapegin.me
# License: MIT
# https://github.com/sapegin/dotfiles
#

PROJECT_DIR="$HOME/_/til/"
FILEPATH_EXT=".md"
DATE_FORMAT="%Y-%m-%d"

# Common stuff
function error() {
	$HOME/dotfiles/bin/dlg-error "$1" "TIL"
	exit 1
}
function ask() {
	$HOME/dotfiles/bin/dlg-prompt "$1" "$2" "TIL"
}

# Ask user to enter the title
title=$(ask "Post title:" "$title")
if [ -z "$title" ]; then
	error "You need to enter a post title."
fi

# Default slug: convert CamelCase or plain text file name to under_score, strip extension
slug=$(
	echo "$title" \
		|
		# To lower case
		perl -pe 's/([A-Z])/\l\1/g' \
		|
		# Spaces to dashes
		perl -pe 's/ /-/g' \
		|
		# Remove double spaces
		perl -pe 's/--/-/g' \
		|
		# Remove dash in the beginning
		perl -pe 's/^-//'
)

# Ask user to review the slug
slug=$(ask "Post slug:" "category/$slug")
if [ -z "$slug" ]; then
	error "You need to enter a post slug."
fi

# Destination Markdown file path
dest="$PROJECT_DIR$slug$FILEPATH_EXT"

# Check dest file existence
if [ -f "$dest" ]; then
	error "Destination file $dest already exists."
fi

# Publishing date (today)
date=$(date +"$DATE_FORMAT")

# Tags: category by default
tags=$(
	echo "$slug" \
		| perl -pe 's/\/[^/]+$//' # Remove everything after /
)

# Create destination directory if needed
mkdir -p $(dirname $(echo $dest))

# Copy template to destination folder
sed -e "s^{date}^$date^" -e "s^{tags}^$tags^" -e "s^{title}^$title^" "$(dirname $0)/til-post-new.tmpl" > "$dest"

# Open the file in the editor ($EDITOR isn’t available in Alfred)
code "$PROJECT_DIR" "$dest"
