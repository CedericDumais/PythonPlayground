#!/usr/bin/env python3
# couleur/ansi.py
"""
Module de décorateurs (couleurs, format de texte, manip. curseurs, etc.)
"""
from __future__ import annotations
from .outils_couleur import Couleur

ANSI_RESET    = "\033[0m"
ANSI_BOLD     = "\033[1m"
ANSI_ITALIC   = "\033[3m"
ANSI_COULEURS = {
    "noir":     "\033[30m",
    "rouge":    "\033[31m",
    "vert":     "\033[32m",
    # "vert":      "\033[38;5;40m",
    "jaune":    "\033[33m",
    "bleu":     "\033[34m",
    "magenta":  "\033[35m",
    "cyan":     "\033[36m",
    "blanc":    "\033[37m",

    "gris":          "\033[90m",
    "rouge_clair":   "\033[91m",
    "vert_clair":    "\033[92m",
    "jaune_clair":   "\033[93m",
    "bleu_clair":    "\033[94m",
    "magenta_clair": "\033[95m",
    "cyan_clair":    "\033[96m",
    "blanc_clair":   "\033[97m",
}
ANSI_RAINBOW = {
    "turquoise": "\033[38;5;54m",
    "indigo":    "\033[38;5;54m",
    "violet":    "\033[38;5;93m",
    "lavandre":  "\033[38;5;140m",
    "rouge":     "\033[38;5;190m",
    "orange":    "\033[38;5;214m",
    "jaune":     "\033[38;5;226m"
}


def code_ansi_rgb(couleur: Couleur) -> str:
    """
    Couleur de texte (foreground) en TrueColor:
        \033[38;2;R;G;Bm
    """
    return f"\033[38;2;{couleur.r};{couleur.g};{couleur.b}m"


def coloriser(texte: str, couleur: str = "") -> str:
    """Applique une couleur ANSI si `couleur` est connue"""
    if not couleur:
        return texte
    cle = couleur.strip().lower()
    code = ANSI_COULEURS.get(cle)
    if not code:
        return texte
    return f"{code}{texte}{ANSI_RESET}"


def gras(texte: str) -> str:
    """Retourne `texte` en charactere gras"""
    return f"{ANSI_BOLD}{texte}{ANSI_RESET}"


def italique(texte: str) -> str:
    """Retourne `texte` en italique"""
    return f"{ANSI_ITALIC}{texte}{ANSI_RESET}"


def commentaire(texte: str, afficher: bool = False) -> str:
    """Transforme `texte` en gris italique
    Args:
        texte (str): le texte à coloriser
        afficher (bool): si `True`, affiche sur la sortie standard (default: `False`)
    
    Returns:
        (str): une chaine contenant `texte` en gris et italique
    """
    texte_en_commentaire = italique(coloriser(texte, "gris"))
    if afficher:
        print(texte_en_commentaire)
    return texte_en_commentaire



def principal() -> None:
    texte = "Testing!"
    print(coloriser(texte))
    print(coloriser(texte, "vert"))
    print(coloriser(texte, "fushia"))


    comment = commentaire(texte)
    print(comment)
    commentaire(texte, True)

    comment_gras = gras(commentaire(texte))
    print(comment_gras)

if __name__ == "__main__":
    principal()
