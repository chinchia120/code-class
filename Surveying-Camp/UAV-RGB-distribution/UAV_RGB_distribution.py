import cv2
import sys
import os
import glob
import numpy as np
import matplotlib.pyplot as plt
from PyQt5.QtWidgets import QApplication, QDialog, QFileDialog, QGridLayout, QLabel, QPushButton, QLineEdit

class MyDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle("UAV-RGB-Distribution")
        self.resize(1000, 500)
        layout = QGridLayout(self)

        self.label_discribe1 = QLabel('Please select the image', self)
        self.label_discribe1.setGeometry(15, 105, 1000, 60)
        
        self.btn_Load_Image = QPushButton('Load Image', self)
        layout.addWidget(self.btn_Load_Image, 0, 0)
        self.btn_Load_Image.clicked.connect(self.Load_Image)
        
        self.label_Image_Name = QLabel('No image loaded', self)
        self.label_Image_Name.setGeometry(15, 160, 1000, 60)
        
        self.label_discribe2 = QLabel('Please select the folder', self)
        self.label_discribe2.setGeometry(15, 280, 1000, 60)
        
        self.btn_Load_Folder = QPushButton('Load Folder', self)
        layout.addWidget(self.btn_Load_Folder, 1, 0)
        self.btn_Load_Folder.clicked.connect(self.Load_Folder)
        
        self.label_Folder_Name = QLabel('No folder loaded', self)
        self.label_Folder_Name.setGeometry(15, 335, 700, 60)
        
        self.label_discribe3 = QLabel('Show RGB distribution', self)
        self.label_discribe3.setGeometry(505, 105, 1000, 60)

        self.btn_Show_Distribution = QPushButton('Show Distribution', self)
        layout.addWidget(self.btn_Show_Distribution, 0, 1)
        self.btn_Show_Distribution.clicked.connect(self.Show_Distribution)
        
        self.label_discribe4 = QLabel('Please type in export folder name', self)
        self.label_discribe4.setGeometry(505, 280, 1000, 60)
        
        self.edt_Export_File= QLineEdit(self)
        self.edt_Export_File.setGeometry(505, 320, 235, 30)
        
        self.label_discribe5 = QLabel('Run image in the folder', self)
        self.label_discribe5.setGeometry(750, 280, 1000, 60)
        
        self.btn_Run = QPushButton('Run', self)
        self.btn_Run.setGeometry(750, 320, 235, 30)
        self.btn_Run.clicked.connect(self.Run)
        
        self.label_Run_Progress = QLabel('', self)
        self.label_Run_Progress.setGeometry(750, 335, 1000, 60)
        
        self.path = os.path.join(sys.path[0])
        self.foldername = ' '
        self.imagename = ' '
           
    def Load_Image(self):
        self.imagename, _ = QFileDialog.getOpenFileName(self, "Open Image", self.path)
        #self.label_Image_Name.setText(self.imagename.split('/')[-1])
        self.label_Image_Name.setText(self.imagename)
        
    def Load_Folder(self):
        self.foldername = QFileDialog.getExistingDirectory(self, "Open Folder", self.path)
        #self.label_Folder_Name.setText(self.foldername.split('/')[-1])
        self.label_Folder_Name.setText(self.foldername)
            
    def Show_Distribution(self):  
        if self.imagename == ' ':
            return 0
        
        img_UAV = cv2.imread(self.imagename)
        img_UAV = cv2.resize(img_UAV, (0, 0), fx=0.5, fy=0.5)
        
        fig, (ax1, ax2) = plt.subplots(1, 2)
        
        ax1.imshow(img_UAV)
        ax1.set_title('UAV Image - ' + self.imagename.split('/')[-1].split('.')[0])
        ax1.set_axis_off()
        
        color = ('b', 'g', 'r')
        for i, col in enumerate(color):
            histr = cv2.calcHist([img_UAV], [i], None, [256], [0, 256])
            plt.plot(histr, color = col)
            plt.ticklabel_format(style='sci', scilimits=(0, 0), axis='y')
            plt.xlim([0, 255])
        ax2.set_title('RGB Distribution - ' + self.imagename.split('/')[-1].split('.')[0])
        
        plt.show()
        
    def Run(self):
        if self.foldername == ' ':
            return 0
        
        if self.edt_Export_File.text() == '':
            export_file = 'UAV-RGB-Distribution'
        else:
            export_file = self.edt_Export_File.text()
            
        if not os.path.exists(export_file):
            os.mkdir(export_file)
            
        self.imgs = glob.glob(self.foldername + "/*.jpg")
        imgs_num = len(self.imgs)
        
        for i in range(imgs_num):
            QApplication.processEvents()
            self.label_Run_Progress.setText(str(i+1) + '/' + str(imgs_num))
            img_UAV = cv2.imread(self.imgs[i])
            self.RGB_Distribution(img_UAV, export_file, self.imgs[i].split('\\')[-1].split('.')[0])
        
    def RGB_Distribution(self, img, export, title_):
        for j, col in enumerate(('b', 'g', 'r')):
                histr = cv2.calcHist([img], [j], None, [256], [0, 256])
                plt.plot(histr, color = col)
                plt.ticklabel_format(style='sci', scilimits=(0, 0), axis='y')
                plt.xlim([0, 255])
                plt.suptitle('UAV RGB Distribution - ' + title_)
                plt.savefig(export + '/UAV_RGB_Distribution_' + title_ + '.png')
        plt.cla()     

if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())