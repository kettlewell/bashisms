#!/usr/bin/env python3

from copy import copy, deepcopy
from pprint import pprint as pp

numbers = [5,6,7,8,9,0]
names = ["Heather", "Michah", "Jane"]

print(names[0])
print(names[1])
print(names[2])
del names[1]
print(names)

mystr="Hello World"
print(mystr[0])
print(mystr[6])

numbers.append(10)
print(numbers)
numbers = numbers + [11]
print(numbers)

d_index = numbers.index(11)
print("d_index: " + str(d_index))
del numbers[d_index]
print(numbers)
numbers.remove(9)
print(numbers)


a1 = ["a", "f", "b", "e", "d"]
a2 = ["g","i", "h"]
a3 = "jklmnopqrstuvwxyz"

a1.sort()
a2.sort()
print(a1)
print(a2)
a1.insert(2,"c")
print(a1)
print(a2)

a1 = ''.join(a1)
a2 = ''.join(a2)
print(a1)
print(a2)

alphabet = a1 + a2 + a3
print(alphabet)

numbers = [3.14, -5, 10, 10**4, 17 ]
hello_world = "HelloWorld"

print(min(numbers))
print(max(numbers))
print(sum(numbers))
print(len(numbers))

print(max(hello_world))
print(min(hello_world))
#print(sum(hello_world))
print(len(hello_world))

nums_2d = [
    [1,2,3,4,5,6,7],
    [8,9,10,11,12,13,14,15],
    [16,17,18,19,20,21,22]
]

print(nums_2d)
pp(nums_2d)

nums_2d[2][1] = -5
pp(nums_2d)

letters = ["A","B","C","D","E"]
letters_2d = [copy(letters), copy(letters), deepcopy(letters)]
pp(letters_2d)
letters_2d[0][0] = 'F'
pp(letters_2d)

a = list(range(0,10))
pp(a)

print(a[0:5])
print(a[2:len(a)])
print(a[2:])
print(a[:])
print(a[::2])
print(a[0:6:3])

print(a[-1])
print(a[2:-2])
print(a[::-2])
