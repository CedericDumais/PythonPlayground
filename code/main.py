#!/usr/bin/env python3
"""
PythonPlayground default entrypoint
"""

import random

# annagrams taken from:
# https://wordsmith.org/anagram/anagram.cgi?anagram=hello+world&language=english&t=1000&d=&include=&exclude=&n=&m=&source=adv&a=n&l=n&q=n&k=1

Annagrams = (
    "Howled roll", 
    "Doll howler", 
    "Oh, lewd roll...",
    "Who, red? Loll!",
    "Red who? loll!!",
    "Red how loll?",
    "Whole Droll", 
    "Hold, we roll!",
    "Hold well, or...",
    "Held. OW! roll...", 
    "Oh well, lord", 
    "Word eh? Loll!"
)


def hello_world_random_annagram() -> str:
    """Returns one of the predefined 'hello world' annagrams"""
    return random.choice(Annagrams)


def main() -> None:
    print(hello_world_random_annagram(), "Welcome to PythonPlayground!")

if __name__ == "__main__":
    main()
