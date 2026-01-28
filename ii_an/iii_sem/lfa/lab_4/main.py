from pprint import pprint
from collections import OrderedDict
from prettytable import PrettyTable
import csv


EPS = 'ε'
STREND = '$'
N = ['S', 'A', 'E', 'D', 'F']
T = ['a', 'b', 'c', 'd']
P = OrderedDict({
'S': ['D'],
'D': ['aF', 'bF'],
'F': ['AF', 'ε'],
'A': ['DE'],
'E': ['c', 'd'],
})
S = 'S'
G = {'N':N, 'T':T, 'P':P, 'S':S}
string = "bbcbdac"

def export(name, matrix):
    with open(f"{name}_table.csv", 'w') as f:
        csv.writer(f).writerows(matrix)

def first(a):
    F = []
    if a[0] in T:
        return [a[0]]
    if a[0] == EPS:
        return [EPS]
    if a[0] in N:
        for pr in P[a[0]]:
            F += first(pr)
    F = list(dict.fromkeys(F))
    return F

def follow(a):
    F = []
    a = a[0]
    if a == S:
        F += STREND
    for n in N:
        for p in P[n]:
            if a in p:
                index = p.find(a)+1
                if index < len(p):
                    F += first(p[index : : -1])
                    if EPS in F:
                        F += follow(n) 
                        F.remove(EPS)
                else:
                    if n != a:
                        F += follow(n) 

    F = list(dict.fromkeys(F))
    return F

print("G =")
pprint(G)


# print()
# for n in N:
#     print(f"first {n} = {first(n)}")
# print()

# print()
# for n in P:
#     print(f"follow {n} = {follow(n)}")
# print()

def first_follow_table():
    ff_tab = [["", "FIRST", "FOLLOW"]]
    for n in P:
        row = [n, first(n), follow(n)]
        ff_tab.append(row)
    return ff_tab

def ll1_table():
    ll1_tab = [[""]+T+[STREND]]
    for n in P:
        row = []
        row += n
        row += [""] * (len(T) + 1)
        for t in first(n):
            if t == EPS:
                for e in follow(n):
                    i = ll1_tab[0].index(e)
                    p = [s for s in P[n] if EPS in s]
                    # row[i] = f'{n}->{p[0]}'
                    row[i] = f'{p[0]}'
            else:
                i = ll1_tab[0].index(t)
                p = P[n][0]
                try:
                    p = [s for s in P[n] if t in s][0]
                except:
                    pass
                # row[i] = f'{n}->{p}'
                row[i] = f'{p}'
        ll1_tab.append(row)
    return ll1_tab

def print_table(tab):
    x = PrettyTable()
    for ind, row in enumerate(tab):
        if ind == 0:
            x.field_names = row
        else:
            x.add_row(row)
    print(x)

def check(string, ll1_table):
    match = ""
    stack = S + STREND
    moves = ""
    string += STREND
    check = [["match", "stack", "input", "moves"]]
    check.append([match, stack, string, moves])
    while True:
        if stack[0] == string[0] and stack[0] == STREND:
            print("Acceptat")
            break
        elif stack[0] == string[0]: 
            match += stack[0]
            stack = stack[1:]
            string = string[1:]
            moves = "pop"
            check.append([match, stack, string, moves])
            continue
        # if not string[0] in T:
        #     check.append([match, stack, string, moves])
        #     print("neacceptat")
        #     break
        j = ll1_table[0].index(string[0])
        i = list(P).index(stack[0])+1
        moves = f'{stack[0]}->{ll1_table[i][j]}'
        # D = ll1_table[i][j].split(">")[1]
        D = ll1_table[i][j]
        if D == EPS:
            D = ""
        stack = stack[1:]
        stack = D + stack
        check.append([match, stack, string, moves])
    print_table(check)
    export("check", check)


ff_tab = first_follow_table()
ll1_table = ll1_table()
export("ff", ff_tab)
export("ll1", ll1_table)
print_table(ff_tab)
print_table(ll1_table)
check(string, ll1_table)

