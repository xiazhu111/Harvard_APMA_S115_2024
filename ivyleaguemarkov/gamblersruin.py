import numpy as np
import matplotlib.pyplot as plt

p=0.5
P = np.array([[1, 0, 0, 0, 0], [1-p, 0, p, 0, 0], [0, 1-p, 0, p, 0], [0, 0, 1-p, 0, p], [0, 0, 0, 0, 1]])

n = 10000 #number of simulations
t=100 #number of time steps
states = np.array([0, 1, 2, 3, 4])
results = np.zeros(n)
#run the markov chain
for j in range(0, n):
    curr_state = 1 
    for i in range(0, t):
        curr_state = np.random.choice(states, p=P[curr_state]) #choose the next state
        if i == t-1:
            results[j] = curr_state #each entry in this array = final result after n = 100 timesteps. There are 10,000 final results
unique_values, counts = np.unique(results, return_counts=True)
counts = counts/n #plotted the probabilities at the end, which is why the results match the multiplication approach
#plot the results
plt.figure()
plt.bar(unique_values, counts)
plt.show()

#try another way
p = 0.5
P2 = np.array([[1, 0, 0, 0, 0], [1-p, 0, p, 0, 0], [0, 1-p, 0, p, 0], [0, 0, 1-p, 0, p], [0, 0, 0, 0, 1]])
p_vector = np.array([0,1,0,0,0]) #initial condition
t = 100
for i in range(0,t):
    p_vector = np.matmul(p_vector, P2) #probabilities at the end of 100 timesteps
values=np.arange(0,5)
plt.figure()
plt.bar(values,p_vector)
plt.show()
