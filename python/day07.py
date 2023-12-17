from collections import Counter
with open('input') as f:
    lines = [x.strip('\n') for x in f]
ssv = [line.split() for line in lines]

rank = [ {y:x for x,y in enumerate('23456789TJQKA')}, \
         {y:x for x,y in enumerate('J23456789TQKA')} ]

def score(hand, part):
    ctr = Counter(hand)
    if part == 1 and 'J' in ctr and len(ctr) > 1:
        n_jokers = ctr.pop('J')
    else:
        n_jokers = 0
    profile = sorted(ctr.values(), reverse=True)
    profile[0] += n_jokers
    cards = [rank[part][c] for c in hand]
    return (profile, cards)

for part in [0,1]:
    ssv.sort(key = lambda x: score(x[0], part))
    bids = (int(x[1]) for x in ssv)
    print(sum((bid*index for index, bid in enumerate(bids,start=1))))
