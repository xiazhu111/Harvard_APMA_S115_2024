clearvars
close all
clc

% run simulate1D many times
maxsizett = 0; %store maximum length out of the 100 matrices
sizett = zeros(2,1); %row x column

n = 10000; %population size. # of timesteps vary with every iteration
nc = 10; %number of infectious contacts before becoming r
pt = 0.5; %s goes to i with probability pt after contact with i

iterations = 100;
rng(1,"twister"); %set seed
for i=1:iterations
    [tt, results] = simulate1D(n,nc,pt);
    sizett = size(tt);
    if sizett(1,1) > maxsizett
        maxsizett = sizett(1,1); %get length of longest results matrix. Every time, results matrix is different length
        %depending on when # infected = 0
    end 
end 

rng(1,"twister"); %set seed so previous findings match these ones
sizett2 = zeros(2,1); %for keeping track of results matrix lengths or # of rows
currentresult = zeros(maxsizett,3); %for making matrices all the same length
finalrow = zeros(1,3); %to be appended a given number of times; # of times = diff between max size and current size
resultssum = zeros(maxsizett,3);
averages = zeros(maxsizett,3);
for i=1:iterations
    [tt,results] = simulate1D(n,nc,pt);
    sizett2 = size(tt);
    finalrow = results(height(results),:);
    if sizett2(1,1) < maxsizett
        currentresult = [results;repmat(finalrow,maxsizett-sizett2(1,1),1)]; %make all the matrices same length as longest results matrix
    end
    resultssum = resultssum + currentresult; %add all the results matrices together
end 

averages = int16(resultssum/100); %take the average of all the replicates then convert to integers

figure(1), hold on
x = 1:1:maxsizett;
title(['nc = ' num2str(nc) ', pt = ' num2str(pt)])
plot(x,averages(:,1),'-o','Color','magenta') %plot y = plot y(1), y(2), and y(3)
plot(x,averages(:,2),'-o','Color','red')
plot(x,averages(:,3),'-o','Color','green')
xlabel('timestep');ylabel('y')
legend('susceptible','infected','recovered')
hold on;
