#!/usr/bin/env python3

# System Imports
from urllib.parse import parse_qs

# Third Party Imports

# Local Imports


# Item 1

# Item 2

# Item 3

# Item 4: Write helper functions instead of complex expressions

my_values = parse_qs('red=5&blue=0&green=', keep_blank_values=True)

print(repr(my_values), "\n\n")

print('Red: ', my_values.get('red'))
print("Green: ", my_values.get("green"))
print("Opacity: ", my_values.get("opacity"), "\n\n")

print(type(my_values.get('red',[''])[0]))
print(type(my_values.get('green',[''])[0]))
print(type(my_values.get('opacity',[''])[0]), "\n\n")

print(my_values.get('red',[''])[0])
print(my_values.get('green',[''])[0])
print(my_values.get('opacity',[''])[0], "\n\n")

red = my_values.get('red',[''])[0] or 0
green = my_values.get('green',[''])[0] or 0
opacity = my_values.get('opacity',[''])[0] or 0

print('RED:     %r' % red)
print('GREEN:   %r' % green)
print('OPACITY: %r' % opacity, "\n\n")

def get_first_int(values, key, default=0):
    found = values.get(key, [''])
    if found[0]:
        found = int(found[0])
    else:
        found = default
    return found

green2 = get_first_int(my_values, 'green')
print('\n\nGREEN2:   %r\n\n' % green2)


