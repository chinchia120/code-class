import cv2
import sys
import math
import numpy as np
from PyQt5.QtWidgets import QApplication, QDialog, QFileDialog, QGridLayout, QLabel, QPushButton


class MyDialog(QDialog):

    def __init__(self):
        super().__init__()
        self.initUI()
        self.img_gray, self.img_sobel_x, self.img_sobel_y = None, None, None
        self.img_resize, self.img_rotation_scaling = None, None

    def initUI(self):
        self.setWindowTitle("HW1_2")
        self.resize(1000, 500)
        layout = QGridLayout(self)

        self.btn_Open_Image = QPushButton('Load Image', self)
        layout.addWidget(self.btn_Open_Image, 0, 0)
        self.btn_Open_Image.clicked.connect(self.Load_Image)

        self.label_Image_Name = QLabel('No image loaded', self)
        self.label_Image_Name.setGeometry(15, 100, 1000, 60)

        self.btn_Color_Separation = QPushButton('3.1 Gaussian Blur', self)
        layout.addWidget(self.btn_Color_Separation, 0, 1)
        self.btn_Color_Separation.clicked.connect(self.Gaussian_Blur)

        self.btn_Color_Transformation = QPushButton('3.2 Sobel X', self)
        layout.addWidget(self.btn_Color_Transformation, 1, 1)
        self.btn_Color_Transformation.clicked.connect(self.Sobel_X)

        self.btn_Color_Detection = QPushButton('3.3 Sobel Y', self)
        layout.addWidget(self.btn_Color_Detection, 2, 1)
        self.btn_Color_Detection.clicked.connect(self.Sobel_Y)

        self.btn_Blending = QPushButton('3.4 Magnitude', self)
        layout.addWidget(self.btn_Blending, 3, 1)
        self.btn_Blending.clicked.connect(self.Magnitude)

        self.btn_Gaussian_Blur = QPushButton('4.1 Resize', self)
        layout.addWidget(self.btn_Gaussian_Blur, 0, 2)
        self.btn_Gaussian_Blur.clicked.connect(self.Resize)

        self.btn_Bilateral_Fliter = QPushButton('4.2 Translation', self)
        layout.addWidget(self.btn_Bilateral_Fliter, 1, 2)
        self.btn_Bilateral_Fliter.clicked.connect(self.Translation)

        self.btn_Median_Fliter = QPushButton('4.3 Rotation, Scaling', self)
        layout.addWidget(self.btn_Median_Fliter, 2, 2)
        self.btn_Median_Fliter.clicked.connect(self.Rotation_Scaling)

        self.btn_Median_Fliter = QPushButton('4.4 Shearing', self)
        layout.addWidget(self.btn_Median_Fliter, 3, 2)
        self.btn_Median_Fliter.clicked.connect(self.Shearing)

    def Load_Image(self):
        filename, _ = QFileDialog.getOpenFileName()
        self.img = cv2.imread(filename)
        self.img_h, self.img_w = self.img.shape[:2]
        self.label_Image_Name.setText(filename)

    def Show_Img(self, v):
        if cv2.waitKey(0) == ord('q'):
            cv2.destroyAllWindows()

    def Convolution(self, img, kernel):
        m, n = kernel.shape
        y, x = img.shape

        img_result = np.zeros((y, x), dtype=np.uint8)
        img_new = np.zeros((y + m - 1, x + m - 1), dtype=np.uint8)
        img_new[int((m - 1) / 2): int((m - 1) / 2 + y), int((m - 1) / 2): int((m - 1) / 2 + x)] = img

        for i in range(y):
            for j in range(x):
                tmp = abs(np.sum(np.multiply(img_new[i: i + m, j: j + m], kernel)))
                if tmp > 255:
                    tmp = 255
                img_result[i][j] = tmp

        return img_result

    def Gaussian_Blur(self):
        x, y = np.mgrid[-1: 2, -1: 2]
        gaussian_kernel = np.exp(-(x ** 2 + y ** 2))
        gaussian_kernel = gaussian_kernel / gaussian_kernel.sum()

        self.img_gray = cv2.cvtColor(self.img, cv2.COLOR_BGR2GRAY)
        self.img_gaussian_blur = self.Convolution(self.img_gray, gaussian_kernel)

        cv2.imshow("Gaussian Blur", self.img_gaussian_blur)
        self.Show_Img(None)

    def Sobel_X(self):
        if self.img_gray is None:
            self.Gaussian_Blur()

        sobel_x_filter = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])
        self.img_sobel_x = self.Convolution(self.img_gray, sobel_x_filter)

        cv2.imshow("Sobel X", self.img_sobel_x)
        self.Show_Img(None)

    def Sobel_Y(self):
        if self.img_gray is None:
            self.Gaussian_Blur()

        sobel_y_filter = np.array([[1, 2, 1], [0, 0, 0], [-1, -2, -1]])
        self.img_sobel_y = self.Convolution(self.img_gaussian_blur, sobel_y_filter)

        cv2.imshow("Sobel Y", self.img_sobel_y)
        self.Show_Img(None)

    def Magnitude(self):
        if self.img_sobel_x is None:
            self.Sobel_X()
        if self.img_sobel_y is None:
            self.Sobel_Y()

        h, w = self.img_gray.shape[:2]
        final_image = np.zeros((h, w), dtype=np.uint8)

        list = []
        for i in range(h):
            for j in range(w):
                mag = math.sqrt(pow(self.img_sobel_x[i, j], 2.0) + pow(self.img_sobel_y[i, j], 2.0))
                list.append(mag)

        list_max = max(list)
        cnt = 0
        for i in range(h):
            for j in range(w):
                list[cnt] *= (255.0 / list_max)
                final_image[i, j] = list[cnt]
                cnt += 1

        cv2.imshow("Magnitude", final_image)
        self.Show_Img(None)

    def Resize(self):
        self.img_half = cv2.resize(self.img, (int(self.img_h / 2), int(self.img_w / 2)))
        self.img_half_h, self.img_half_w = self.img_half.shape[:2]

        self.img_resize = np.zeros((self.img_h, self.img_w, 3), np.uint8)
        self.img_resize[:self.img_half_h, :self.img_half_w, :3] = self.img_half
        cv2.imshow("Resize", self.img_resize)
        self.Show_Img(None)

    def Translation(self):
        if self.img_resize is None:
            self.Resize()

        self.img_translation = self.img_resize
        self.img_translation[self.img_half_h: self.img_half_h * 2, self.img_half_w: self.img_half_w * 2,
        :3] = self.img_half

        cv2.imshow("Translation", self.img_translation)
        self.Show_Img(None)

    def Rotation_Scaling(self):
        if self.img_resize is None:
            self.Resize()
        rotate_matrix = cv2.getRotationMatrix2D(center=(self.img_h / 2, self.img_w / 2), angle=45, scale=0.5)
        self.img_rotation_scaling = cv2.warpAffine(self.img_resize, rotate_matrix, (self.img_h, self.img_w))
        self.img_rotation_scaling_h, self.img_rotation_scaling_w = self.img_rotation_scaling.shape[:2]

        cv2.imshow("Rotation, Scaling", self.img_rotation_scaling)
        self.Show_Img(None)

    def Shearing(self):
        if self.img_rotation_scaling is None:
            self.Rotation_Scaling()
        location_old = np.float32([[50, 50], [200, 50], [50, 200]])
        location_new = np.float32(([[10, 100], [100, 50], [100, 250]]))
        M = cv2.getAffineTransform(location_old, location_new)
        self.img_shearing = cv2.warpAffine(self.img_rotation_scaling, M,
                                           (self.img_rotation_scaling_h, self.img_rotation_scaling_w))

        cv2.imshow("Shearing", self.img_shearing)
        self.Show_Img(None)


if __name__ == '__main__':
    a = QApplication(sys.argv)
    dialog = MyDialog()
    dialog.show()
    sys.exit(a.exec_())
