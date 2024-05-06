import os
import sys
from keras.models import Model
from keras.layers import Flatten, Dense, Dropout
from keras.applications.resnet import ResNet50
from keras.optimizers import Adam
from keras.preprocessing.image import ImageDataGenerator
from focal_loss import BinaryFocalLoss

# Data Path
path = os.path.join(sys.path[0])
DATASET_PATH  = path + '\\dataset'

# Image Size
IMAGE_SIZE = (224, 224)

# Image Class Number
NUM_CLASSES = 2

# Batch Size
BATCH_SIZE = 32

# Freeze Layer Number
FREEZE_LAYERS = 10

# Epoch Number
NUM_EPOCHS = 20

# Model Name
WEIGHTS_FINAL = 'model_resnet50__BinaryFocalLoss.h5'

# Generation Training Data and Validation Data
train_datagen = ImageDataGenerator(rotation_range=40, width_shift_range=0.2, height_shift_range=0.2, shear_range=0.2, 
                                   zoom_range=0.2, channel_shift_range=10, horizontal_flip=True, fill_mode='nearest')
train_batches = train_datagen.flow_from_directory(DATASET_PATH + '/training_dataset', target_size=IMAGE_SIZE, 
                                                  interpolation='bicubic', class_mode='categorical', shuffle=True, 
                                                  batch_size=BATCH_SIZE)

valid_datagen = ImageDataGenerator()
valid_batches = valid_datagen.flow_from_directory(DATASET_PATH + '/validation_dataset', target_size=IMAGE_SIZE, 
                                                  interpolation='bicubic', class_mode='categorical', shuffle=False, 
                                                  batch_size=BATCH_SIZE)

# Output the Index of Class
for cls, idx in train_batches.class_indices.items():
    print('Class #{} = {}'.format(idx, cls))

# ResNet50
# Miss the First Fully Connected Layers of ResNet50 
net = ResNet50(include_top=False, weights='imagenet', input_tensor=None,
               input_shape=(IMAGE_SIZE[0],IMAGE_SIZE[1],3))
x = net.output
x = Flatten()(x)

# Increase DropOut Layer
x = Dropout(0.5)(x)

# Increase Dense Layer with Softmax
output_layer = Dense(NUM_CLASSES, activation='softmax', name='softmax')(x)

# Setting Freeze Layer and Training Network
net_final = Model(inputs=net.input, outputs=output_layer)

for layer in net_final.layers[:FREEZE_LAYERS]:
    layer.trainable = False
    
for layer in net_final.layers[FREEZE_LAYERS:]:
    layer.trainable = True

# Using Adam Optimizer in Lower Learning Rate and Trying Fine-Tuning
net_final.compile(optimizer=Adam(lr=1e-5),
                  loss=BinaryFocalLoss(gamma=1.0), metrics=['accuracy'])

# Summay the Net
print(net_final.summary())

# Training Model
net_final.fit_generator(train_batches, steps_per_epoch = train_batches.samples // BATCH_SIZE,
                        validation_data = valid_batches, validation_steps = valid_batches.samples // BATCH_SIZE,
                        epochs = NUM_EPOCHS, verbose=1)

# Save Model
net_final.save(WEIGHTS_FINAL)