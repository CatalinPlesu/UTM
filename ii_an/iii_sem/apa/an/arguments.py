import argparse

parser = argparse.ArgumentParser(description="""
        Proiect de an la Analiza si Proiectarea algoritmilor 

                                Efectuat de Plesu Catalin
""",
        formatter_class=argparse.RawTextHelpFormatter)

parser.add_argument("-m", type=int, default=150, dest='M',
        help="""Numarul de subretele,
M implicit - 150
""",
        metavar="int")

parser.add_argument("-n", type=int, default=150, dest='N',
        help="""Numarul de elemente in subretela,
N implicit - 150
""",
        metavar="int")

parser.add_argument('--n_non_const', action='store_false', default=True,
        help="""N va varia in fiecare subretela
        """, dest='b_N_const')

parser.add_argument("--distribution", default='Normal',
        help="""Tipul distributiei aplicate elementelor retelei,
optiuni: Normal, Poisson, Uniform, ...
implicit - Normal
"""
        , metavar="Nume")


if __name__ == "__main__":
    args = parser.parse_args()
    print(args)
