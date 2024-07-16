% stochastic model of an epidemic
close all; clear all;

% set parameters
a = 3*log(2); %doubling time of the infected
N = 10000; %total population
b = log(2); %half-life of an infected state

% simulate how S, I, R evolve over time


t                   = 1;
dt                  = 1e-4; %choose a small timestep so that in that interval, only one thing is happening
nsteps = t/dt;

S                   = zeros(nsteps, 1);
I                   = zeros(nsteps, 1);
R                   = zeros(nsteps, 1);

S(1)                = 990; %start with 990 susceptible individuals
I(1)                = 10; %start with 10 infected individuals. Choose a number > 0 to avoid risk of model stopping at I = 0
R(1)                = 0; %start with 0 recovered individuals
%choose evolution of model based on random number generator
while (t<nsteps)
  r=rand(1); %returns a 1x1 matrix of uniformly distributed random numbers between 0 and 1. Let population evolution be random
  p1 = I(t)*a/N*S(t)*dt; %multiply by S(t) to represent probability of any individual in the suspected group getting infected
  %same as law of addition: p1 + p2 + p3 ... ps = s*p1, if p1 = p2 = p3 ...
  %= ps
  p2 = b*I(t)*dt; 
  if (r<p1) %random number < birth rate
    S(t+1) = S(t) - 1;
    I(t+1) = I(t) + 1;
    R(t+1) = R(t);
  elseif (r<(p1 + p2)) %random number < (birth + death) rates
      S(t+1) = S(t);
      I(t+1) = I(t) - 1;
      R(t+1) = R(t) + 1; 
  else %p3 = 1 - p1 - p2; is the else condition 
      S(t+1) = S(t);
      I(t+1) = I(t);
      R(t+1) = R(t); 
  end
  t = t+1; %proceed until time limit
end

count = 1:1:nsteps;
figure, hold on 
plot(count,S); %an example of the time series
plot(count,I);
plot(count,R); 
legend('susceptible','infected','recovered');
ylabel('population');
xlabel('time steps');
title('stochastic simulation');