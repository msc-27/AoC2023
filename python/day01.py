import regex # Not in standard library. Allows overlapping matches.
mapping = {y:x for x,y in enumerate('123456789', start=1)}
mapping |= {y:x for x,y in enumerate(['one','two','three','four','five','six','seven','eight','nine'], start=1)}
def digit_result(line):
	digits = regex.findall('[0-9]', line)
	return 10*int(digits[0]) + int(digits[-1])
def word_result(line):
	rex = regex.compile(r'\L<nums>', nums = mapping.keys())
	tokens = rex.findall(line, overlapped=True)
	return 10*mapping[tokens[0]] + mapping[tokens[-1]]

with open('input') as f:
    lines = [x.strip('\n') for x in f]
print(sum((digit_result(line) for line in lines)))
print(sum((word_result(line) for line in lines)))
