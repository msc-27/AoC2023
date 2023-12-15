from functools import reduce
with open('input') as f:
    paras = [p.split('\n') for p in f.read().strip('\n').split('\n\n')]

def comp_rows(grid, a, b):
    return sum(grid[a][i] != grid[b][i] for i in range(len(grid[a])))
def comp_cols(grid, a, b):
    return sum(grid[i][a] != grid[i][b] for i in range(len(grid)))

def find_reflections(grid):
    reflections = [None, None]
    rows = len(grid)
    for i in range(1,rows):
        diffs = sum(comp_rows(grid, i-j-1, i+j) for j in range(min(i, rows-i)))
        if diffs in [0,1]: reflections[diffs] = 100*i
    cols = len(grid[0])
    for i in range(1, cols):
        diffs = sum(comp_cols(grid, i-j-1, i+j) for j in range(min(i, cols-i)))
        if diffs in [0,1]: reflections[diffs] = i
    return reflections

def add_lists(a,b): return [x+y for x,y in zip(a,b)]
for x in reduce(add_lists, (find_reflections(p) for p in paras)): print(x)
