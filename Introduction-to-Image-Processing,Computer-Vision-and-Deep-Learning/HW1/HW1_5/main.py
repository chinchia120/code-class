import os
import cv2
import sys
import random
import torchvision
import numpy as np
import matplotlib.pyplot as plt
import torchvision.transforms
from torchsummary import summary
from keras.utils import np_utils
from keras.models import load_model
from keras.datasets import cifar10
from PyQt5.QtGui import QImage, QPixmap
from PyQt5.QtWidgets import QApplication, QDialog, QGridLayout, QLabel, QPushButton

class MyDialog(QDialog):

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle("HW1_5")
        self.resize(1000, 500)
        layout = QGridLayout(self)

        self.btn_Load_Image = QPushButton('Load Image', self)
        layout.addWidget(self.btn_Load_Image, 0, 0)
        self.btn_Load_Image.clicked.connect(self.Load_Image)

        self.btn_Show_Train_Image = QPushButton('1. Show Train Image', self)
        layout.addWidget(self.btn_Show_Train_Image, 1, 0)
        self.btn_Show_Train_Image.clicked.connect(self.Show_Train_Image)

        self.btn_Show_Model_Structure = QPushButton('2. Show Model Structure', self)
        layout.addWidget(self.btn_Show_Model_Structure, 2, 0)
        self.btn_Show_Model_Structure.clicked.connect(self.Show_Model_Structure)

        self.btn_Show_Data_Augmentation = QPushButton('3. Show Data Augmentation', self)
        layout.addWidget(self.btn_Show_Data_Augmentation, 3, 0)
        self.btn_Show_Data_Augmentation.clicked.connect(self.Show_Data_Augmentation)

        self.btn_Show_Accuracy_and_Loss = QPushButton('4. Show Accuracy and Loss', self)
        layout.addWidget(self.btn_Show_Accuracy_and_Loss, 4, 0)
        self.btn_Show_Accuracy_and_Loss.clicked.connect(self.Show_Accuracy_and_Loss)

        self.btn_Inference = QPushButton('5. Inference', self)
        layout.addWidget(self.btn_Inference, 5, 0)
        self.btn_Inference.clicked.connect(self.Inference)

        self.label_Show_Img = QLabel()
        layout.addWidget(self.label_Show_Img, 1, 3)
        
        self.label_Image_Information = QLabel('No image loaded', self)
        layout.addWidget(self.label_Image_Information, 0, 3)

        (self.x_train_image, y_train_label), (self.x_test_image, y_test_label) = cifar10.load_data()
        x_test = self.x_test_image.reshape(10000, 32, 32, 3).astype('float32')
        self.x_test_norm = x_test / 255
        self.y_TrainOneHot = np_utils.to_categorical(y_train_label)
        self.y_TestOneHot = np_utils.to_categorical(y_test_label)
        self.y2name = "airplane automobile bird cat deer dog frog horse ship truck".split(" ")
        
        path_model = os.path.abspath(".\Introduction-to-Image-Processing,Computer-Vision-and-Deep-Learning\\HW1\\HW1_5\\18-52-36.h5")
        self.model = load_model(path_model)

    def Load_Image(self):
        tmp = random.randint(0,49999)
        self.img = self.x_train_image[tmp]
        self.Show_Image()

    def Show_Image(self):
        self.img = cv2.resize(self.img, (300, 300))
        height, width, channel = self.img.shape
        bytesPerline = 3 * width
        self.qImg = QImage(self.img.data, width, height, bytesPerline, QImage.Format_RGB888).rgbSwapped()
        self.label_Show_Img.setPixmap(QPixmap.fromImage(self.qImg))

    def Show_Train_Image(self):
        fig, ax = plt.subplots(3, 3)
        list_random = random.sample(range(0, self.x_train_image.shape[0]-1), 9)
        
        cnt = 0
        for i in range(3):
            for j in range(3):
                ax[i, j].imshow(self.x_train_image[list_random[cnt]])  
                ax[i, j].set_title(self.y2name[np.argmax(self.y_TrainOneHot[list_random[cnt]])])
                ax[i, j].set_axis_off()
                cnt += 1     
        plt.show()
        
    def Show_Model_Structure(self):        
        model = torchvision.models.vgg19()
        summary(model, (3, 32, 32))

    def Show_Data_Augmentation(self):
        '''
        fig, ax = plt.subplots(1, 3)
        
        warnings.filterwarnings("ignore")
        imagepath='./image/dog.png'
        img_pil = Image.open(imagepath, mode='r')
        img_pil = img_pil.convert('RGB')
        img_pil
        
        trans_toPIL = transforms.ToPILImage()
        img_np = np.asarray(img_pil)
        
        #rotated_imgs = rotater(np.array(self.img))
        #ax[0, 1].imshow(rotated_imgs)
        '''
        pass
        
    def Show_Accuracy_and_Loss(self):
        path_Accu = os.path.abspath(".\Introduction-to-Image-Processing,Computer-Vision-and-Deep-Learning\\HW1\\HW1_5\\accuracy.png")
        path_Loss = os.path.abspath(".\Introduction-to-Image-Processing,Computer-Vision-and-Deep-Learning\\HW1\\HW1_5\\loss.png")
        
        img_Accu = cv2.imread(path_Accu)
        img_Loss = cv2.imread(path_Loss)
        
        cv2.imshow('Accuracy', img_Accu)
        cv2.imshow('Loss', img_Loss)

    def Inference(self):
        '''
        #tmp = self.label_Image_Information.text()
        tmp = 3
        #test = cv2.resize(self.img, (32, 32))
        #prediction = self.model.predict(test.reshape(1, 32, 32, 3))
        print(self.x_test_norm[tmp].shape)
        #prediction = self.model.predict(np.reshape(self.x_test_norm[3], (1, 32, 32, 3)))
        #tmp = (np.argmax(self.model(self.img)))
        
        self.label_Image_Information.setText(str(tmp))
        '''
        pass

if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())