import numpy as np
import matplotlib.pyplot as plt

P = np.array([[1,0,0,0,0,0],[0,0,0,1,0,0],[1/4,0,1/2,1/4,0,0],[1/16,1/8,1/4,1/4,1/4,1/16],[0,0,0,1/4,1/2,1/4],[0,0,0,0,0,1]])
#switch column 3 and 6, switch row 3 and 6

#initial conditions
p_vector = np.array([1/16,1/4,1/8,1/16,1/4,1/4])
print(p_vector)

n = 10000 #number of simulations
t = 100 #number of timesteps

for i in range(0,t):
    p_vector = np.matmul(p_vector, P) 

values=np.arange(0,6)
plt.figure()
plt.bar(values,p_vector)
plt.show()
