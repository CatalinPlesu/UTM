#!/bin/python
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import QThread, pyqtSignal
from PyQt5.QtWidgets import QMessageBox
import sys
import subprocess
import time
import shutil
import os
from main import *

MAX_VALUE = 500
DEFAULT_VALUE = 150
TICKS_INTERVAL = 25
TITLE = "APA proiect de AN"

class External(QThread):
    countChanged = pyqtSignal(int)

    def __init__(self, m, n, b_n_const, distribution, parent=None):
        QThread.__init__(self, parent)
        self.m_subnetworks = m
        self.n_elements = n
        self.b_n_const = b_n_const
        self.distribution = distribution
    
    def run(self):
        self.countChanged.emit(0) 

        network_obj = Network(self.m_subnetworks, self.n_elements, self.b_n_const, self.distribution)

        ps_matrix, sp_matrix, fav_matrix = [], [], []
        for m in range(1, self.m_subnetworks + 1):
            self.countChanged.emit(int(m / (self.m_subnetworks * 1.2) * 100))
            ps_line, sp_line, fav_line = [], [], []
            for n in range(1, self.n_elements + 1):
                network = network_obj.generate_network(m, n)
                sp_line.append(network_obj.series_parallel(network))
                ps_line.append(network_obj.parallel_series(network))
                fav_line.append(network_obj.m_n__theorem(network))
            ps_matrix.append(ps_line)
            sp_matrix.append(sp_line)
            fav_matrix.append(fav_line)

        wb_a = create_workbook(self.distribution)
        pretty_output('sp', wb_a, self.distribution, sp_matrix, ps_matrix, fav_matrix) 

        self.countChanged.emit(100) 



