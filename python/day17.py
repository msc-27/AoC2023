from collections import defaultdict
from moves import *
import astar
with open('input') as f:
    lines = [x.strip('\n') for x in f]
chart = defaultdict(int)
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        chart[(x,y)] = int(c)

start = min(chart)
finish = max(chart)

def trans(state, part):
    p, d, moves = state
    if chart[p] == 0: return
    if moves == 0:
        for direc in Dir:
            dest = translate(p, direc)
            yield ((dest, direc, 1), chart[dest])
    else:
        if part == 1 or moves >= 4:
            for turn in [(d+1)%4, (d-1)%4]:
                dest = translate(p, turn)
                yield ((dest, turn, 1), chart[dest])
        if moves < (3 if part == 1 else 10):
            dest = translate(p, d)
            yield ((dest, d, moves+1), chart[dest])

def fin(state, part):
    p, d, moves = state
    return p == finish and (part == 1 or moves >= 4)

for part in [1,2]:
    a = astar.astar((start, None, 0), lambda x: trans(x, part))
    print(a.run(lambda x: fin(x, part))[0])
