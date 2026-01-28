#!/bin/python
from datetime import datetime
import numpy as np
import os
import shutil
import sys
import time

from modules.export import *
from modules.arguments import *
from gui import *

class Network:
    def __init__(self, m_subnetworks: int = 10, n_elements: int = 10, b_n_const: bool = True, distribution: str = "Normal"):
        self.m_subnetworks = m_subnetworks
        self.n_elements = n_elements
        self.b_n_const = b_n_const
        self.distribution = distribution.lower()
        self.network = self.generate_network()

    def generate_network(self, m: int = None, n: int = None, b_n_const: bool = None, distribution: str = None):
        if m is None:
            m  = self.m_subnetworks
        if n is None:
            n  = self.n_elements 
        if b_n_const is None:
            b_n_const  = self.b_n_const
        if distribution is None:
            distribution  = self.distribution

        if distribution == "uniform":
            network = np.random.uniform(1, 100, (m, n))
        elif self.distribution == "poisson":
            network = np.random.poisson(50, (m, n))
        else:
            network = np.random.normal(50, 15, (m, n))
        return abs(network)

    # subnetworks (subretele)
    # m - number of subnetworks
    # n - number of elements in a subnetwork
    def series_parallel(self, network = None):
        if network is None:
            network = self.network
        # return min([max(subnetwork) for subnetwork in network])
        return network.max(axis=1).min()

    def parallel_series(self, network = None):
        if network is None:
            network = self.network
        # return max([min(subnetwork) for subnetwork in network])
        return network.min(axis=1).max()

    def m_n__theorem(self, network = None):
        if network is None:
            network = self.network
        n = [len(x) for x in network]
        n_max = max(n)
        n_min = min(n)
        if self.series_parallel(network) < self.parallel_series(network):
            return "P"
        elif self.series_parallel(network) > self.parallel_series(network): 
            return "S"
        else:
            return "B"
        # if n_max < self.m_subnetworks or n_min < self.m_subnetworks:
        #     return "P"
        # if n_max > self.m_subnetworks or n_min > self.m_subnetworks:
        #     return "S"
        # return "B"

    def print(self, matrix = None):
        if matrix is None:
            matrix = self.network
        for line in matrix:
            print(*line)

    def monte_carlo(self):
        ps_matrix, sp_matrix, fav_matrix = [], [], []
        for m in range(1, self.m_subnetworks + 1):
            print("progress:", m / (self.m_subnetworks * 1.2) * 100, end="\r")
            ps_line, sp_line, fav_line = [], [], []
            for n in range(1, self.n_elements + 1):
                network = self.generate_network(m, n, self.b_n_const, self.distribution)
                sp_line.append(self.series_parallel(network))
                ps_line.append(self.parallel_series(network))
                fav_line.append(self.m_n__theorem(network))
            ps_matrix.append(ps_line)
            sp_matrix.append(sp_line)
            fav_matrix.append(fav_line)

        wb_a = create_workbook(self.distribution)
        pretty_output('sp', wb_a, self.distribution, sp_matrix, ps_matrix, fav_matrix) 

if __name__ == "__main__":
    args = parser.parse_args()
    print(args)
    if args.b_gui and len(sys.argv) == 1:
        start_gui()
    else:
        network = Network(args.m, args.n, args.b_n_const, args.distribution)
        network.monte_carlo()
