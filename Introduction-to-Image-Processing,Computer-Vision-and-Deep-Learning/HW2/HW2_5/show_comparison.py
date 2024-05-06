import numpy as np
import matplotlib.pyplot as plt
from keras.models import load_model
from PIL import Image
import  os, cv2, glob, sys

path = os.path.join(sys.path[0])

model_1 = load_model(path + "\\model\\model_resnet50_binary_crossentropy.h5")
model_2 = load_model(path + "\\model\\model_resnet50_BinaryFocalLoss.h5")

train_path = path + "\\dataset\\test_dataset" 

image_cat = glob.glob(train_path + "\\Cat/*.jpg")
image_cat[:2500] = image_cat[:2500]

image_dog = glob.glob(train_path + "\\Dog/*.jpg")
image_dog[:2500] = image_dog[:2500]

image = []
for i in range(5000):
    if i < 2500:
        image.append(image_cat[i])
    else:
        image.append(image_dog[i-2500])

test_image = np.empty((5000,224,224,3),dtype=np.float32)
test_label = np.empty((5000, 2),dtype=np.float32)

for i in range(5000):
    tmp = np.asarray(Image.open(image[i]).convert("RGB")).astype(np.float32)
    tmp = cv2.resize(tmp[:,:,:3], (224, 224))
    tmp /= 255.0
    test_image[i] = tmp
    
    if i < 2500:
        test_label[i] = [1, 0]
    else:
        test_label[i] = [0, 1]
        
score_1 = model_1.evaluate(test_image, test_label, verbose=1)
score_2 = model_2.evaluate(test_image, test_label, verbose=1)

x = ['Binary Cross Entropy', 'Focal Loss']
y = [round(score_1[1]*100, 2), round(score_2[1]*100, 2)]

plt.bar(x, y, tick_label=x)    
plt.text(0, y[0], str(y[0]))
plt.text(1, y[1], str(y[1]))
plt.title('Accuracy Comparison')                           
plt.ylabel('Accuracy (%)')                  
plt.show()    
