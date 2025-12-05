#!/usr/bin/env python3
# couleur/tester.py
from __future__ import annotations

from .palette import Palette
from .palettes import (
    PALETTE_ARC_EN_CIEL, PALETTE_PASTEL, PALETTE_VAPORWAVE, PALETTE_FEU, 
    PALETTE_OCEAN, PALETTE_FORET, PALETTE_GRIS
)
from .outils_couleur import hex_vers_rgb
from .ansi import code_ansi_rgb

CHIEN = """
    __
  o-''|\_____/)
  \_/|_)     )
      \  __  /
      (_/ (_/
"""

def info_couleurs(p: Palette) -> None:
    sep = "=" * 51

    p.afficher(sep)
    print(f"Palette: {p.colorer(str(p))}")
    print(f"Nombre de couleurs: {p.taille}")
    print("Couleurs:")
    p.afficher(sep)
    print("  HEX    ||    RGB CODE   ||            ANSI")
    p.afficher(sep)
    for c in p.couleurs_hex:
        rgb = hex_vers_rgb(c)
        print(f"{c:#08X} || ({rgb.r:03},{rgb.g:03},{rgb.b:03}) || {repr(code_ansi_rgb(rgb))}")
    p.afficher(sep)    
    print("\nDemo:")
    texte = "ligne 1\nligne 2\nligne 3"
    p.afficher(texte, depart=5)
    print(p.colorer(CHIEN))
    p.afficher("⋅.˳˳.⋅ॱ˙˙ॱ⋅.˳˳.⋅ॱ˙˙ॱᐧ.˳˳.⋅")


def principal() -> None:
    pa = Palette("Arc-en-ciel 🌈", PALETTE_ARC_EN_CIEL)
    info_couleurs(pa)

    pp = Palette("Pastel", PALETTE_PASTEL)
    info_couleurs(pp)

    pv = Palette("Vaporwave 👾", PALETTE_VAPORWAVE)
    info_couleurs(pv)

    pf = Palette("Feu", PALETTE_FEU)
    info_couleurs(pf)

    po = Palette("Océan 🌊", PALETTE_OCEAN)
    info_couleurs(po)

    pfo = Palette("Forêt", PALETTE_FORET)
    info_couleurs(pfo)

    pg = Palette("Gris", PALETTE_GRIS)
    info_couleurs(pg)


if __name__ == "__main__":
    principal()
