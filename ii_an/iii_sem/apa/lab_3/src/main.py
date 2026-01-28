#!/bin/python
import networkx as nx
import matplotlib.pyplot as plt
import csv

color = ['#282828', '#7c6f64', '#cc241d',
'#fb4934', '#98971a', '#b8bb26', '#d79921',
'#fabd2f', '#458588', '#83a598', '#b16286',
'#d3869b', '#689d6a', '#8ec07c', '#a89984',
'#fbf1c7']

Edge_Color = color[8] #"green"
Node_Color = color[6] #"red"
Font_Color = color[0] #"black"
Node_Size = 300
Edge_Weight = 1.5
Node_Font = 14
Edge_Font = 10
Edge_Pos = 0.4


def plot_graph(graph):
    g = nx.Graph()
    for i in range(len(graph)):
        for j in range(len(graph[i])):
            if graph[i][j] != 0:
                g.add_edge(i+1, j+1, weight=graph[i][j])

    edge_labels = dict([((n1, n2), d['weight']) for n1, n2, d in g.edges(data=True)])

    pos = nx.spring_layout(g)
    # pos = nx.random_layout(g)
    # pos = nx.shell_layout(g)
    # pos = nx.circular_layout(g)

    nx.draw(g, pos, with_labels=True, node_size=Node_Size, font_size=Node_Font, font_color=Font_Color,
            node_color=Node_Color,edge_color=Edge_Color, width=Edge_Weight)
    nx.draw_networkx_edge_labels(g, pos, edge_labels=edge_labels,
                             font_color=Font_Color, font_size=Edge_Font, label_pos=Edge_Pos)
    plt.show()


def import_graph():
    filename = 'graph.csv'
    file = []
    with open(filename,'r') as csvfile:
        plots = csv.reader(csvfile, delimiter = ',')
        for row in plots:
            irow = []
            for e in row:
                irow.append(int(e))
            file.append(irow)
    return file

try:
    graph = import_graph()
except:
    graph = [[0, 1, 0, 0, 7],
            [1, 0, 0, 0, 0],
            [0, 0, 0, 0, 10],
            [0, 0, 0, 0, 2],
            [7, 0, 10, 2, 0]]
plot_graph(graph)
