#!/bin/bash

# Function to check if ImageMagick is installed
check_imagemagick()
{
	if ! command -v convert &> /dev/null; then
		echo "ImageMagick is not installed."
		read -p "Do you want to install it now? [y/N]: " choice
		if [[ "$choice" =~ ^[Yy]$ ]]; then
			sudo apt update && sudo apt install -y imagemagick
		else
			echo "Cannot proceed without ImageMagick. Exiting."
			exit 1
		fi
	fi
}

# Function to prompt for a valid hex color
get_hex_color()
{
	while true; do
		read -p "Enter a 6-digit hex color code (e.g., FF5733): " COLOR
		if [[ "$COLOR" =~ ^[0-9A-Fa-f]{6}$ ]]; then
			COLOR=${COLOR^^} # Convert to uppercase
			break
		else
			echo "Invalid hex color. Please enter exactly 6 hexadecimal digits."
		fi
	done
}

# Function to generate the PNG
generate_png()
{
	OUTPUT="pixel_${COLOR}.png"
	convert -size 1x1 xc:"#${COLOR}" "$OUTPUT"
	echo "Generated 1x1 PNG: $OUTPUT"
}

# Run steps
check_imagemagick
get_hex_color
generate_png


###

