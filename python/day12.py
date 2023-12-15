from itertools import repeat
from functools import cache
with open('input') as f:
    lines = [x.strip('\n') for x in f]
ssv = [line.split() for line in lines]

def getc(s,i):
    return s[i] if 0 <= i < len(s) else '.'
@cache
def solve(s, blocks):
    if not blocks: return 0 if '#' in s else 1
    n_brok = s.count('#')
    n_poss = s.count('?')
    if not n_brok <= sum(blocks) <= n_brok + n_poss: return 0 # Early exit
    count = 0
# Select a block to do first. Ideally, we want a large block near the middle.
# Taking the largest of the three middle blocks seems to give good results.
    n_blocks = len(blocks)
    if n_blocks < 3:
        size = max(blocks)
        index = blocks.index(size)
    else:
        left_block = n_blocks // 2 - 1
        size = max(blocks[left_block:left_block+3])
        index = blocks.index(size, left_block)
    for i in range(len(s) - size + 1):
# Could probably speed this up by not blindly repeating failed comparisons
        if all(s[j] in '#?' for j in range(i, i+size)) and getc(s,i+size) in '.?' and getc(s,i-1) in '.?':
            if i < len(s) // 2: # Shorter half of string is quicker to process and likely to return 0
                left = solve('' if i == 0 else s[:i-1].strip('.'), blocks[:index])
                right = solve(s[i+size+1:].strip('.'), blocks[index+1:]) if left else 0
            else:
                right = solve(s[i+size+1:].strip('.'), blocks[index+1:])
                left = solve('' if i == 0 else s[:i-1].strip('.'), blocks[:index]) if right else 0
            count += left * right
    return count

part1, part2 = 0, 0
for line in ssv:
    springs = line[0]
    blocks = tuple(map(int, line[1].split(',')))
    part1 += solve(springs, blocks)
    springs = '?'.join(repeat(springs, 5))
    blocks = blocks+blocks+blocks+blocks+blocks
    part2 += solve(springs, blocks)
    
print(part1)
print(part2)
