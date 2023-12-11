from collections import Counter
with open('input') as f:
    lines = [x.strip('\n') for x in f]
ssv = [line.split() for line in lines]

rank = [ {y:x for x,y in enumerate('23456789TJQKA')}, \
         {y:x for x,y in enumerate('J23456789TQKA')} ]

profile_to_type = { (5,): 6, (1,4): 5, (2,3): 4, (1,1,3): 3, \
                    (1,2,2): 2, (1,1,1,2): 1, (1,1,1,1,1): 0 }

def handtype(hand, part):
    ctr = Counter(hand)
    if part == 1 and 'J' in ctr and len(ctr) > 1:
        n_jokers = ctr.pop('J')
        best_nonjoker = max(ctr, key=lambda x: ctr[x])
        ctr[best_nonjoker] += n_jokers
    return profile_to_type[tuple(sorted(ctr.values()))]

def score(hand, part):
    score = 0x100000 * handtype(hand, part)
    score += sum((16**(4-i) * rank[part][hand[i]] for i in range(5)))
    return score

for part in [0,1]:
    ssv.sort(key = lambda x: score(x[0], part))
    bids = (int(x[1]) for x in ssv)
    print(sum((bid*index for index, bid in enumerate(bids,start=1))))