class Ui_MainWindow(object):
    def __init__(self):
        self.b_started = False

    def setupUi(self, MainWindow):
        MainWindow.setObjectName(TITLE)
        MainWindow.resize(400, 300)
        MainWindow.setMinimumSize(QtCore.QSize(200, 200))
        MainWindow.setWindowOpacity(1.0)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout_3 = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.comboBox_distribution = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_distribution.setObjectName("comboBox_distribution")
        self.comboBox_distribution.addItem("")
        self.comboBox_distribution.addItem("")
        self.comboBox_distribution.addItem("")
        self.gridLayout_3.addWidget(self.comboBox_distribution, 4, 0, 1, 1)
        self.progressBar = QtWidgets.QProgressBar(self.centralwidget)
        self.progressBar.setProperty("value", 0)
        self.progressBar.setObjectName("progressBar")
        self.gridLayout_3.addWidget(self.progressBar, 6, 0, 1, 1)
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.slider_n = QtWidgets.QSlider(self.centralwidget)
        self.slider_n.setMaximum(MAX_VALUE)
        self.slider_n.setProperty("value", DEFAULT_VALUE)
        self.slider_n.setOrientation(QtCore.Qt.Horizontal)
        self.slider_n.setTickPosition(QtWidgets.QSlider.TicksBothSides)
        self.slider_n.setTickInterval(TICKS_INTERVAL)
        self.slider_n.setObjectName("slider_n")
        self.gridLayout_2.addWidget(self.slider_n, 1, 0, 1, 1)
        self.label_n = QtWidgets.QLabel(self.centralwidget)
        self.label_n.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.label_n.setObjectName("label_n")
        self.gridLayout_2.addWidget(self.label_n, 0, 0, 1, 1)
        self.spinBox_n = QtWidgets.QSpinBox(self.centralwidget)
        self.spinBox_n.setMaximum(MAX_VALUE)
        self.spinBox_n.setProperty("value", DEFAULT_VALUE)
        self.spinBox_n.setObjectName("spinBox_n")
        self.gridLayout_2.addWidget(self.spinBox_n, 1, 1, 1, 1)
        self.gridLayout_3.addLayout(self.gridLayout_2, 1, 0, 1, 2)
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.label_m = QtWidgets.QLabel(self.centralwidget)
        self.label_m.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.label_m.setObjectName("label_m")
        self.gridLayout.addWidget(self.label_m, 0, 0, 1, 1)
        self.slider_m = QtWidgets.QSlider(self.centralwidget)
        self.slider_m.setMaximum(MAX_VALUE)
        self.slider_m.setProperty("value", DEFAULT_VALUE)
        self.slider_m.setOrientation(QtCore.Qt.Horizontal)
        self.slider_m.setTickPosition(QtWidgets.QSlider.TicksBothSides)
        self.slider_m.setTickInterval(TICKS_INTERVAL)
        self.slider_m.setObjectName("slider_m")
        self.gridLayout.addWidget(self.slider_m, 1, 0, 1, 1)
        self.spinBox_m = QtWidgets.QSpinBox(self.centralwidget)
        self.spinBox_m.setSuffix("")
        self.spinBox_m.setMaximum(MAX_VALUE)
        self.spinBox_m.setProperty("value", DEFAULT_VALUE)
        self.spinBox_m.setObjectName("spinBox_m")
        self.gridLayout.addWidget(self.spinBox_m, 1, 1, 1, 1)
        self.gridLayout_3.addLayout(self.gridLayout, 0, 0, 1, 2)
        self.label_distribution = QtWidgets.QLabel(self.centralwidget)
        self.label_distribution.setObjectName("label_distribution")
        self.gridLayout_3.addWidget(self.label_distribution, 3, 0, 1, 1)
        self.radioButton_N_const = QtWidgets.QRadioButton(self.centralwidget)
        self.radioButton_N_const.setChecked(True)
        self.radioButton_N_const.setObjectName("radioButton_N_const")
        self.gridLayout_3.addWidget(self.radioButton_N_const, 2, 0, 1, 1)
        self.pushButton_start = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_start.setObjectName("pushButton_start")
        self.gridLayout_3.addWidget(self.pushButton_start, 6, 1, 1, 1)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout_3.addItem(spacerItem, 5, 0, 1, 2)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 400, 21))
        self.menubar.setObjectName("menubar")
        self.menuFile = QtWidgets.QMenu(self.menubar)
        self.menuFile.setObjectName("menuFile")
        self.menuHelp = QtWidgets.QMenu(self.menubar)
        self.menuHelp.setObjectName("menuHelp")
        self.menuSettings = QtWidgets.QMenu(self.menubar)
        self.menuSettings.setObjectName("menuSettings")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.actionOpen = QtWidgets.QAction(MainWindow)
        self.actionOpen.setObjectName("actionOpen")
        self.actionQuit = QtWidgets.QAction(MainWindow)
        self.actionQuit.setObjectName("actionQuit")
        self.actionQuit_2 = QtWidgets.QAction(MainWindow)
        self.actionQuit_2.setObjectName("actionQuit_2")
        self.actionOpen_output_dir = QtWidgets.QAction(MainWindow)
        self.actionOpen_output_dir.setObjectName("actionOpen_output_dir")
        self.actionAbout = QtWidgets.QAction(MainWindow)
        self.actionAbout.setObjectName("actionAbout")
        self.actionClean_output_dir = QtWidgets.QAction(MainWindow)
        self.actionClean_output_dir.setObjectName("actionClean_output_dir")
        self.menuFile.addAction(self.actionOpen_output_dir)
        self.menuHelp.addAction(self.actionAbout)
        self.menuSettings.addAction(self.actionClean_output_dir)
        self.menubar.addAction(self.menuFile.menuAction())
        self.menubar.addAction(self.menuSettings.menuAction())
        self.menubar.addAction(self.menuHelp.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

        self.pushButton_start.clicked.connect(self.start)
        self.slider_m.valueChanged.connect(self.spinBox_m.setValue)
        self.spinBox_m.valueChanged.connect(self.slider_m.setValue)
        self.slider_n.valueChanged.connect(self.spinBox_n.setValue)
        self.spinBox_n.valueChanged.connect(self.slider_n.setValue)
        self.actionOpen_output_dir.triggered.connect(self.open_output_dir)
        self.actionClean_output_dir.triggered.connect(self.clean_output_dir)
        self.actionAbout.triggered.connect(self.show_about)
        self.actionOpen_output_dir.setShortcut('Ctrl+O')
        self.actionClean_output_dir.setShortcut('Ctrl+D')
        self.actionAbout.setShortcut('Ctrl+A')

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate(TITLE, TITLE))
        self.comboBox_distribution.setItemText(0, _translate(TITLE, "Normal"))
        self.comboBox_distribution.setItemText(1, _translate(TITLE, "Poisson"))
        self.comboBox_distribution.setItemText(2, _translate(TITLE, "Uniform"))
        self.label_n.setText(_translate(TITLE, "N - elemente in subretea"))
        self.label_m.setText(_translate(TITLE, "M - subretele"))
        self.label_distribution.setText(_translate(TITLE, "Distribution type:"))
        self.radioButton_N_const.setText(_translate(TITLE, "N - constant"))
        self.pushButton_start.setText(_translate(TITLE, "Start"))
        self.menuFile.setTitle(_translate(TITLE, "File"))
        self.menuHelp.setTitle(_translate(TITLE, "Help"))
        self.menuSettings.setTitle(_translate(TITLE, "Settings"))
        self.actionOpen.setText(_translate(TITLE, "Open"))
        self.actionQuit.setText(_translate(TITLE, "Quit"))
        self.actionQuit_2.setText(_translate(TITLE, "Quit"))
        self.actionOpen_output_dir.setText(_translate(TITLE, "Open output dir"))
        self.actionAbout.setText(_translate(TITLE, "About"))
        self.actionClean_output_dir.setText(_translate(TITLE, "Clean output dir."))

    def start(self):
        if self.b_started:
            return

        self.b_started = True
        self.calc = External( self.slider_m.value(), self.slider_n.value(),
                self.radioButton_N_const.isChecked(),
                self.comboBox_distribution.currentText())
        self.calc.countChanged.connect(self.updateProgress)
        self.calc.start()


    def updateProgress(self, value):
        if value == 100:
            self.b_started = False
            value = 0
        self.progressBar.setValue(value)

    def open_output_dir(self):
        open_file_browser(output_dir)

    def clean_output_dir(self):
        msg = QMessageBox()
        msg.setWindowTitle("Warning!!!")
        msg.setText(f'All the data in "./{output_dir}" will be lost')
        msg.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel) # seperate buttons with "|"
        msg.buttonClicked.connect(self.popup_button)
        x = msg.exec_()  # this will show our messagebox

    def popup_button(self, i):
        if i.text() == "OK":
            shutil.rmtree(output_dir)
            os.mkdir(output_dir)

    def show_about(self):
        print("show about")
        msg = QMessageBox()
        msg.setWindowTitle("About")
        msg.setText("""
Program la proiect de an la APA
a efectuat: catalin plesu
coordonator: Veronica Bagrin""")
        msg.setStandardButtons(QMessageBox.Ok)
        x = msg.exec_()

def start_gui():
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

def open_file_browser(directory):
    if sys.platform=='win32':
        subprocess.Popen(['start', directory], shell= True)

    elif sys.platform=='darwin':
        subprocess.Popen(['open', directory])

    else:
        try:
            subprocess.Popen(['xdg-open', directory])
        except OSError:
            print("You shoud check the'", directory,
                    "'folder, but I can't open it for you")
            pass

if __name__ == "__main__":
    start_gui()
