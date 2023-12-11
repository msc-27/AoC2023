import enum
from collections import defaultdict
class Dir(enum.Enum):
    N = 0
    E = 1
    S = 2
    W = 3
def translate(loc, d, n = 1):
    x,y = loc
    if d == Dir.N: y -= n
    if d == Dir.E: x += n
    if d == Dir.S: y += n
    if d == Dir.W: x -= n
    return (x,y)
class Turtle:
    def __init__(self, init_loc = (0,0), init_facing = Dir.N):
        self.loc = init_loc
        self.facing = init_facing
        self.visited = defaultdict(list)
        self.visited[init_loc].append(0)
        self.steps = [init_loc]
        self.record = False
    def move(self, n = 1):
        if self.record:
            for i in range(n):
                self.loc = translate(self.loc, self.facing)
                self.steps.append(self.loc)
                self.visited[self.loc].append(self.steps)
        else:
            self.loc = translate(self.loc, self.facing, n)
    def peek(self):
        return translate(self.loc, self.facing)
    def turnR(self):
        d = self.facing
        if d == Dir.N: self.facing = Dir.E
        if d == Dir.E: self.facing = Dir.S
        if d == Dir.S: self.facing = Dir.W
        if d == Dir.W: self.facing = Dir.N
    def turnL(self):
        d = self.facing
        if d == Dir.N: self.facing = Dir.W
        if d == Dir.E: self.facing = Dir.N
        if d == Dir.S: self.facing = Dir.E
        if d == Dir.W: self.facing = Dir.S
    def turnV(self):
        d = self.facing
        if d == Dir.N: self.facing = Dir.S
        if d == Dir.E: self.facing = Dir.W
        if d == Dir.S: self.facing = Dir.N
        if d == Dir.W: self.facing = Dir.E
