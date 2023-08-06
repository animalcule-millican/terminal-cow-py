#!/usr/bin/env python3
import argparse
import re
import random
from enum import Enum
import textwrap
from cowpy_cows import Characters

def format_joke(func):
    def string_processor(txt, *args, **kwargs):
        sentences = re.split('(\.|\?|\.\.\.|\:)', txt)
        lines = []
        for i in range(0, len(sentences)-1, 2):
            if sentences[i]:
                if i == 0:  # if it is the first line
                    lines.append(" ".join((sentences[i], sentences[i+1])).strip())
                else:  # for subsequent lines, add newline and two tabs
                    lines.append("\n  " + "".join((sentences[i], sentences[i+1])).strip() + "\n")
        if sentences[-1].strip():  # handle the last sentence
            lines.append("\n  " + sentences[-1] + "\n")
        ret_txt = "\n" + "\n".join(lines) + "\n"
        return func(ret_txt, *args, **kwargs)
    return string_processor

@format_joke
def cowspeak(txt, base_character):
    base_char_lines = [line for line in base_character.value.split("\n") if len(line) != 0]
    for line in base_char_lines:
        txt += line + "\n"
    return txt

def random_ascii():
    return random.choice(list(Characters.__members__.values()))

def process_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
        random_line = random.choice(lines)
        character = random_ascii()
        print(cowspeak(random_line, character))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Printing a random joke for cows')
    parser.add_argument('-i', '--input', type=str, help='File to read jokes from')
    args = parser.parse_args()
    process_file(args.input)
