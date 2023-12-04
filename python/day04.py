from collections import defaultdict
with open('input') as f:
    lines = [x.strip('\n') for x in f]
cards = [line.split() for line in lines]
part1 = 0
part2 = 0
extras = defaultdict(int)

for id,card in enumerate(cards):
    copies = extras[id] + 1
    part2 += copies
    divider = card.index('|')
    lhs = set(card[2:divider])
    rhs = set(card[divider+1:])
    win_count = len(lhs & rhs)
    if win_count:
        part1 += 2**(win_count - 1)
        for i in range(win_count):
            extras[id+i+1] += copies
print(part1)
print(part2)
