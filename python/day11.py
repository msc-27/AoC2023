from itertools import combinations
with open('input') as f:
    lines = [x.strip('\n') for x in f]
galaxies = {(x,y) for y,line in enumerate(lines) for x,c in enumerate(line) if c == '#'}
emptycols = {x for x in range(len(lines)) \
            if not any (g[0] == x for g in galaxies)}
emptyrows = {y for y in range(len(lines[0])) \
            if not any (g[1] == y for g in galaxies)}

def distance(g1, g2, exp):
    x1,x2 = sorted((g1[0], g2[0]))
    y1,y2 = sorted((g1[1], g2[1]))
    d =  sum(exp if x in emptycols else 1 for x in range(x1,x2))
    d += sum(exp if y in emptyrows else 1 for y in range(y1,y2))
    return d

for exp in [2,1000000]:
    print(sum(distance(g1,g2,exp) for g1,g2 in combinations(galaxies,2)))
