import sympy as sym
import matplotlib.pyplot as plt
import csv

eps = 10 ** -4

def export(rows):
    with open(f"var_{var}.csv", 'w') as f:
        csv.writer(f).writerows(rows)

def print_points(x,y):
    for x,y in zip(x,y):
        print(f'({x}, {y})')

def print_function(f):
    print("Polinomul lagrange:")
    # print(str(f).replace('**','^'))
    print(f"L{sym.degree(f)} = {str(f).replace('**','^')}")

def plot(x, y, a):
    p = lagrange(x, y)
    p = sym.lambdify('x', p)

    mi = min(x) - 0.5
    ma = max(x) + 0.5
    xvals = []
    while mi < ma:
        mi += 0.1
        xvals.append(mi)

    yvals = []
    for val in xvals:
        yvals.append(p(val))


    plt.clf()
    plt.title("Polinomul Lagrange")
    plt.xlabel("x")
    plt.ylabel("y")

    plt.plot(xvals, yvals, "b", label="Ln")
    plt.plot(x, y, "ro")
    plt.plot(a, p(a), "go", label="a")
    plt.legend()
    plt.show()

def lagrange(x, y):
    v = sym.Symbol('x')
    lagrange = 0
    for i in range(len(x)):
        Ln = y[i]
        for j in range(len(x)):
            if j == i:
                continue
            Ln *= (v - x[j])/(x[i] - x[j])
        lagrange += Ln
    lagrange = sym.simplify(lagrange).evalf()
    return lagrange

def L_n(x0, x1, y0, y1):
    return (y0 * x1 - y1 * x0)/(x1-x0)

def aitken(a, x, y):
    headers = ["Xi", "Yi", "Xi - a"]
    tabel = []
    for i in range(len(x)):
        line = [x[i], y[i], round(x[i] -a,5)]
        title = "L_"
        for j in range(i,0,-1):
            if i == 0:
                continue
            title += f'i-{j}_'
            line.append(0)
        if i != 0:
            headers.append(title+'i')
        tabel.append(line)

    val = 0
    error = 0
    for i in range(len(tabel)):
        for j in range(1, len(tabel[i])):
            try:
                x0, x1, y0, y1 = tabel[i-j+2][2], tabel[i][2], tabel[i-1][j-2], tabel[i][j-2]
            except:
                pass
            if j > 3:
                y0 = tabel[i-1][j-1]
                y1 = tabel[i][j-1]
            if tabel[i][j] == 0:
                val = L_n(x0, x1, y0, y1)
                tabel[i][j] = round(val, 4)

            error = abs(tabel[i][j] - tabel[i-1][j-1]) 
            if error < eps:
                break
    
    print('\n'.join(['|'.join(['{:10}'.format(item) for item in row]).replace("_",",") +"|" for row in [headers]+tabel]))
    export([headers]+tabel)
    print("error:", error)
    print(f'f({a})≈L({a})= {val}')
    return val

var = 14
a = -0.999
x = [-1.104, -0.986, 0.465, 1.235, 2.476, 3.789, 4.987]
y = [4.13567, 2.29876, 0.01238, -2.4587, -1.1154, 0.56478, 2.17854]

var = 19
a = 5.068
x = [4.253, 5.786, 6.876, 8.011, 9.543, 10.564, 11.987]
y = [-2.1786, -1.0067, 0.7684, 1.98762, 3.77664, 0.45673, -1.4589]

# var = -1
# a = 2
# x = [0, 1, 3, 4]
# y = [-4, 0.5, 0.5, 8]

f = lagrange(x, y)
print(f"L{sym.degree(f)}({a}) = {f.subs('x', a)}")
# print("pentru a =",a,"Ln(",a,")=",f.subs('x', a),sym.degree(f))
print_function(f)
# plot(x, y, a)

# print(L_n(2, 0, 1, -4, 0.5)) 
aitken(a, x, y)
