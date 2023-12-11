from functools import reduce
with open('input') as f:
    lines = [x.strip('\n') for x in f]
part1, part2 = 0, 0
for row in (map(int, line.split()) for line in lines):
    values = list(row)
    sign = 1
    while any(values):
        part1 += values[-1]
        part2 += sign * values[0]
        values = [b-a for a,b in zip(values, values[1:])]
        sign = -sign
print(part1)
print(part2)
