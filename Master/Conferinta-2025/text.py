import math

char_counts = {
    " ": 11865331, "e": 5553139, "t": 4087054, "o": 3645426, "a": 3595383,
    "i": 3230417, "n": 3129474, "s": 3004556, "r": 2854625, "h": 2078026,
    "l": 1896240, "d": 1653617, "c": 1545698, "u": 1507849, "m": 1256455,
    ".": 1140866, "p": 988834, "g": 905542, "y": 894257, "f": 859697,
    "w": 838506, "b": 715946, "-": 661527, ",": 531297, "v": 495673,
    ">": 490836, "I": 414710, "k": 395433, "A": 357359, ":": 351609,
    "S": 316551, "1": 304822, "'": 302472, "T": 275503, "0": 265959,
    "M": 238241, ")": 228159, "(": 220778, "C": 219802, "2": 203433,
    "D": 188253, "R": 187222, "N": 187042, "3": 180764, "_": 173945,
    "\"": 172508, "E": 170608, "@": 167279, "5": 163876, "=": 161837,
    "P": 158970, "9": 157671, "F": 155704, "4": 155450, "B": 155209,
    "*": 154315, "X": 147181, "O": 143039, "W": 137646, "H": 136233,
    "6": 135454, "L": 132436, "8": 130096, "G": 123935, "x": 123394,
    "7": 119056, "?": 113368, "j": 110558, "/": 108304, "U": 102274,
    "J": 87120, "|": 79135, "!": 76782, "K": 75553, "<": 74396,
    "V": 73265, "Y": 64384, "z": 57014, "$": 54907, "+": 54248,
    "#": 52861, "Q": 52506, ";": 50983, "^": 50671, "q": 48254,
    "%": 47904, "\\": 47842, "]": 44503, "[": 42140, "Z": 40274,
    "&": 38361, "`": 31098, "~": 19960, "}": 4488, "{": 3539
}

total_chars = sum(char_counts.values())

# Determine the scaling factor.  We want the *smallest* integer repetition
# that reasonably reflects the percentages.  A total length of 1000 is arbitrary
# but works well.
target_length = 10000
scale_factor = target_length / total_chars

repeated_text = ""
for char, count in char_counts.items():
    # Scale the count and round to the nearest integer
    scaled_count = round(count * scale_factor)
    repeated_text += char * scaled_count

print(f"Length of the repeated text: {len(repeated_text)}")
print(repeated_text)
