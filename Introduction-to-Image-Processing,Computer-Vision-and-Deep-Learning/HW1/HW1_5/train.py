import time
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from keras.utils import np_utils
from keras.callbacks import Callback
from keras.models import Model, load_model, save_model
from keras.layers import Input, Dense, Flatten, Dropout, Conv2D, MaxPooling2D, BatchNormalization

# Load cifar10 Data
(x_train_image, y_train_label), (x_test_image, y_test_label) = tf.keras.datasets.cifar10.load_data()
#print(x_train_image.shape, y_train_label.shape, x_test_image.shape, y_test_label.shape, sep="\n")

# Normalization [0, 255] -> [0.0, 1.0]
x_train = x_train_image.reshape(x_train_image.shape[0], 32, 32, 3).astype('float32')
x_test = x_test_image.reshape(x_test_image.shape[0], 32, 32, 3).astype('float32')
x_train_norm = x_train / 255
x_test_norm = x_test / 255
#print(x_train.shape, y_train_label.shape, x_test.shape, y_test_label.shape, sep="\n")

# Transfer Image Label into One-Hot-Encoding
y_TrainOneHot = np_utils.to_categorical(y_train_label)
y_TestOneHot = np_utils.to_categorical(y_test_label)
#print(y_TrainOneHot[:10])

# Build a Neural Network
input = Input(shape=(32, 32, 3))

# 1-1
conv1_1 = Conv2D(filters=64, kernel_size=(3, 3), padding='same', activation='relu')(input)
conv1_1 = BatchNormalization()(conv1_1)

# 1-2
conv1_2 = Conv2D(filters=64, kernel_size=(3, 3), padding='same', activation='relu')(conv1_1)
conv1_2 = BatchNormalization()(conv1_2)

# Pool1
maxPool1 = MaxPooling2D(pool_size=(2, 2))(conv1_2)

# 2-1
conv2_1 = Conv2D(filters=128, kernel_size=(3, 3), padding='same', activation='relu')(maxPool1)
conv2_1 = BatchNormalization()(conv2_1)

# 2-2
conv2_2 = Conv2D(filters=128, kernel_size=(3, 3), padding='same', activation='relu')(conv2_1)
conv2_2 = BatchNormalization()(conv2_2)

# Pool2
maxPool2 = MaxPooling2D(pool_size=(2, 2))(conv2_2)

# 3-1
conv3_1 = Conv2D(filters=256, kernel_size=(3, 3), padding='same', activation='relu')(maxPool2)
conv3_1 = BatchNormalization()(conv3_1)

# 3-2
conv3_2 = Conv2D(filters=256, kernel_size=(3, 3), padding='same', activation='relu')(conv3_1)
conv3_2 = BatchNormalization()(conv3_2)

# 3-3
conv3_3 = Conv2D(filters=256, kernel_size=(3, 3), padding='same', activation='relu')(conv3_2)
conv3_3 = BatchNormalization()(conv3_3)

# 3-4
conv3_4 = Conv2D(filters=256, kernel_size=(3, 3), padding='same', activation='relu')(conv3_3)
conv3_4 = BatchNormalization()(conv3_4)

# Pool3
maxPool3 = MaxPooling2D(pool_size=(2, 2))(conv3_4)

# 4-1
conv4_1 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(maxPool3)
conv4_1 = BatchNormalization()(conv4_1)

# 4-2
conv4_2 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv4_1)
conv4_2 = BatchNormalization()(conv4_2)

# 4-3
conv4_3 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv4_2)
conv4_3 = BatchNormalization()(conv4_3)

# 4-3
conv4_4 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv4_3)
conv4_4 = BatchNormalization()(conv4_4)

# Pool4
maxPool4 = MaxPooling2D(pool_size=(2, 2))(conv4_4)

# 5-1
conv5_1 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(maxPool4)
conv5_1 = BatchNormalization()(conv5_1)

# 5-2
conv5_2 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv5_1)
conv5_2 = BatchNormalization()(conv5_2)

# 5-3
conv5_3 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv5_2)
conv5_3 = BatchNormalization()(conv5_3)

# 5-4
conv5_4 = Conv2D(filters=512, kernel_size=(3, 3), padding='same', activation='relu')(conv5_3)
conv5_4 = BatchNormalization()(conv5_4)

# Pool5
maxPool5 = MaxPooling2D(pool_size=(2, 2))(conv5_4)

# Flatten
flat1 = Flatten()(maxPool5)

# Fully Connection Layer
dense1 = Dropout(0.35)(Dense(units=1024, activation='relu')(flat1))
dense2 = Dropout(0.35)(Dense(units=512, activation='relu')(dense1))
output = Dense(units=10, activation='softmax')(dense2)

# Summary
model = Model(input, output)
model.summary(line_length=100, positions=[0.55, 0.8, 1])

# Accuracy & Loss
score = np.zeros((2, 25),dtype=np.float32)
class LossAndErrorPrintingCallback(Callback):
    def on_epoch_end(self, epoch, logs=None):
        (score[0][epoch], score[1][epoch]) = model.evaluate(x_test_norm, y_TestOneHot, verbose=2)

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
train_history = model.fit(x=x_train_norm, y=y_TrainOneHot, validation_split=0, epochs=25, batch_size=32, verbose=1, callbacks=[LossAndErrorPrintingCallback()])

# Plot
def show_train_history(history, train, test):
    plt.plot(history.history[train])
    plt.plot(score[test])
    plt.title('Train History')
    plt.ylabel(train)
    plt.xlabel('Epoch')
    plt.legend(['train', 'test'], loc='upper left')
    plt.show()

show_train_history(train_history, 'accuracy', 1)
show_train_history(train_history, 'loss', 0)

# Save Model
current_time = time.strftime("%H-%M-%S", time.localtime())
save_model(model, current_time + ".h5")
model.save(current_time)