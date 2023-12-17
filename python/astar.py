import heapq
class astar:
    def __init__(self, initial, trans_f, estimate_f = lambda x:0):
        self.initial_state = initial
        self.trans_func = trans_f
        self.estimate_func = estimate_f
    def run(self, target_func):
    # Search for state satisfying target_func and return cost and path to the target.
    # Run with target_func = None to force full exploration of state space.
    # In this case, if the state space is finite, a list is returned
    # of all states with their associated costs.
        maxcost = 0
        counter = 0
        visited = dict() # state => (cost, ancestor)
        queue = []
        def get_path(state):
            path = []
            while state != None:
                path.append(state)
                state = visited[state][1]
            return path
        initial_est = self.estimate_func(self.initial_state)
        heapq.heappush(queue, (initial_est, counter, 0, self.initial_state, None))
        while queue:
            rank, _, cost, state, ancestor = heapq.heappop(queue)
            if state in visited: continue
            visited[state] = (cost,ancestor)
            if target_func and target_func(state): return (cost, get_path(state))
            transitions = self.trans_func(state)
            for next_state, next_cost in transitions:
                new_cost = cost + next_cost
                new_rank = new_cost + self.estimate_func(next_state)
                counter += 1
                heapq.heappush(queue, (new_rank, counter, new_cost, next_state, state))
        if target_func == None: return [(s,visited[s][0]) for s in visited]
