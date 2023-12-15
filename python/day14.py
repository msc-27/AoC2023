from collections import defaultdict
import itertools
with open('input') as f:
    lines = [x.strip('\n') for x in f]
chart = defaultdict(lambda:'#')
for y,line in enumerate(lines):
    for x,c in enumerate(line):
        chart[(x,y)] = c
def findin(d,x): return {v for v in d if d[v] == x}

def shift_rocks(direction):
    points = sorted(chart)
    step = -1
    if direction in [2,3]:
        points = reversed(points)
        step = 1
    for x,y in points:
        if chart[(x,y)] == 'O':
            nx, ny = x, y
            if direction in [0,2]:
                while chart[(x, ny+step)] == '.': ny += step
            else:
                while chart[(nx+step, y)] == '.': nx += step
            chart[(x,y)] = '.'
            chart[(nx,ny)] = 'O'

def load():
    rows = len(lines)
    return sum(rows - y for x,y in findin(chart, 'O'))

state_to_cycle = dict()
load_after_cycle = [None] # Dummy first item - start counting at 1
target = 1000000000
for cycle in itertools.count(1):
    shift_rocks(0)
    if cycle == 1: print(load())
    for i in [1,2,3]: shift_rocks(i)
    load_after_cycle.append(load())
    state = ''.join(chart[p] for p in sorted(chart))
    if state not in state_to_cycle:
        state_to_cycle[state] = cycle
    else:
        loop_start = state_to_cycle[state]
        loop_len = cycle - loop_start
        target_index = loop_start + (target - loop_start) % loop_len
        print(load_after_cycle[target_index])
        break
