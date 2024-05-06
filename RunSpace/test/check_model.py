# Import Library
import joblib, glob, os
import numpy as np

# Load Model
path_model = './GNSS_interpolation_model_dirEN.h5'
model = joblib.load(path_model)

# Load Test Data
path_test_data = 'segment-interval-01-testing'
textfiles = glob.glob(os.path.join(path_test_data, "*.txt"))

data_testing = np.array([])
for filename in textfiles:
  data_testing = np.loadtxt(filename)

print(data_testing.shape)

# Check Predicted Result
X = data_testing[:, :-2]
Y = data_testing[:, -2:]
my_test = np.array(X)
my_pred = model.predict(my_test)
time = 500

print("real = {:.6f}, {:.6f}".format(Y[time, 0], Y[time, 1]))
print("pred = {:.6f}, {:.6f}".format(my_pred[time, 0], my_pred[time, 1]))
print("diff = {:.6f}, {:.6f}".format((Y-my_pred)[time, 0], (Y-my_pred)[time, 1]))