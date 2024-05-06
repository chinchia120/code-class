# Import Library
import joblib, glob, os
import numpy as np
from wgs84_to_twd97 import wgs84_to_twd97
import matplotlib.pyplot as plt

# Load Model
path_model = './GNSS_interpolation_model_dirEN.h5'
model = joblib.load(path_model)

# Load GGA Data
path_test_data = './GGA-Data'
textfiles = glob.glob(os.path.join(path_test_data, "*.txt"))

my_data = np.array([])
my_real = np.array([])
for filename in textfiles:
    f = open(filename)
    cnt = 0
    for line in f:
        tmp = line.split(',')
        wgs84 = wgs84_to_twd97(float(tmp[4])/100, float(tmp[2])/100)
        if cnt == 0:   
            my_data = np.append(my_data, [wgs84[0], wgs84[1]])
            my_real = np.append(my_real, [wgs84[0], wgs84[1]])
        else:
            my_data = np.append(my_data, [wgs84[0], wgs84[1]])
            my_data = np.append(my_data, [wgs84[0], wgs84[1]])
            my_real = np.append(my_real, [wgs84[0], wgs84[1]])
        cnt = 1
    my_data = np.delete(my_data, -1)
    my_data = np.delete(my_data, -1)
    f.close()

my_data = my_data.reshape(-1, 4)
my_real = my_real.reshape(-1, 2)

# Check Predicted Result
my_test = np.array(my_data)
my_pred = model.predict(my_test)

time = 10
#print("pred = {:.6f}, {:.6f}".format(my_pred[time, 0], my_pred[time, 1]))

# Create Plot
'''
plt.ion()
plt.scatter(my_pred[0, 0], my_pred[0, 1], c='red')
plt.title('Predicted Track')
plt.xlabel('E')
plt.ylabel('N')
plt.grid()

for i in range(my_pred.shape[0]-1):
    plt.scatter(my_pred[0: i+1, 0], my_pred[0: i+1, 1], c='red')
    plt.pause(0.05)

plt.ioff()
plt.show()
'''

fig, ax = plt.subplots(2, 2)
plt.ion()

ax[0, 0].scatter(my_pred[0, 0], my_pred[0, 1], c='red')
ax[0, 0].set_title('Predicted Track')
ax[0, 0].set_xlabel('E')
ax[0, 0].set_ylabel('N')
ax[0, 0].set_xlim([min(my_pred[:, 0])-50, max(my_pred[:, 0])+50])
ax[0, 0].set_ylim([min(my_pred[:, 1])-50, max(my_pred[:, 1])+50])
ax[0, 0].grid()

ax[0, 1].scatter(my_real[0: 1, 0], my_real[0: 1, 1], c='blue')
ax[0, 1].set_title('GNSS Track')
ax[0, 1].set_xlabel('E')
ax[0, 1].set_ylabel('N')
ax[0, 1].set_xlim([min(my_pred[:, 0])-50, max(my_pred[:, 0])+50])
ax[0, 1].set_ylim([min(my_pred[:, 1])-50, max(my_pred[:, 1])+50])
ax[0, 1].grid()

ax[1, 0].scatter(my_pred[0, 0], my_pred[0, 1], c='red')
ax[1, 0].scatter(my_real[0: 1, 0], my_real[0: 1, 1], c='blue')
ax[1, 0].set_title('Predicted and GNSS Track')
ax[1, 0].set_xlabel('E')
ax[1, 0].set_ylabel('N')
ax[1, 0].set_xlim([min(my_pred[:, 0])-50, max(my_pred[:, 0])+50])
ax[1, 0].set_ylim([min(my_pred[:, 1])-50, max(my_pred[:, 1])+50])
ax[1, 0].grid()

print(my_real[0])
print(my_real[1])
#print(my_pred[0])

for i in range(my_pred.shape[0]-1):
    ax[0, 0].scatter(my_pred[0: i+1, 0], my_pred[0: i+1, 1], c='red')
    
    ax[0, 1].scatter(my_real[0: i+2, 0], my_real[0: i+2, 1], c='blue')
    
    ax[1, 0].scatter(my_pred[0: i+1, 0], my_pred[0: i+1, 1], c='red')
    ax[1, 0].scatter(my_real[0: i+2, 0], my_real[0: i+2, 1], c='blue')
    print(my_real[i+2])
    #print(my_pred[i+1])
    plt.pause(0.05)
    
plt.ioff()
plt.show()
