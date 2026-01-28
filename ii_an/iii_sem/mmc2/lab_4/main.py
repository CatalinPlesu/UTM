from scipy.optimize import linprog
import numpy as np
# linprog poate doar minimiza functiile

def problema_dietei():
# functia obiectiva scrisa cum este
    z = [3.8, 11, 3.3, 6.6]

# restrictiitle pot fi doar <=
# deci cele >= se inmultesc cu -1
    A = -np.array([
            [2.2, 30, 10.4, 13.5],
            [11, 4, 1.7, 20],
            [223, 157, 358, 235]
        ])

# partea de dupa <=
    b = -np.array([64, 45, 2000])

                ##min max
    xj_bounds = [(0, None)] * len(z)
    # xj_bounds[1] = (2, None)

    res = linprog(z, A_ub=A, b_ub=b, bounds=xj_bounds)

    # print(res)
    for i, x in enumerate(res['x']):
        print(f'x{i} = {round(x, 2)}')
    print(f"Z = {res['fun']}")


def problema_productiei():
# functia obiectiva inmultita cu -1 
# pentru ca libraria data poate doar minimiza
# iar noi vrem sa maximizam functia
    z = -np.array([5, 25, 30, 75.5])

    # restrictii A <= b.T
    A = np.array([
            [15, 30, 50, 35],
            [25, 35, 25, 40],
            [10, 25, 30, 25],
            [15, 20, 20, 18]
        ])

    b = np.array([720]*4)

                ##min max
    xj_bounds = [(0, None)] * len(z)

    res = linprog(z, A_ub=A, b_ub=b, bounds=xj_bounds)

    # print(res)
    for i, x in enumerate(res['x']):
        print(f'x{i} = {round(x, 2)}')
    print(f"Z = {-res['fun']}")


print("Problema dietei")
problema_dietei()

print("\nProblema productiei")
problema_productiei()

