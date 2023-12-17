from collections import defaultdict
from moves import *
import grid
import astar
with open('input') as f:
    lines = [x.strip('\n') for x in f]
chart = {(x,y): c for y,line in enumerate(lines) for x,c in enumerate(line)}
def findin(d,x): return {v for v in d if d[v] == x}

links = {'|': {Dir.N, Dir.S}, \
         '-': {Dir.W, Dir.E}, \
         'L': {Dir.N, Dir.E}, \
         'J': {Dir.N, Dir.W}, \
         '7': {Dir.W, Dir.S}, \
         'F': {Dir.S, Dir.E} }

# Find start location and determine initial direction
start = findin(chart,'S').pop()
x,y = start
if chart[(x+1,y)] in 'J-7':
    start_direction = Dir.E
elif chart[(x,y+1)] in 'L|J':
    start_direction = Dir.S
else:
    start_direction = Dir.W

# Initialise set of pipe locations then release the animal to go exploring
pipe = {start}
animal = Turtle(start, start_direction)
animal.move()
while animal.loc != start:
    pipe.add(animal.loc)
    animal.turnV() # look back the way we came and then don't go that way
    animal.facing = next(d for d in links[chart[animal.loc]] if d != animal.facing)
    animal.move()

# Replace the start square with the appropriate pipe section
animal.turnV()
end_direction = animal.facing
chart[start] = findin(links, {start_direction, end_direction}).pop()

# Construct a map at twice the scale to make gaps between pipes
bigchart = defaultdict(lambda:'#')
for p in chart:
    x,y = p
    big_p = (x*2, y*2)
    for big_q in grid.inrange(big_p, 1, True):
        if bigchart[big_q] != 'P': bigchart[big_q] = '.'
    if p in pipe:
        bigchart[big_p] = 'P'
        for big_q in (translate(big_p, d) for d in links[chart[p]]):
            bigchart[big_q] = 'P'

# Make set of small scale locations that need to be checked for pipe-enclosure
remaining = set(chart.keys()) - pipe

# Flood fill from the corner to find the number of locations outside the pipe.
# We have a 1-cell boundary all around the pipe in the double-scale map,
# so this will find all of the outside cells.
def trans(loc): return [(p,1) for p in grid.atmanhat(loc,1) if bigchart[p] == '.']
big_fill = {x[0] for x in astar.astar(min(bigchart), trans).run(None)}
outside = sum(x%2 == 0 and y%2 == 0 for x,y in big_fill)

print(len(pipe) // 2)
print(len(chart) - len(pipe) - outside)
