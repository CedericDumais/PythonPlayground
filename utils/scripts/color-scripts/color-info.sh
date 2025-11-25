#!/bin/bash

# ===== Script: color-info.sh =====

# Locate the project root via .project-root
find_project_root() {
	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		if [[ -f "$dir/.project-root" ]]; then
			echo "$dir"
			return 0
		fi
		dir="$(dirname "$dir")"
	done
	echo "Error: .project-root not found." >&2
	return 1
}

PROJECT_ROOT="$(find_project_root)" || exit 1

# Source shared utilities
source "$PROJECT_ROOT/utils/scripts/helpers/common.sh"

# ==============================
COLOR_INFO_URL=https://figma.com/colors

# Define a list of color names (Figma-compatible only, sorted alphabetically)
colors=(
	# "Alabaster"
	"Alizarin"
	"Amaranth"
	# "Amaranthine"
	"Amber"
	"Amethyst"
	"Ash"
	"Auburn"
	# "Aureolin"
	"Azure"
	# "Bistre"
	"Bone"
	"Bottle Green"
	"Bronze"
	"Burgundy"
	"Burnt Sienna"
	"Cadmium"
	"Canary"
	# "Caput Mortuum"
	"Caramel"
	"Carmine"
	"Celadon"
	"Cerise"
	"Cerulean"
	"Chalk"
	"Charcoal"
	"Chartreuse"
	"Cinnabar"
	"Cinnamon"
	"Citrine"
	# "Coquelicot"
	"Cobalt"
	"Copper"
	"Coral"
	"Crimson"
	"Cyan"
	"Dark Gray"
	"Drunk-Tank Pink"
	"Dun"
	# "Eburnean"
	"Ecru"
	"Eggshell"
	# "Eigengrau"
	"Emerald"
	"Fallow"
	# "Falu Red"
	# "Fandango"
	"Fawn"
	# "Feldgrau"
	"Filemot"
	"Flaxen"
	# "Fulvous"
	# "Gamboge"
	"Gingerline"
	"Glaucous"
	"Gold"
	"Goldenrod"
	"Grape"
	"Greige"
	# "Harlequin"
	"Hazel"
	"Heliotrope"
	"Honey"
	"Incarnadine"
	"Indigo"
	# "Isabelline"
	"Ivory"
	"Jade"
	"Lavender"
	"Lilac"
	# "Limerick"
	# "Liseran Purple"
	"Lusty Gallant"
	"Magenta"
	"Malachite"
	"Marigold"
	# "Mauveine"
	"Melichrous"
	# "Mikado"
	"Moss"
	# "Nacarat"
	"Nankeen"
	"Ocher"
	"Olive"
	# "Orange Peel"
	"Orchid"
	"Oxblood"
	# "Payne's Grey"
	"Pea Green"
	"Periwinkle"
	"Phlox"
	"Plum"
	"Plum Dandy"
	"Pomegrenate"
	# "Pomp and Power"
	"Primrose"
	"Puce"
	# "Quinacridone Magenta"
	"Razzmatazz"
	"Roseate"
	"Rubicund"
	"Ruby"
	"Rufous"
	"Russet"
	"Sable"
	"Safflower"
	"Saffron"
	"Sanguine"
	# "Sap Green"
	"Sapphire"
	"Sarcoline"
	"Scarlet"
	"Sepia"
	"Shamrock Green"
	# "Skobeloff"
	# "Smaragdine"
	"Snow-White"
	"Snowy"
	"Snugglepuss"
	"Taupe"
	"Tawny"
	# "Thulian Pink"
	"Titian"
	"Topaz"
	"Turquoise"
	# "Tyrian Purple"
	"Umber"
	"Verdigris"
	"Vermilion"
	"Vinaceous"
	# "Violaceous"
	"Violet"
	"Viridian"
	"Wenge"
	"Wisteria"
	"Xanadu"
	"Xanthous"
	"Zaffre"
)

# Function to convert color name input to compatible URL slug
function slugify()
{
	echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d "'/" | tr ' ' '-'
}

# Prompt asking whether to choose from the list or enter a custom color
echo -e "${BBLUE}Do you want to choose a color from the list? (y/n)${NC}"
read -r choice

# if [[ "$choice" =~ ^[Yy]$ ]]; then
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
	echo -e "${BCYAN}Select a color:${NC}"
	select color in "${colors[@]}"; do
		if [[ -n "$color" ]]; then
			color_slug=$(slugify "$color")
			echo -e "${BGREEN}Opening: $COLOR_INFO_URL/$color_slug${NC}"
			# xdg-open "$COLOR_INFO_URL/$color_slug" >/dev/null 2>&1 &
			open_url "$COLOR_INFO_URL/$color_slug"
			break
		else
			echo -e "${BRED}Invalid selection.${NC}"
		fi
	done
else
	echo -e "${CYAN}Enter a color name:${NC}"
	read -r "input_color"
	color_slug=$(slugify "$input_color")
	echo -e "${BGREEN}Opening: $COLOR_INFO_URL/$color_slug${NC}"
	# xdg-open "$COLOR_INFO_URL/$color_slug" >/dev/null 2>&1 &
	open_url "$COLOR_INFO_URL/$color_slug"
fi
