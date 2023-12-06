import re
from math import prod, sqrt
with open('input') as f:
    lines = [x.strip('\n') for x in f]
times = list(map(int, lines[0].split()[1:]))
distances = list(map(int, lines[1].split()[1:]))

# Do part 1 the brute-force way
def count(time,rec): return sum((1 for i in range(time) if i * (time-i) > rec))
print(prod((count(t,d) for t,d in zip(times,distances))))

# Solve part 2 algebraically, even though it is brute-forceable
# Record is broken for values of x that lie between the solutions to x(t-x) = d
# x² - tx + d = 0
# x = ( t ± √(t² - 4d) ) / 2

t = int(''.join(filter(str.isdigit, lines[0])))
d = int(''.join(filter(str.isdigit, lines[1])))

low_bound = int((t - sqrt(t*t - 4*d)) / 2) + 1
upp_bound = t - low_bound
print(upp_bound - low_bound + 1)
