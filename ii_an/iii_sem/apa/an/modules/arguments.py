import argparse

parser = argparse.ArgumentParser(description="""
        Proiect de an la Analiza si Proiectarea algoritmilor 

                                Efectuat de Plesu Catalin
""",
        formatter_class=argparse.RawTextHelpFormatter)

parser.add_argument("-m", type=int, default=50, dest='m',
        help="""Numarul de subretele,
m implicit - 50
""",
        metavar="int")

parser.add_argument("-n", type=int, default=50, dest='n',
        help="""Numarul de elemente in subretela,
n implicit - 50
""",
        metavar="int")

parser.add_argument('--n_non_const', action='store_false', default=True,
        help="""n va varia in fiecare subretela
        """, dest='b_n_const')

parser.add_argument('--no_gui', action='store_false', default=True,
        help="""terminal mode
        """, dest='b_gui')

parser.add_argument("--distribution", default='Normal',
        help="""Tipul distributiei aplicate elementelor retelei,
optiuni: Normal, Poisson, Uniform, ...
implicit - Normal
"""
        , metavar="Nume")


if __name__ == "__main__":
    args = parser.parse_args()
    print(args)
