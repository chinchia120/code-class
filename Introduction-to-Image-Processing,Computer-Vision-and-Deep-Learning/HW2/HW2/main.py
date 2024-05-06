import cv2
import sys
import os
import glob
import numpy as np
from PyQt5.QtWidgets import QApplication, QDialog, QFileDialog, QGridLayout, QLabel, QPushButton, QComboBox, QLineEdit

class MyDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle("HW2")
        self.resize(1200, 500)
        layout = QGridLayout(self)

        self.btn_Load_Folder = QPushButton('Load Folder', self)
        layout.addWidget(self.btn_Load_Folder, 0, 0)
        self.btn_Load_Folder.clicked.connect(self.Load_Folder)
        
        self.label_Folder_Name = QLabel('No folder loaded', self)
        self.label_Folder_Name.setGeometry(15, 75, 1000, 60)
        
        self.btn_Open_Image_L = QPushButton('Load Image_L', self)
        layout.addWidget(self.btn_Open_Image_L, 1, 0)
        self.btn_Open_Image_L.clicked.connect(self.Load_Image_L)

        self.label_Image_L_Name = QLabel('No image loaded', self)
        self.label_Image_L_Name.setGeometry(15, 160, 1000, 60)

        self.btn_Open_Image_R = QPushButton('Load Image_R', self)
        layout.addWidget(self.btn_Open_Image_R, 2, 0)
        self.btn_Open_Image_R.clicked.connect(self.Load_Image_R)

        self.label_Image_R_Name = QLabel('No image loaded', self)
        self.label_Image_R_Name.setGeometry(15, 245, 1000, 60)

        self.btn_Draw_Contour = QPushButton('1.1 Draw Contour', self)
        layout.addWidget(self.btn_Draw_Contour, 0, 1)
        self.btn_Draw_Contour.clicked.connect(self.Draw_Contour)

        self.btn_Count_Rings = QPushButton('1.2 Count Rings', self)
        layout.addWidget(self.btn_Count_Rings, 1, 1)
        self.btn_Count_Rings.clicked.connect(self.Count_Rings)
        
        self.label_Count_Rings_img1 = QLabel('There are _ rings in img1.jpg', self)
        self.label_Count_Rings_img1.setGeometry(250, 160, 1000, 60)
        
        self.label_Count_Rings_img2 = QLabel('There are _ rings in img2.jpg', self)
        self.label_Count_Rings_img2.setGeometry(250, 180, 1000, 60)

        self.btn_Find_Corners = QPushButton('2.1 Find Corners', self)
        layout.addWidget(self.btn_Find_Corners, 0, 2)
        self.btn_Find_Corners.clicked.connect(self.Find_Corners)

        self.btn_Find_Intrinsic = QPushButton('2.2 Find Intrinsic', self)
        layout.addWidget(self.btn_Find_Intrinsic, 1, 2)
        self.btn_Find_Intrinsic.clicked.connect(self.Find_Intrinsic)
        
        self.com_Find_Extrinsic = QComboBox(self)
        self.com_Find_Extrinsic.addItems([str(x+1) for x in range(15)])
        self.com_Find_Extrinsic.setGeometry(550, 200, 100, 30)

        self.btn_Find_Extrinsic = QPushButton('2.3 Find Extrinsic', self)
        layout.addWidget(self.btn_Find_Extrinsic, 2, 2)
        self.btn_Find_Extrinsic.clicked.connect(self.Find_Extrinsic)

        self.btn_Find_Distortion = QPushButton('2.4 Find Distortion', self)
        layout.addWidget(self.btn_Find_Distortion, 3, 2)
        self.btn_Find_Distortion.clicked.connect(self.Find_Distortion)

        self.btn_Show_Result = QPushButton('2.5 Show Result', self)
        layout.addWidget(self.btn_Show_Result, 4, 2)
        self.btn_Show_Result.clicked.connect(self.Show_Result)
        
        self.edt_Words_on_Board= QLineEdit(self)
        self.edt_Words_on_Board.setGeometry(725, 60, 220, 30)
        
        self.btn_Show_Words_on_Board = QPushButton('3.1 Show Words on Board', self)
        layout.addWidget(self.btn_Show_Words_on_Board, 1, 3)
        self.btn_Show_Words_on_Board.clicked.connect(self.Show_Words_on_Board)
        
        self.btn_Show_Words_Vertically = QPushButton('3.2 Show Words Vertically', self)
        layout.addWidget(self.btn_Show_Words_Vertically, 2, 3)
        self.btn_Show_Words_Vertically.clicked.connect(self.Show_Words_Vertically)
        
        self.btn_Stereo_Disparity_Map = QPushButton('4.1 Stereo Disparity Map', self)
        layout.addWidget(self.btn_Stereo_Disparity_Map, 0, 4)
        self.btn_Stereo_Disparity_Map.clicked.connect(self.Stereo_Disparity_Map)
        
        self.path = os.path.join(sys.path[0])
        self.library = self.path + '\\dataset\\Q3_Image'
        
    def Load_Folder(self):
        self.foldername = QFileDialog.getExistingDirectory(self, "Open Folder", self.path)
        self.label_Folder_Name.setText(self.foldername.split('/')[-1])
    
    def Load_Image_L(self):
        self.filename_img_L, _ = QFileDialog.getOpenFileName(self, "Load Image L", self.path)
        self.img_L = cv2.imread(self.filename_img_L)
        self.label_Image_L_Name.setText(self.filename_img_L.split('/')[-1])

    def Load_Image_R(self):
        self.filename_img_R, _ = QFileDialog.getOpenFileName(self, "Load Image R", self.path)
        self.img_R = cv2.imread(self.filename_img_R)
        self.label_Image_R_Name.setText(self.filename_img_R.split('/')[-1])

    def Show_Img(self, v):
        if cv2.waitKey(0) == ord('q'):
            cv2.destroyAllWindows()
            
    def get_Contour(self, img, type):
        img_Contour = img.copy()
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        thresh, binary = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
        guassian = cv2.GaussianBlur(binary, (11, 11), 0)
        canny = cv2.Canny(guassian, 200, 250)
        contours, hierarchy = cv2.findContours(canny, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        
        for i in contours:
            cv2.drawContours(img_Contour, i, -1, (0, 0, 0), 3)
        
        if type == 1:
            return img_Contour
        elif type == 2:
            return len(contours)

    def Draw_Contour(self):
        contour_img1 = self.get_Contour(self.img_L, 1)
        cv2.imshow("img1_Contour", contour_img1)
        
        contour_img2 = self.get_Contour(self.img_R ,1)
        cv2.imshow("img2_Contour", contour_img2)
        
        self.Show_Img(None)

    def Count_Rings(self):
        self.label_Count_Rings_img1.setText('There are {} rings in {}.'.format(self.get_Contour(self.img_L, 2), self.label_Image_L_Name.text()))
        self.label_Count_Rings_img2.setText('There are {} rings in {}.'.format(self.get_Contour(self.img_R, 2), self.label_Image_R_Name.text()))

    def Find_Corners(self):        
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.001)
        objp = np.zeros((11*8, 3), np.float32)
        objp[:, :2] = np.mgrid[0: 11, 0: 8].T.reshape(-1, 2)
        objpoints = [] 
        imgpoints = [] 
        
        images = glob.glob(os.path.join(self.foldername, "*.bmp"))
        for fname in images:
            img = cv2.imread(fname)
            ret, corners = cv2.findChessboardCorners(img, (11, 8), None)
            if ret == True:
                objpoints.append(objp)
                corners2 = cv2.cornerSubPix(img[:, :, 0], corners, (5, 5), (-1,-1), criteria)
                imgpoints.append(corners2)
                cv2.drawChessboardCorners(img, (11, 8), corners2, ret)
                img = cv2.resize(img, (512, 512), interpolation=cv2.INTER_AREA)
                cv2.imshow('img', img)
                cv2.waitKey(500)
        cv2.destroyAllWindows()
        
        ret, self.mtx, self.dist, self.rvecs, self.tvecs = cv2.calibrateCamera(objpoints, imgpoints, img.shape[:2], None, None)

    def Find_Intrinsic(self):
        print("Intrinsic:")
        print(self.mtx)
    
    def Find_Extrinsic(self):
        index = int(self.com_Find_Extrinsic.currentText())
        RotMat, _ = cv2.Rodrigues(self.rvecs[index - 1])
        print("Extrinsic:")
        print(np.hstack((RotMat, self.tvecs[index - 1])))
        
    def Find_Distortion(self):
        print("Distortion:")
        print(self.dist)

    def Show_Result(self):
        images = glob.glob(os.path.join(self.foldername, "*.bmp"))
        for fname in images:
            img = cv2.imread(fname)
            img_undist = cv2.undistort(img, self.mtx, self.dist)
            
            img = cv2.resize(img, (512, 512), interpolation=cv2.INTER_AREA)
            img_undist = cv2.resize(img_undist, (512, 512), interpolation=cv2.INTER_AREA)
            
            cv2.imshow('img', np.hstack((img, img_undist)))
            cv2.waitKey(500)
        cv2.destroyAllWindows()
    
    def Augmented_Reality(self, file):
        if self.edt_Words_on_Board.text() == '':
            text = 'CAMARA'
        else:
            text = self.edt_Words_on_Board.text()
        
        fs = cv2.FileStorage(self.library + file, cv2.FILE_STORAGE_READ)
        axis = []
        for i in range(len(text)):
            ch = fs.getNode(text[i]).mat()
            axis.append(np.float32(ch).reshape(-1, 3)) 
        
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.001)
        objp = np.zeros((11*8, 3), np.float32)
        objp[:, :2] = np.mgrid[0: 11, 0: 8].T.reshape(-1, 2)
        objpoints = [] 
        imgpoints = []
        
        images = glob.glob(self.foldername + "/*.bmp")
        for i in range(len(images)):
            image = cv2.imread(images[i])
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            ret, corners = cv2.findChessboardCorners(gray, (11, 8), None)
            if ret == True:
                objpoints.append(objp)
                corners2 = cv2.cornerSubPix(gray, corners, (5, 5), (-1,-1), criteria)
                imgpoints.append(corners2)
                ret, mtx, dist, rvecs, tvecs = cv2.calibrateCamera(objpoints, imgpoints, image.shape[:2], None, None)
                
                def draw(image, imgpts):
                    for i in range(int(len(imgpts)/2)):
                        image = cv2.line(image, tuple(imgpts[i*2].ravel().astype(int)), tuple(imgpts[i*2 + 1].ravel().astype(int)), (0, 0, 255), 7)
                    return image
                
                shift = [[7, 5, 0], [4, 5, 0], [1, 5, 0], [7, 2, 0], [4, 2, 0], [1, 2, 0]]
                for j in range(len(axis)):
                    imgpts, jac = cv2.projectPoints(axis[j] + shift[j], rvecs[i], tvecs[i], mtx, dist)
                    img = draw(image, imgpts)
                
                img = cv2.resize(img, (512, 512), interpolation=cv2.INTER_AREA)
    
                cv2.imshow('img', img)
                cv2.waitKey(500)
        cv2.destroyAllWindows()
    
    def Show_Words_on_Board(self):
        self.Augmented_Reality('/Q3_lib/alphabet_lib_onboard.txt')
            
    def Show_Words_Vertically(self):
        self.Augmented_Reality('/Q3_lib/alphabet_lib_vertical.txt')
    
    def Stereo_Disparity_Map(self):             
        imgL = self.img_L
        imgR = self.img_R
        
        imgL_gray = cv2.cvtColor(imgL, cv2.COLOR_BGR2GRAY)
        imgR_gray = cv2.cvtColor(imgR, cv2.COLOR_BGR2GRAY)
        
        stereo = cv2.StereoBM_create(numDisparities=256, blockSize=25)
        disparity = stereo.compute(imgL_gray, imgR_gray)
        disparity = cv2.normalize(disparity, disparity, 0, 255, cv2.NORM_MINMAX, cv2.CV_8U)
        
        imgR_dot = imgR.copy()
        cv2.namedWindow('imgR_dot', cv2.WINDOW_NORMAL)
        cv2.resizeWindow('imgR_dot', (int(imgR_dot.shape[1]/4), int(imgR_dot.shape[0]/4)))
        cv2.imshow('imgR_dot', imgR_dot)
        
        def cor_dot(event, x, y, flags, param):
            if(event == cv2.EVENT_LBUTTONDOWN): 
                imgR_dot = imgR.copy()
                if disparity[y][x] != 0:
                    cv2.circle(imgR_dot, (x-disparity[y][x], y), 25, (0, 0, 255), -1)
                print(disparity[y][x])
                cv2.namedWindow('imgR_dot', cv2.WINDOW_NORMAL)
                cv2.resizeWindow('imgR_dot', (int(imgR_dot.shape[1]/4), int(imgR_dot.shape[0]/4)))
                cv2.imshow('imgR_dot', imgR_dot)
                
        cv2.namedWindow('imgL', cv2.WINDOW_NORMAL)
        cv2.resizeWindow('imgL', (int(disparity.shape[1]/4), int(disparity.shape[0]/4)))
        cv2.setMouseCallback('imgL', cor_dot)
        cv2.imshow('imgL', imgL)
        cv2.namedWindow('disparity', cv2.WINDOW_NORMAL)
        cv2.resizeWindow('disparity', (int(disparity.shape[1]/4), int(disparity.shape[0]/4)))
        cv2.imshow('disparity', disparity)           

        self.Show_Img(None)
        
if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())
