# couleur/palette.py
"""
"""
from typing import Tuple
from .ansi import ANSI_RESET, code_ansi_rgb
from .outils_couleur import hex_vers_rgb


class Palette:
    """
    Palette de couleurs.

    Constructeur:
        Palette(style: str, couleurs_hex: tuple[int, ...])

    - style : nom humain (ex: "Arc-en-ciel")
    - couleurs_hex : tuple de 0xRRGGBB
    - codes_ansi : tuple de codes ANSI TrueColor pré-calculés (même taille)
    """
    __slots__ = ("style", "_couleurs_hex", "_codes_ansi")

    def __init__(self, style: str, couleurs_hex: Tuple[int, ...]) -> None:
        self.style = style
        self._couleurs_hex = tuple(couleurs_hex)

        # Pré-calcul: hex -> Couleur -> code ANSI
        rgb = (hex_vers_rgb(h) for h in self._couleurs_hex)
        self._codes_ansi = tuple(code_ansi_rgb(c) for c in rgb)

        if not self._codes_ansi:
            raise ValueError("Une palette doit contenir au moins une couleur.")
    
    @property
    def couleurs_hex(self) -> Tuple[int, ...]:
        """Tuple immuable des couleurs en hex"""
        return self._couleurs_hex
    
    @property
    def codes_ansi(self) -> Tuple[str, ...]:
        """Tuple immuable des séquences ANSI pré-calculées"""
        return self._codes_ansi
    
    @property
    def taille(self) -> int:
        return len(self._codes_ansi)
    
    def __str__(self) -> str:
        return self.style

    def colorer(self, chaine: str, *, depart: int = 0) -> str:
        """Retourne `chaine` colorée en bouclant sur la palette"""
        if not chaine:
            return ""

        codes = self._codes_ansi
        n = len(codes)
        index = depart % n

        morceaux: list[str] = []
        for caractere in chaine:
            if caractere == "\n":
                morceaux.append(ANSI_RESET)
                morceaux.append("\n")
            else:
                morceaux.append(codes[index])
                morceaux.append(caractere)
                # index = (index + 1) % n
                index += 1
                if index == n:
                    index = 0

        morceaux.append(ANSI_RESET)
        return "".join(morceaux)


    def afficher(
            self, chaine: str, *, depart: int = 0, 
            nouvelle_ligne: bool = True
        ) -> None:
            fin = "\n" if nouvelle_ligne else ""
            print(self.colorer(chaine, depart=depart), end=fin)


# @dataclass(slots=True)
# class Palette:
#     """
#     Palette de couleurs (stockée en hex), avec codes ANSI pré-calculés.

#     - style : nom (ex: "Arc-en-ciel")
#     - couleurs_hex : tuple de 0xRRGGBB
#     - codes_ansi : tuple de séquences ANSI correspondantes (pré-calculées une fois)
#     """
#     style: str
#     couleurs_hex: Tuple[int, ...]
#     codes_ansi: Tuple[str, ...] = field(init=False, repr=False)

#     def __post_init__(self) -> None:
#         # Convertit hex -> RGB -> codes ANSI une seule fois
#         rgb = (hex_vers_rgb(h) for h in self.couleurs_hex)
#         self.codes_ansi = tuple(code_ansi_rgb(c) for c in rgb)
    
#     @property
#     def __str__(self) -> str:
#         return self.style

#     @property
#     def taille(self) -> int:
#         return len(self.couleurs_hex)
    

#     def colorer(self, chaine: str, *, depart: int = 0) -> str:
#         """
#         Colorise `chaine` en bouclant sur la palette.
#         """
#         if not chaine:
#             return ""

#         codes = self.codes_ansi
#         n = self.taille
#         index = depart % n

#         morceaux: list[str] = []
#         for caractere in chaine:
#             if caractere == "\n":
#                 # force la fin de style, puis saute la ligne.
#                 # l'index ne bouge pas: la couleur "continue" logiquement.
#                 morceaux.append(ANSI_RESET)
#                 morceaux.append("\n")
#             else:
#                 morceaux.append(codes[index])
#                 morceaux.append(caractere)

#                 index += 1
#                 if index == n:
#                     index = 0

#         morceaux.append(ANSI_RESET)
#         return "".join(morceaux)


#     def afficher(
#             self, chaine: str, *, depart: int = 0, 
#             nouvelle_ligne: bool = True
#         ) -> None:
#             fin = "\n" if nouvelle_ligne else ""
#             print(self.colorer(chaine, depart=depart), end=fin)

# ---------------------------------------------------------------------------
# Palettes
# ---------------------------------------------------------------------------

# PALETTE_ARC_EN_CIEL = Palette("Arc-en-ciel", (
#     0xFF0000,  # rouge
#     0xFF7F00,  # orange
#     0xFFFF00,  # jaune
#     0x7FFF00,  # jaune-vert
#     0x00FF00,  # vert
#     0x00FF7F,  # vert printemps
#     0x00FFFF,  # cyan
#     0x007FFF,  # bleu azur
#     0x0000FF,  # bleu
#     0x7F00FF,  # violet
# ))

# # PALETTE_ARC_EN_CIEL = Palette("Arc-en-ciel", (
# #     0xFF0000, 0xFF7F00, 0xFFFF00, 0x7FFF00, 0x00FF00,
# #     0x00FF7F, 0x00FFFF, 0x007FFF, 0x0000FF, 0x7F00FF
# # ))

# PALETTE_PASTEL = Palette("Pastel", (
#     0xFFADAD, 0xFFD6A5, 0xFDFFB6, 0xCAFFBF, 0x9BF6FF,
#     0xA0C4FF, 0xBDB2FF, 0xFFC6FF, 0xFFFFFC, 0xC7F9CC
# ))

# PALETTE_VAPORWAVE = Palette("Vaporwave", (
#     0xFF71CE, 0x01CDFE, 0x05FFA1, 0xB967FF, 0xFFFB96,
#     0xF9C80E, 0xF86624, 0xEA3546, 0x662E9B, 0x43BCCD
# ))

# PALETTE_FEU = Palette("Feu", (
#     0x2B0000, 0x5A0000, 0x8A0000, 0xC00000, 0xFF1A00,
#     0xFF4D00, 0xFF7A00, 0xFFA500, 0xFFD000, 0xFFF000
# ))

# PALETTE_OCEAN = Palette("Océan", (
#     0x001F3F, 0x003566, 0x004B7C, 0x006494, 0x0081A7,
#     0x00A6A6, 0x00C2A8, 0x2EC4B6, 0x7AE582, 0xB8F2E6
# ))

# PALETTE_FORET = Palette("Forêt", (
#     0x0B1D13, 0x123524, 0x1E4D2B, 0x2D6A4F, 0x40916C,
#     0x52B788, 0x74C69D, 0xA7C957, 0xBC6C25, 0xDDA15E
# ))

# PALETTE_GRIS = Palette("Gris", (
#     0x111111, 0x1A1A1A, 0x222222, 0x2B2B2B, 0x333333,
#     0x444444, 0x555555, 0x666666, 0x777777, 0x888888
# ))

# PALETTES = {p.style.lower(): p for p in (
#     PALETTE_ARC_EN_CIEL,
#     PALETTE_PASTEL,
#     PALETTE_VAPORWAVE,
#     PALETTE_FEU,
#     PALETTE_OCEAN,
#     PALETTE_FORET,
#     PALETTE_GRIS,
# )}
