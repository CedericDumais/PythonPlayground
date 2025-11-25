#!/bin/bash

#TODO: fix the color categories in the groups?

# 🟢 Greens
# Xanadu		#738678 - Grayish green; named after mythical city and Coleridge’s poem
# Viridian		#40826D - Vivid bluish green; stable pigment (1859); used in art/design
# Feldgrau		#4D5D53 - Muted green-gray; military uniforms
# Skobeloff		#007474 - Deep teal; vibrant cool tone
# Chartreuse	#7FFF00 - Yellow-green; French liqueur made by Carthusian monks; bright and energetic
# Malachite		#0BDA51 - Striking green; mineral; Egyptian pigment; symb. transform/spiritual growth
# Smaragdine	#50C878 - Emerald green; Latin origin; lush foliage/stones
# Celadon		#ACE1AF - Pale green-gray; Chinese pottery; named after French novel character
# Limerick		#9DC209 - Yellowish green; Irish city; lush countryside
# Harlequin		#3FFF00 - Vivid yellow-green; named after Harlequin (Commedia dell'arte) costume
# Sap Green		#568203 - Earthy green; from unripe buckthorn berry juice; used in landscapes

# 🔴 Reds
# Amaranth			#E52B50 - Reddish-pink; flower name; Greek symb. immortality
# Vermilion			#E34234 - Brilliant red; from cinnabar; used since antiquity
# Nacarat			#FF6C49 - Bright orange; fox-fur tone; Arabic origin
# Falu Red			#801818 - Deep earthy red; Swedish houses; Falun copper mine
# Alizarin Crimson	#E32636 - Deep cool red; madder plant/synthetic; lightfast pigment; paint/textile
# Cinnabar			#FF4D4D - Bright red-orange; mineral-based; anc. Chinese lacquer/paint; symb. joy
# Coquelicot		#D2691E - Vivid poppy red; French name; WWI remembrance

# 🔵 Blues
# Zaffre			#0014A8 - Deep cobalt blue; ancient enamel/glassmaking pigment
# Glaucous			#6082B6 - Bluish-gray/greenish-gray; common in birds/plants; Latin ‘glaucus’
# Cerulean			#007BA7 - Sky blue; Latin ‘caeruleus’; evokes clear day's sky
# Bleu de France	#318CE7 - Bright French blue; national flag/sports; cultural identity
# Eigengrau			#16161D - Intrinsic dark gray; the color seen in total darkness
# Payne's Grey		#536878 - Blue-gray; watercolor artist William Payne; atmospheric use

# 🟣 Purples & Pinks
# Wisteria			#BDB5D5 - Soft purple; named after cascading flower
# Periwinkle		#CCCCFF - Pale blue-lavender; named after sea snail's shell
# Mauveine			#915C83 - Bright purple; 1856 coal tar dye; first synthetic organic dye
# Heliotrope		#DF73FF - Pinkish purple; flower that turns towards the sun; symb. devotion/love
# Razzmatazz		#E3256B - Lively reddish-pink; coined by Crayola; energy/excitement
# Fandango			#B53389 - Bold purplish pink; Spanish dance; vibrant and passionate
# Thulian Pink		#DE6FA1 - Vivid reddish pink; Thulite mineral; rare
# Pomp and Power	#B57EDC - Rich purple; evokes royalty and opulence
# Liseran Purple	#C8A2C8 - Soft pinkish purple; from lily flower; symb. purity/rebirth/maternal love
# Quinacridone Magenta	#8E3A59 - Bluish pink; pigment-based; brilliant and stable
# Tyrian Purple		#66023C - Deep purple-red; from Murex sea snail; Roman imperial dye; rarity/luxurious
# Puce				#CC8899 - Brownish purple; named after flea's bloodstain on white bg; French origin

# 🟡 Yellows & Oranges
# Gamboge		#E49B0F - Deep yellow-orange; SE Asian resin; lacquer/varnish
# Eburnean		#F8ECD4 - Ivory shade; from Latin ‘ebur’; polished tusk tone
# Citrine		#E9D66B - Lemon yellow; gemstone hue; promotes positivity, prosperity, creativity
# Aureolin		#FFBF00 - Vivid yellow; 19th-century pigment; bright and fade-resistant
# Orange Peel	#FF6600 - Reddish-orange; fruit skin tone; fresh, energetic, vitality
# Fulvous		#E48400 - Tawny yellow-brown; used in animal fur/feathers; Latin ‘fulvus’

