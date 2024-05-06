import os
import cv2
import sys
import random
import glob
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import torchvision.transforms
from torchsummary import summary
from keras.models import load_model
from PyQt5 import QtCore
from PyQt5.QtGui import QPixmap
from PyQt5.QtWidgets import QApplication, QDialog, QGridLayout, QLabel, QPushButton, QFileDialog

class MyDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle("HW2_5")
        self.resize(1000, 500)
        layout = QGridLayout(self)

        self.btn_Load_Image = QPushButton('Load Image', self)
        layout.addWidget(self.btn_Load_Image, 0, 0)
        self.btn_Load_Image.clicked.connect(self.Load_Image)

        self.btn_Show_Image = QPushButton('1. Show Image', self)
        layout.addWidget(self.btn_Show_Image, 1, 0)
        self.btn_Show_Image.clicked.connect(self.Show_Image)

        self.btn_Show_Distribution = QPushButton('2. Show Distribution', self)
        layout.addWidget(self.btn_Show_Distribution, 2, 0)
        self.btn_Show_Distribution.clicked.connect(self.Show_Distribution)

        self.btn_Show_Model_Structure = QPushButton('3. Show Model Structure', self)
        layout.addWidget(self.btn_Show_Model_Structure, 3, 0)
        self.btn_Show_Model_Structure.clicked.connect(self.Show_Model_Structure)

        self.btn_Show_Comparison = QPushButton('4. Show Comparison', self)
        layout.addWidget(self.btn_Show_Comparison, 4, 0)
        self.btn_Show_Comparison.clicked.connect(self.Show_Comparison)

        self.btn_Inference = QPushButton('5. Inference', self)
        layout.addWidget(self.btn_Inference, 5, 0)
        self.btn_Inference.clicked.connect(self.Inference)
        
        self.label_Show_Img = QLabel()
        layout.addWidget(self.label_Show_Img, 0, 1, 5, 1)
        self.label_Show_Img.setAlignment(QtCore.Qt.AlignCenter)
        
        self.label_Show_Prediction = QLabel()
        layout.addWidget(self.label_Show_Prediction, 4, 1)
        self.label_Show_Prediction.setAlignment(QtCore.Qt.AlignCenter)
        
        self.path = os.path.join(sys.path[0])
        
        self.model_1 = load_model(self.path + "\\model\\model_resnet50_binary_crossentropy.h5")
        self.model_2 = load_model(self.path + "\\model\\model_resnet50_BinaryFocalLoss.h5")
                
    def Load_Image(self):
        filename_img, _ = QFileDialog.getOpenFileName()
        
        self.img_path = filename_img
        self.img = np.asarray(Image.open(self.img_path).convert('RGB')).astype(np.float32)
        self.img = cv2.resize(self.img[:, :, :3], (224, 224))
        self.img /= 255.0
        self.img = np.expand_dims(self.img, 0)
        
        pixmap = QPixmap(self.img_path)
        pixmap = pixmap.scaled(224, 224)
        self.label_Show_Img.setPixmap(pixmap)
        
        self.label_Show_Prediction.setText('')
        
    def Show_Image(self):
        self.folder_cat = self.path + "\\dataset\\inference_dataset\\Cat"
        self.folder_dog = self.path + "\\dataset\\inference_dataset\\Dog"
        
        self.imgs_cat = glob.glob(self.folder_cat + "/*.jpg")
        self.imgs_dog = glob.glob(self.folder_dog + "/*.jpg")
        
        img_cat = cv2.imread(self.imgs_cat[random.randint(0, len(self.imgs_cat)-1)])
        img_dog = cv2.imread(self.imgs_dog[random.randint(0, len(self.imgs_dog)-1)])
        
        img_cat = cv2.resize(img_cat, (224, 224))
        img_dog = cv2.resize(img_dog, (224, 224))
        
        fig, (ax1, ax2) = plt.subplots(1, 2)
        
        ax1.imshow(img_cat)
        ax1.set_title('Cat')
        ax1.set_axis_off()
        
        ax2.imshow(img_dog)
        ax2.set_title('Dog')
        ax2.set_axis_off()
           
        plt.show()
        
    def Show_Distribution(self):  
        self.folder_cat = self.path + "\\dataset\\training_dataset\\Cat"
        self.folder_dog = self.path + "\\dataset\\training_dataset\\Dog"
        
        self.imgs_cat = glob.glob(self.folder_cat + "/*.jpg")
        self.imgs_dog = glob.glob(self.folder_dog + "/*.jpg")
              
        image_class=["Cat", "Dog"]  
        image_number=[len(self.imgs_cat), len(self.imgs_dog)]       
        
        plt.bar(image_class, image_number, tick_label=image_class)    
        plt.text(0, len(self.imgs_cat), str(len(self.imgs_cat)))
        plt.text(1, len(self.imgs_dog), str(len(self.imgs_dog)))
        plt.title('Class Distribution')                           
        plt.ylabel('Number of images')                  
        plt.show()    
    
    def Show_Model_Structure(self):        
        model = torchvision.models.resnet50()
        summary(model, (3, 224, 224))
        
    def Show_Comparison(self):
        img = cv2.imread(self.path + "\\picture\\accuracy_comparison.png")
        cv2.imshow('img', img)
        if cv2.waitKey(0) == ord('q'):
            cv2.destroyAllWindows()
        
    def Inference(self):        
        predict_ = self.model_1.predict(self.img)
        if predict_[0, 0] >= predict_[0, 1]:
            self.label_Show_Prediction.setText('Prediction: Cat')
        else:
            self.label_Show_Prediction.setText('Prediction: Dog')

if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())