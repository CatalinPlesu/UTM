#!/bin/python
from math import sqrt
a, b = (3, 3)

lamda = 1
gama = 0.5
epsilon = 10 ** -6
sigma = 0.06

#functia
def f(x, y):
    return a * x ** 2 + 3 * x * y + b * y ** 2 - a * x - b * y

# gradientul functie
def derivata_fx(x, y):
    return a * 2 * x + 3 * y - a

def derivata_fy(x, y):
    return 3 * x + b * 2 * y - b

def magnitudinea(x, y):
    return sqrt(derivata_fx(x, y) ** 2 + derivata_fy(x, y) ** 2)

def z(x, y):
    return [ x - lamda * derivata_fx(x, y), y - lamda * derivata_fy(x, y)]

if __name__ == "__main__":
    k = 0
    x = []
    x.append([a, b]) # x0 ales arbitrar

    #pasul 2 
    while(magnitudinea(*x[k]) > epsilon and k <= 1000):
        print('x[',k,']',x[k],'f(x)',f(*x[k]), 'mag =', magnitudinea(*x[k]))
        # pasul 3 fractionarea pasului
        while( f(*z(*x[k])) - f(*x[k]) > - sigma * lamda * magnitudinea(*x[k]) ** 2):
            # fractionare pasului
            lamda = lamda * gama
        # pasul 4 
        x.append(z(*x[k]))
        k += 1
    print("STOP\nau fost facute ", k, "iteratii")
    x = x[k]
    print('x = ', x)
    print('f(x*) = ', f(*x))
