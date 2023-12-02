from collections import defaultdict
import math
with open('input') as f:
    lines = [x.strip('\n') for x in f]
ssv = [x.split(' ') for x in lines]
part1 = 0
part2 = 0
for line in ssv:
	id = int(line[1][:-1])
	maxima = defaultdict(int)
	draws = ((int(n), col[0]) for n,col in zip(line[2::2], line[3::2]))
	for n,c in draws:
		maxima[c] = max(maxima[c], n)
	if maxima['r'] <= 12 and maxima['g'] <= 13 and maxima['b'] <= 14:
		part1 += id
	part2 += math.prod(maxima.values())
print(part1)
print(part2)
