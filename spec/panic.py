
dmap = {0:0}
damage = 0.6
i = 1
while i < 600:
    dmap[i] = dmap[i - 1] + ((damage - dmap[i - 1]) / 100)
    i += 1

with open('panic.csv', mode='w') as f:
    for k, v in dmap.items():
        print(repr(k) + ';' + repr(v), file=f)