# 🤎 Browns & Neutrals
# Isabelline	#F4F0EC - Pale gray-yellow; named after Isabella I; lore of unwashed garments
# Burnt Sienna	#E97451 - Warm reddish-brown; iron oxide; earthy art pigment
# Bistre		#3D2B1F - Dark yellowish-brown; wood soot pigment; warm undertone, depth
# Mikado		#7B3F00 - Deep yellow-brown; named for Japanese emperor; textile/lacquer hues
# Caput Mortuum	#C19A6B - Dark reddish-brown; alchemical ‘dead head’; iron oxide pigment

# Define a list of colors
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
	["Xanadu"]="738678"
	["Wisteria"]="BDB5D5"
	["Periwinkle"]="CCCCFF"
	["Viridian"]="40826D"
	["Feldgrau"]="4D5D53"
	["Glaucous"]="6082B6"
	["Skobeloff"]="007474"
	["Gamboge"]="E49B0F"
	["Fulvous"]="E48400"
	["Zaffre"]="0014A8"
	["Cerulean"]="007BA7"
	["Amaranth"]="E52B50"
	["Eigengrau"]="16161D"
	["Mauveine"]="915C83"
	["Heliotrope"]="DF73FF"
	["Chartreuse"]="7FFF00"
	["Eburnean"]="F8ECD4"
	["Razzmatazz"]="E3256B"
	["Fandango"]="B53389"
	["Malachite"]="0BDA51"
	["Vermilion"]="E34234"
	["Nacarat"]="FF6C49"
	["Isabelline"]="F4F0EC"
	["Smaragdine"]="50C878"
	["FaluRed"]="801818"
	["Celadon"]="ACE1AF"
	["Limerick"]="9DC209"
	["AlizarinCrimson"]="E32636"
	["QuinacridoneMagenta"]="8E3A59"
	["BurntSienna"]="E97451"
	["Puce"]="CC8899"
	["PaynesGrey"]="536878"
	["TyrianPurple"]="66023C"
	["Bistre"]="3D2B1F"
	["Mikado"]="7B3F00"
	["ThulianPink"]="DE6FA1"
	["BleuDeFrance"]="318CE7"
	["Coquelicot"]="D2691E"
	["CaputMortuum"]="C19A6B"
	["Aureolin"]="FFBF00"
	["PompAndPower"]="B57EDC"
	["Citrine"]="E9D66B"
	["Cinnabar"]="FF4D4D"
	["Harlequin"]="3FFF00"
	["OrangePeel"]="FF6600"
	["SapGreen"]="568203"
	["LiseranPurple"]="C8A2C8"
)

GREENS=("Green" "Xanadu" "Viridian" "Feldgrau" "Skobeloff" "Malachite" "Smaragdine" "Celadon" "Limerick" "SapGreen" "Harlequin")
REDS=("Red" "Amaranth" "Fulvous" "Vermilion" "Nacarat" "AlizarinCrimson" "Cinnabar" "FaluRed" "Coquelicot" "CaputMortuum")
BLUES=("Blue" "Cyan" "Glaucous" "Cerulean" "Zaffre" "BleuDeFrance" "PaynesGrey" "Eigengrau")
PURPLES=("Magenta" "Wisteria" "Periwinkle" "Mauveine" "Heliotrope" "Razzmatazz" "Fandango" "ThulianPink" "PompAndPower" "TyrianPurple" "LiseranPurple" "Puce")
YELLOWS=("Yellow" "Orange" "Gamboge" "Chartreuse" "Eburnean" "Citrine" "Aureolin" "OrangePeel" "Mikado")
BROWNS=("BurntSienna" "Bistre" "Isabelline" "Black" "White" "Gray")

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
	keys=()

	declare -A GROUPS=(
		["Greens"]="${GREENS[*]}"
		["Reds"]="${REDS[*]}"
		["Blues"]="${BLUES[*]}"
		["Purples"]="${PURPLES[*]}"
		["Yellows/Oranges"]="${YELLOWS[*]}"
		["Browns/Neutrals"]="${BROWNS[*]}"
	)

	for group in "${!GROUPS[@]}"; do
		echo ""
		echo "[$group]"
		for name in ${GROUPS[$group]}; do
			echo "$i) $name (${COLORS[$name]})"
			keys+=("$name")
			((i++))
		done
	done

	echo ""
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
