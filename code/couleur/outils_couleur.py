#!/usr/bin/env python3
# couleur/outils_couleur.py
"""
"""
from __future__ import annotations
from dataclasses import dataclass, FrozenInstanceError

"""Stocke une couleur RGB (0..255)."""
@dataclass(frozen=True)
class Couleur:
    """
    Petit "conteneur" immuable (frozen=True) pour stocker une couleur RGB.

    - `r`, `g`, `b` : entiers 0..255
    - `frozen=True` : empêche de modifier les attributs après création

    (ex: `c.r = 10` lèvera une erreur). Ça évite les mutations accidentelles.
    """
    r: int
    g: int
    b: int


"""0xRRGGBB -> Couleur(r, g, b)."""
"""hex_vers_rgb(0xFF0000) -> Couleur(255, 0, 0)"""
def hex_vers_rgb(couleur_hex: int) -> Couleur:
    """
    Convertit une couleur au format hexadécimal 0xRRGGBB vers un triplet RGB.

    Exemple :
        hex_vers_rgb(0xFF0000) -> Couleur(r=255, g=0, b=0)

    Détail (bitwise) :
        - (val >> 16) & 0xFF récupère RR
        - (val >>  8) & 0xFF récupère GG
        -  val        & 0xFF récupère BB
    """
    return Couleur(
        r=(couleur_hex >> 16) & 0xFF,
        g=(couleur_hex >> 8) & 0xFF,
        b=couleur_hex & 0xFF,
    )


def test_couleur() -> None:
    try:
        c = Couleur(1, 2, 3)        # Color(r=1, g=2, b=3)
        # c = Couleur(1, 2, 3, 4)   # TypeError
        print(c)
        # c.r = 9                     # dataclasses.FrozenInstanceError
    except TypeError as e:
        print(f"Couleur prend 3 arguments (R, G, B)")
    except FrozenInstanceError as e:
        print(f"Couleur est immuable: {e}")
    except Exception as e:
        print(f"Erreur: {e}")
    else:
        print(f"{test_couleur.__qualname__} réussi!")
    finally:
        print(f"Fin de {test_couleur.__qualname__}")

if __name__ == "__main__":
    test_couleur()
