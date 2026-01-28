#!/bin/python
import numpy as np
from fractions import Fraction
import csv
import lab

a = 3
b = 3
var = 13

def export(rows):
    with open(f"out/var_{var}_a_{a}_b_{b}.csv", 'w') as f:
        csv.writer(f).writerows(rows)

#functia
def f(x, y):
    return a * x ** 2 + 3 * x * y + b * y ** 2 - a * x - b * y

# derivari 
def fx(x, y):
    return 2 * a * x + 3 * y - a

def fy(x, y):
    return 3 * x + 2 * b * y - b

def fxx():
    return a * 2

def fxy():
    return 3

def fyx():
    return 3  

def fyy():
    return b * 2 

def A():
    return np.matrix([[fxx(), fxy()], [fyx(), fyy()]])

def grad(x, y):
    return np.transpose(np.matrix([fx(x, y), fy(x, y)]))

def dk(x, y):
    return -grad(x, y) 

def alfa(x, y):
    d = dk(x, y)
    return -(grad(x, y).T * d).item()/(np.transpose(A() * d) * d).item()

def Hestense_Stiefel(x1, x2):
    # Pasul. 1.
    k = 0
    x = []
    d = [] 
    alpha = [] 
    x.append([x1, x2])

    if np.all(grad(*x[k]) == 0): 
        print("STOP")
        return
    td = dk(*x[k])
    d.append([td[0][0].item(), td[1][0].item()])
    lines = [["k", "x", "y", "f(X)", "alpha", "gradient"]]

    while True:
        # Pasul 2.
        alpha.append(alfa(*x[k]))
        # Pasul 3.
        x_k1 = [x[k][0] + alpha[k]*d[k][0], x[k][1] + alpha[k]*d[k][1]]
        x.append(x_k1)
        fxk1 = f(*x_k1)
        gfk1 = grad(*x_k1)
        # Pasul 4.
        d_k1 = -gfk1 + np.linalg.norm(gfk1) ** 2 / np.linalg.norm(grad(*x[k])) ** 2 * dk(*x[k])
        d.append([d_k1[0][0].item(), d_k1[1][0].item()])
        lines.append([k, *x[k], f(*x[k]), alpha[k], grad(*x[k])[0][0].item(),
            grad(*x[k])[1][0].item()])

        k += 1
        if k > 10:
            break

        if np.all(gfk1 == 0): #STOP
            lines.append([k, *x[k], f(*x[k]), alpha[k-1], grad(*x[k])[0][0].item(), grad(*x[k])[1][0].item()])
            for l in lines:
                for e in l:
                    try:
                        e = round(e, 5)
                    except:
                        pass
                    print(e, end=" ")
                print()
            export(lines)
            break

if __name__ == "__main__":
     print("Hestenes-Stiefel nonlinear conjugate")
     for k in lab.lab.keys():
         var = k
         a, b = lab.lab[k]
         Hestense_Stiefel(a, b)
     print("Program executed -> check ./out for output")
