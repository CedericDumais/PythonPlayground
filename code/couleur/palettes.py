# couleur/palettes.py
"""
"""

PALETTE_ARC_EN_CIEL = (
    0xFF0000,  # rouge
    0xFF7F00,  # orange
    0xFFFF00,  # jaune
    0x7FFF00,  # jaune-vert (chartreuse)
    0x00FF00,  # vert
    0x00FF7F,  # vert printemps (spring green)
    0x00FFFF,  # cyan
    0x007FFF,  # bleu azur
    0x0000FF,  # bleu
    0x7F00FF,  # violet
)

# PALETTE_ARC_EN_CIEL = Palette("Arc-en-ciel", (
#     0xFF0000, 0xFF7F00, 0xFFFF00, 0x7FFF00, 0x00FF00,
#     0x00FF7F, 0x00FFFF, 0x007FFF, 0x0000FF, 0x7F00FF
# ))

# Pastel "sorbets"
PALETTE_PASTEL = (
    0xFFADAD, 0xFFD6A5, 0xFDFFB6, 0xCAFFBF, 0x9BF6FF,
    0xA0C4FF, 0xBDB2FF, 0xFFC6FF, 0xFFFFFC, 0xC7F9CC
)

# Vaporwave / néon doux
PALETTE_VAPORWAVE = (
    0xFF71CE, 0x01CDFE, 0x05FFA1, 0xB967FF, 0xFFFB96,
    0xF9C80E, 0xF86624, 0xEA3546, 0x662E9B, 0x43BCCD
)

# Feu (rouge -> orange -> jaune)
PALETTE_FEU = (
    0x2B0000, 0x5A0000, 0x8A0000, 0xC00000, 0xFF1A00,
    0xFF4D00, 0xFF7A00, 0xFFA500, 0xFFD000, 0xFFF000
)

# Océan (bleus/verts)
PALETTE_OCEAN = (
    0x001F3F, 0x003566, 0x004B7C, 0x006494, 0x0081A7,
    0x00A6A6, 0x00C2A8, 0x2EC4B6, 0x7AE582, 0xB8F2E6
)

# Forêt (verts + terres)
PALETTE_FORET = (
    0x0B1D13, 0x123524, 0x1E4D2B, 0x2D6A4F, 0x40916C,
    0x52B788, 0x74C69D, 0xA7C957, 0xBC6C25, 0xDDA15E
)

# Gris "terminal chic" (pour un dégradé sobre)
PALETTE_GRIS = (
    0x111111, 0x1A1A1A, 0x222222, 0x2B2B2B, 0x333333,
    0x444444, 0x555555, 0x666666, 0x777777, 0x888888
)

PALETTES = {
    "arc_en_ciel": PALETTE_ARC_EN_CIEL,
    "pastel": PALETTE_PASTEL,
    "vaporwave": PALETTE_VAPORWAVE,
    "feu": PALETTE_FEU,
    "ocean": PALETTE_OCEAN,
    "foret": PALETTE_FORET,
    "gris": PALETTE_GRIS,
}
