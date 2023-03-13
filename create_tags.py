import subprocess

with open("names.txt") as f:
    names = f.read().splitlines()

names = [name.strip() for name in names if len(name) > 0 and not name.strip().startswith("#")]

letters_larger_below = "gjpqy"
letters_larger_above = "bdhklt"
letters_larger = letters_larger_below + letters_larger_above

for i, name in enumerate(names):
    print(f"Creating {name}")

    additional_args = []
    if not any(letter in name for letter in letters_larger_below):
        additional_args += ["-D", "logo_offset=-3.5", "-D", "logo_size=1.15", "-D", "offset_text=-3.5"]

    subprocess.run(["openscad", "-o", f"out/{i}_{name}-main.stl", "-D", f"name=\"{name}\"",
        "-D", "do_main=true", "bottle-clip.scad"] + additional_args)
    subprocess.run(["openscad", "-o", f"out/{i}_{name}-schrift.stl", "-D", f"name=\"{name}\"",
        "-D", "do_main=false", "bottle-clip.scad"] + additional_args)

