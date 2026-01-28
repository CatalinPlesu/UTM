#!/bin/python
from math import sqrt
# Varianta 13
a, b = (3, 3)

lamda = 1
gama = 0.5
epsilon = 10 ** -6
sigma = 0.06

#functia
def f(x, y):
    print("func", a ,'*', x ,'**', 2 ,'+', 3 ,'*', x ,'*', y ,'+', b ,'*', y ,'**', 2 ,'-', a ,'*', x ,'-', b ,'*', y)
    print(a * x ** 2 + 3 * x * y + b * y ** 2 - a * x - b * y)
    return a * x ** 2 + 3 * x * y + b * y ** 2 - a * x - b * y

# gradientul functie
def derivata_fx(x, y):
    print("fx", a*2,"*",x,"+",3,"*",y,"-",a)
    return a * 2 * x + 3 * y - a

def derivata_fy(x, y):
    print("fy", 3 ,"*", x, '+', b * 2 ,'*', y ,'-', b)
    return 3 * x + b * 2 * y - b

def magnitudinea(x, y):
    print("rad", derivata_fx(x, y) ,"^", 2 ,'+', derivata_fy(x, y) ,"^", 2)
    return sqrt(derivata_fx(x, y) ** 2 + derivata_fy(x, y) ** 2)

def z(x, y):
    print( "calc z",x ,'-', lamda ,'*', derivata_fx(x, y), "|",y ,'-', lamda ,'*', derivata_fy(x, y))
    print( [ x - lamda * derivata_fx(x, y), y - lamda * derivata_fy(x, y)])
    return [ x - lamda * derivata_fx(x, y), y - lamda * derivata_fy(x, y)]

if __name__ == "__main__":
    k = 0
    x = []
    x.append([a, b]) # x0 ales arbitrar
    
    print("1. S-a ales un X0 aleatoriu\nx0 = ", x[0])
        
    #pasul 2 
    while(magnitudinea(*x[k]) > epsilon and k <= 1000):
        print("f = ", f(*x[k]))
        print("\nfx", derivata_fx(*x[k]))
        print("\nfy", derivata_fy(*x[k]))
        print("\nmag", magnitudinea(*x[k]))
        print("\nz", *z(*x[k]))
        print("\nmag z", magnitudinea(*z(*x[k])))
        print("\nfz", f(*z(*x[k])))
        print("\nfzx", derivata_fx(*z(*x[k])))
        print("\nfzy", derivata_fy(*z(*x[k])))
        print(magnitudinea(*x[k]) ,'<=', epsilon, "NU")
        print("conditia de satisfacere")
        print(f(*z(*x[k]))- f(*x[k]) ,'<=', -sigma * lamda * magnitudinea(*x[k])**2)
        print('\nx[',k,']',x[k],'f(x)',f(*x[k]))
        # pasul 3 fractionarea pasului
        print("se aplica procedura de fractionare a pasului")
        while( f(*z(*x[k])) - f(*x[k]) > - sigma * lamda * magnitudinea(*x[k]) ** 2):
            # fractionare pasului
            print("lamda /2")
            lamda = lamda * gama
        # pasul 4 
        x.append(z(*x[k]))
        k += 1
    print("STOP\nau fost facute ", k, "iteratii")
    x = x[k]
    print(magnitudinea(*x) ,'<=', epsilon, "DA")
    print('x = ', x)
    print('f(x*) = ', f(*x))
