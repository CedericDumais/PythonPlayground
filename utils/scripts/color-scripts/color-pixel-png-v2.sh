#!/bin/bash

# Define a list of classic colors
declare -A COLORS=(
	["Red"]="FF0000"
	["Green"]="00FF00"
	["Blue"]="0000FF"
	["Black"]="000000"
	["White"]="FFFFFF"
	["Yellow"]="FFFF00"
	["Cyan"]="00FFFF"
	["Magenta"]="FF00FF"
	["Orange"]="FFA500"
	["Gray"]="808080"
)

# **OR

# # Define a list of custom inspired colors
# declare -A COLORS=(
# 	["Xanadu"]="738678"
# 	["Wisteria"]="BDB5D5"
# 	["Periwinkle"]="CCCCFF"
# 	["Viridian"]="40826D"
# 	["Feldgrau"]="4D5D53"
# 	["Glaucous"]="6082B6"
# 	["Skobeloff"]="007474"
# 	["Gamboge"]="E49B0F"
# 	["Fulvous"]="E48400"
# 	["Zaffre"]="0014A8"
# 	["Cerulean"]="007BA7"
# 	["Amaranth"]="E52B50"
# 	["Eigengrau"]="16161D"
# 	["Mauveine"]="915C83"
# 	["Heliotrope"]="DF73FF"
# 	["Chartreuse"]="7FFF00"
# 	["Eburnean"]="F8ECD4"
# 	["Razzmatazz"]="E3256B"
# 	["Fandango"]="B53389"
# 	["Malachite"]="0BDA51"
# 	["Vermilion"]="E34234"
# 	["Nacarat"]="FF6C49"
# 	["Isabelline"]="F4F0EC"
# 	["Smaragdine"]="50C878"
# 	["FaluRed"]="801818"
# 	["Celadon"]="ACE1AF"
# 	["Limerick"]="9DC209"
# 	["AlizarinCrimson"]="E32636"
# 	["QuinacridoneMagenta"]="8E3A59"
# 	["BurntSienna"]="E97451"
# 	["Puce"]="CC8899"
# 	["PaynesGrey"]="536878"
# 	["TyrianPurple"]="66023C"
# 	["Bistre"]="3D2B1F"
# 	["Mikado"]="7B3F00"
# 	["ThulianPink"]="DE6FA1"
# 	["BleuDeFrance"]="318CE7"
# 	["Coquelicot"]="D2691E"
# 	["CaputMortuum"]="C19A6B"
# 	["Aureolin"]="FFBF00"
# 	["PompAndPower"]="B57EDC"
# 	["Citrine"]="E9D66B"
# 	["Cinnabar"]="FF4D4D"
# 	["Harlequin"]="3FFF00"
# 	["OrangePeel"]="FF6600"
# 	["SapGreen"]="568203"
# 	["LiseranPurple"]="C8A2C8"
# )

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

# Function to prompt for a color choice or custom hex
get_color_choice() {
	echo "Choose a color from the list or enter a custom hex code:"
	i=1
	keys=("${!COLORS[@]}")
	for name in "${keys[@]}"; do
		echo "$i) $name (${COLORS[$name]})"
		((i++))
	done
	echo "$i) Enter custom hex code"

	read -p "Your choice [1-$i]: " choice

	if [[ "$choice" -ge 1 && "$choice" -lt "$i" ]]; then
		COLOR="${COLORS[${keys[$((choice-1))]}]}"
	elif [[ "$choice" -eq "$i" ]]; then
		get_custom_hex
	else
		echo "Invalid selection. Try again."
		get_color_choice
	fi
}

# Function to validate custom hex input
get_custom_hex() {
	while true; do
		read -p "Enter a 6-digit hex color code (e.g., FF5733): " input
		if [[ "$input" =~ ^[0-9A-Fa-f]{6}$ ]]; then
			COLOR="${input^^}"
			break
		else
			echo "Invalid hex color. Please enter exactly 6 hexadecimal digits."
		fi
	done
}

# Function to generate the PNG
generate_png() {
	OUTPUT="pixel_${COLOR}.png"
	convert -size 1x1 xc:"#${COLOR}" "$OUTPUT"
	echo "Generated 1x1 PNG: $OUTPUT"
}

# Run the script
check_imagemagick
get_color_choice
generate_png
