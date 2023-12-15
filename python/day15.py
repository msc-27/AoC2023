from collections import defaultdict
terms = open('input').read().strip().split(',')

def hash(s):
    n = 0
    for c in s:
        n += ord(c)
        n *= 17
        n %= 256
    return n

print(sum(hash(t) for t in terms))

boxes = defaultdict(list)
lengths = dict()

for t in terms:
    if t[-1] == '-':
        lab = t[:-1]
        box = hash(lab)
        if lab in boxes[box]: boxes[box].remove(lab)
    if '=' in t:
        lab, num = t.split('=')
        box = hash(lab)
        if lab not in boxes[box]: boxes[box].append(lab)
        lengths[lab] = int(num)

def power(box):
    return sum((box+1) * (i+1) * lengths[lab] for i, lab in enumerate(boxes[box]))

print(sum(power(box) for box in boxes))
