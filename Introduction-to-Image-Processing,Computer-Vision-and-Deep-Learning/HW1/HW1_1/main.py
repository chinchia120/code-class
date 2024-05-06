import cv2
import sys
import numpy as np
from PyQt5.QtWidgets import QApplication, QDialog, QFileDialog, QGridLayout, QLabel, QPushButton


class MyDialog(QDialog):

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle("HW1_1")
        self.resize(1000, 500)
        layout = QGridLayout(self)

        self.btn_Open_Image1 = QPushButton('Load Image1', self)
        layout.addWidget(self.btn_Open_Image1, 0, 0)
        self.btn_Open_Image1.clicked.connect(self.Load_Image1)

        self.label_Image1_Name = QLabel('No image loaded', self)
        self.label_Image1_Name.setGeometry(15, 100, 1000, 60)

        self.btn_Open_Image2 = QPushButton('Load Image2', self)
        layout.addWidget(self.btn_Open_Image2, 1, 0)
        self.btn_Open_Image2.clicked.connect(self.Load_Image2)

        self.label_Image2_Name = QLabel('No image loaded', self)
        self.label_Image2_Name.setGeometry(15, 200, 1000, 60)

        self.btn_Color_Separation = QPushButton('1.1 Color Separation', self)
        layout.addWidget(self.btn_Color_Separation, 0, 1)
        self.btn_Color_Separation.clicked.connect(self.Color_Separation)

        self.btn_Color_Transformation = QPushButton('1.2 Color Transformation', self)
        layout.addWidget(self.btn_Color_Transformation, 1, 1)
        self.btn_Color_Transformation.clicked.connect(self.Color_Transformation)

        self.btn_Color_Detection = QPushButton('1.3 Color Detection', self)
        layout.addWidget(self.btn_Color_Detection, 2, 1)
        self.btn_Color_Detection.clicked.connect(self.Color_Detection)

        self.btn_Blending = QPushButton('1.4 Blending', self)
        layout.addWidget(self.btn_Blending, 3, 1)
        self.btn_Blending.clicked.connect(self.Blending)

        self.btn_Gaussian_Blur = QPushButton('2.1 Gaussian Blur', self)
        layout.addWidget(self.btn_Gaussian_Blur, 0, 2)
        self.btn_Gaussian_Blur.clicked.connect(self.Gaussian_Blur)

        self.btn_Bilateral_Fliter = QPushButton('2.2 Bilateral Fliter', self)
        layout.addWidget(self.btn_Bilateral_Fliter, 1, 2)
        self.btn_Bilateral_Fliter.clicked.connect(self.Bilateral_Fliter)

        self.btn_Median_Fliter = QPushButton('2.3 Median Fliter', self)
        layout.addWidget(self.btn_Median_Fliter, 2, 2)
        self.btn_Median_Fliter.clicked.connect(self.Median_Fliter)

    def empty(self, v):
        pass

    def Load_Image1(self):
        filename, _ = QFileDialog.getOpenFileName()
        self.img1 = cv2.imread(filename)
        self.label_Image1_Name.setText(filename)

    def Load_Image2(self):
        filename, _ = QFileDialog.getOpenFileName()
        self.img2 = cv2.imread(filename)
        self.label_Image2_Name.setText(filename)

    def Show_Img(self, v):
        while True:
            if cv2.waitKey(1) == ord('q'):
                cv2.destroyAllWindows()
                break

    def Split_Img(self, img):
        channel_B, channel_G, channel_R = cv2.split(img)
        return channel_B, channel_G, channel_R

    def Color_Separation(self):
        B, G, R = self.Split_Img(self.img1)
        zeros = np.zeros(self.img1.shape[:2], dtype="uint8")
        cv2.imshow("channel B", cv2.merge([B, zeros, zeros]))
        cv2.imshow("channel G", cv2.merge([zeros, G, zeros]))
        cv2.imshow("channel R", cv2.merge([zeros, zeros, R]))

        self.Show_Img(None)

    def Color_Transformation(self):
        gray = cv2.cvtColor(self.img1, cv2.COLOR_BGR2GRAY)
        cv2.imshow("gray1", gray)

        B, G, R = self.Split_Img(self.img1)
        gray2 = (B / 3 + G / 3 + R / 3).astype("uint8")
        cv2.imshow("gray2", gray2)

        self.Show_Img(None)

    def Color_Detection(self):
        hsv = cv2.cvtColor(self.img1, cv2.COLOR_BGR2HSV)

        # Green
        lower_G = np.array([40, 50, 20])
        upper_G = np.array([80, 255, 255])
        mask_G = cv2.inRange(hsv, lower_G, upper_G)
        result_G = cv2.bitwise_and(self.img1, self.img1, mask=mask_G)
        cv2.imshow("result_G", result_G)

        # White
        lower_W = np.array([0, 0, 200])
        upper_W = np.array([180, 20, 255])
        mask_W = cv2.inRange(hsv, lower_W, upper_W)
        result_W = cv2.bitwise_and(self.img1, self.img1, mask=mask_W)
        cv2.imshow("result_W", result_W)

        self.Show_Img(None)

    def Blending(self):
        cv2.namedWindow("TrackBar_Blend")
        cv2.createTrackbar("Blend", "TrackBar_Blend", 0, 255, self.empty)

        while True:
            weight = cv2.getTrackbarPos("Blend", "TrackBar_Blend") / 255
            img_add = cv2.addWeighted(self.img1, 1 - weight, self.img2, weight, 0)

            cv2.imshow("TrackBar_Blend", img_add)
            if cv2.waitKey(1) == ord('q'):
                cv2.destroyAllWindows()
                break

    def Gaussian_Blur(self):
        cv2.namedWindow("TrackBar_Gaussian_Blur")
        cv2.createTrackbar("magnitude", "TrackBar_Gaussian_Blur", 0, 10, self.empty)

        while True:
            if cv2.getTrackbarPos("magnitude", "TrackBar_Gaussian_Blur") == 0:
                Gaussian_Blur_img = self.img1
            else:
                filter = cv2.getTrackbarPos("magnitude", "TrackBar_Gaussian_Blur") * 2 + 1
                Gaussian_Blur_img = cv2.GaussianBlur(self.img1, (filter, filter), 0)

            cv2.imshow("TrackBar_Gaussian_Blur", Gaussian_Blur_img)
            if cv2.waitKey(1) == ord('q'):
                cv2.destroyAllWindows()
                break

    def Bilateral_Fliter(self):
        cv2.namedWindow("TrackBar_Bilateral_Filter")
        cv2.createTrackbar("magnitude", "TrackBar_Bilateral_Filter", 0, 10, self.empty)

        while True:
            if cv2.getTrackbarPos("magnitude", "TrackBar_Bilateral_Filter") == 0:
                Bilateral_Filter_img = self.img1
            else:
                filter = cv2.getTrackbarPos("magnitude", "TrackBar_Bilateral_Filter") * 2 + 1
                Bilateral_Filter_img = cv2.bilateralFilter(self.img1, filter, 90, 90)
            cv2.imshow("TrackBar_Bilateral_Filter", Bilateral_Filter_img)

            if cv2.waitKey(1) == ord('q'):
                cv2.destroyAllWindows()
                break

    def Median_Fliter(self):
        cv2.namedWindow("TrackBar_Median_Filter")
        cv2.createTrackbar("magnitude", "TrackBar_Median_Filter", 0, 10, self.empty)

        while True:
            if cv2.getTrackbarPos("magnitude", "TrackBar_Median_Filter") == 0:
                Median_Filter_img = self.img2
            else:
                filter = cv2.getTrackbarPos("magnitude", "TrackBar_Median_Filter") * 2 + 1
                Median_Filter_img = cv2.medianBlur(self.img2, filter)

            cv2.imshow("TrackBar_Median_Filter", Median_Filter_img)
            if cv2.waitKey(1) == ord('q'):
                cv2.destroyAllWindows()
                break


if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())
