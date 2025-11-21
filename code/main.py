#!/usr/bin/env python3
"""
PythonPlayground default entrypoint
Says hello using anagrams...
"""
import random

Anagrams = (
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
    """Returns one of the predefined 'hello world' anagrams"""
    return random.choice(Anagrams)


def main() -> None:
    print(hello_world_random_annagram(), "Welcome to PythonPlayground!")

if __name__ == "__main__":
    main()
