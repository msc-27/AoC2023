import re
from math import lcm
from itertools import cycle
with open('input') as f:
    lines = [x.strip('\n') for x in f]
def parse(line): return re.findall('[A-Z][A-Z][A-Z]', line)
trans = {x[0]: (x[1], x[2]) for x in map(parse, lines[2:])}
def move(node, direction): return trans[node][0 if direction == 'L' else 1]

step = 0
node = 'AAA'
dirs = cycle(lines[0])
while node != 'ZZZ':
    node = move(node, next(dirs))
    step += 1
print(step)

nodes = [x for x in trans if x[-1] == 'A']
periods = []
for node in nodes:
    step = 0
    dirs = cycle(lines[0])
    t = []
    while len(t) < 2:
        node = move(node, next(dirs))
        step += 1
        if node[-1] == 'Z': t.append(step)
    periods.append(t)
if all ((p[1] == 2 * p[0] for p in periods)):
    print(lcm(*(p[0] for p in periods)))
else:
    print('More work needed.')
