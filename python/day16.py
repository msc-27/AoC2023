from collections import defaultdict, deque
from moves import *
with open('input') as f:
    lines = [x.strip('\n') for x in f]
chart = {(x,y): c for y,line in enumerate(lines) for x,c in enumerate(line)}
width = max(x for x,y in chart) + 1
height = max(y for x,y in chart) + 1

def test_beam(loc, facing):
    visited = set()
    beams = deque([Turtle(loc, facing)])
    while beams:
        beam = beams[0]
        while True:
            state = (beam.loc, beam.facing)
            if beam.loc not in chart or state in visited:
                beams.popleft()
                break
            visited.add(state)
            tile = chart[beam.loc]
            if tile == '/':
                if beam.facing in [Dir.N, Dir.S]:
                    beam.turnR()
                else:
                    beam.turnL()
            if tile == '\\':
                if beam.facing in [Dir.N, Dir.S]:
                    beam.turnL()
                else:
                    beam.turnR()
            if tile == '|':
                if beam.facing in [Dir.E, Dir.W]:
                    beam.facing = Dir.N
                    beams.append(Turtle(beam.loc, Dir.S))
            if tile == '-':
                if beam.facing in [Dir.N, Dir.S]:
                    beam.facing = Dir.W
                    beams.append(Turtle(beam.loc, Dir.E))
            beam.move()
    return len({p for p,_ in visited})

def trials():
    for x in range(width):
        yield ((x,0), Dir.S)
        yield ((x,height-1), Dir.N)
    for y in range(height):
        yield ((0,y), Dir.E)
        yield ((width-1,y), Dir.W)

print(test_beam((0,0), Dir.E))
print(max(test_beam(*trial) for trial in trials()))
