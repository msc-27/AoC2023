with open('input') as f:
    paras = [p.split('\n') for p in f.read().strip('\n').split('\n\n')]
mappings = [ [tuple(map(int,line.split())) for line in para[1:]] for para in paras[1:] ]

def translate_value(mapping, val):
    result = None
    for dst,src,lng in mapping:
        if val in range(src, src+lng): result = val + dst-src
    if result == None: result = val
    return result

def loc_from_seed(val):
    for mapping in mappings: val = translate_value(mapping, val)
    return val

def overlap(rng1, rng2):
    a1, l1 = rng1; b1 = a1 + l1 - 1
    a2, l2 = rng2; b2 = a2 + l2 - 1
    if a2 >= a1 and a2 <= b1:
        return (a2, min(l2, b1 - a2 + 1))
    if b2 >= a1 and b2 <= b1:
        return (max(a1, a2), min(l2, b2 - a1 + 1))
    if a2 < a1 and b2 > b1:
        return rng1
    return None

def translate_range(mapping, rng): # return list of ranges that rng is mapped to
    result = []
    mapped = [] # Pieces of rng that have been mapped
    for dst,src,leng in mapping:
        olap = overlap(rng, (src,leng))
        if olap != None:
            result.append((olap[0] + dst - src, olap[1]))
            mapped.append(olap)
    # Identity-map the pieces that remain unmapped
    start = rng[0]
    end = start + rng[1] - 1
    x = start
    for done_start, done_leng in sorted(mapped):
        if done_start > x:
            result.append((x, done_start - x))
        x = done_start + done_leng
    if x <= end:
        result.append((x, end - x + 1))
    return result

def loc_ranges_from_seed_ranges(ranges):
    result = ranges
    for mapping in mappings:
        new = []
        for rng in result:
            new += translate_range(mapping, rng)
        result = new
    return result
        
seed_numbers = list(map(int,paras[0][0].split()[1:]))
print(min(loc_from_seed(v) for v in seed_numbers))

seed_ranges = zip(seed_numbers[::2], seed_numbers[1::2])
print(min(loc_ranges_from_seed_ranges(seed_ranges))[0])
