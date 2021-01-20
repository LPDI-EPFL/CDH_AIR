wt = ['16E', '20R', '23F', '27T', '63S', '67A']
uniq_mutations = set()
with open('to_count_mutants.txt') as f:
    lines = f.readlines()
    for line in lines:
        mut1 = line.split()[0]
        mut2 = line.split()[1].rstrip()
        muts = []
        if mut1 not in wt:
            muts.append(mut1)
        if mut2 not in wt: 
            muts.append(mut2)
        muts.sort()
        mytuple = tuple(i for i in muts)
        uniq_mutations.add(mytuple)

print(len(uniq_mutations))
    

        


