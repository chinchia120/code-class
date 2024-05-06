import cv2
import numpy as np

#img = cv2.imread("C:\\Users\\user\\Documents\\code_git\\Surveying-Camp\\web_picture\\picture_raw.jpg")
img = cv2.imread("C:\\Users\\user\\Documents\\code_git\\Surveying-Camp\\web_picture\\picture_screenshot.jpg")
img_new = np.zeros((img.shape[0], img.shape[1]*2, img.shape[2]), np.uint8)

for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        img_new[i][j] = img[i][j]
        img_new[i][img.shape[1]*2-j-1] = img[i][j]

'''
cv2.imshow("img", img)
while True:
    if cv2.waitKey(0) == ord('q'):
        break
cv2.imshow("img", img_new)
while True:
    if cv2.waitKey(0) == ord('q'):
        break
''' 
cv2.imwrite("C:\\Users\\user\\Documents\\code_git\\Surveying-Camp\\web_picture\\picture_symmetry.jpg", img_new)