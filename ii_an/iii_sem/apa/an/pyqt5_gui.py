import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel
if __name__ == "__main__":
    # any qt app should have this line
    app = QApplication(sys.argv)
    w = QWidget()
    w.resize(300,300)
    w.setWindowTitle('Proiect an')
    w.show()
    sys.exit(app.exec_())

