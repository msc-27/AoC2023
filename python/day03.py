from collections import defaultdict
import re
with open('input') as f:
    lines = [x.strip('\n') for x in f]
chart = defaultdict(lambda:'.')
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        chart[(x,y)] = c

nums = [] # list of numbers and their positions: (number, start_x, end_x, y)
for y,line in enumerate(lines):
    for m in re.finditer('[0-9]+', line):
        nums.append((int(m[0]), m.start(), m.end(), y))
        
part1 = 0
gears = defaultdict(list) # list of numbers adjacent to each *

for n,x1,x2,y in nums:
    is_part = False
    for xx in range(x1-1,x2+1):
        for yy in range(y-1,y+2):
            c = chart[(xx,yy)]
            if c not in '0123456789.':
                is_part = True
                if c == '*':
                    gears[(xx,yy)].append(n)
    if is_part:
        part1 += n

print(part1)
print(sum((g[0]*g[1] for g in gears.values() if len(g) == 2)))
