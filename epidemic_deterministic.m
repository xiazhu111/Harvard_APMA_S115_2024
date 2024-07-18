%deterministic model of an epidemic
function epidemic_deterministic
clf

a=2*log(2); %doubling time of the infected
N=1000; %total population
b = log(2); %half-life of an infected state

%define the function. I = y(2), S = y(1), R = y(3). y's are the dependent
%variables
F=@(t,y) [-a/N * y(2) *y(1); a/N*y(1)*y(2) - b*y(2);b*y(2)]; %the three states of system equations

[t,y] = ode45(F,[0 20],[999; 1; 0]); %ode45(F, [time range], [y(1) initial state; y(2) initial state; y(3) initial state]

%integrate use the ode solver

%plot the results
hold on;
plot(t,y,'-o') %plot y = plot y(1), y(2), and y(3) 
xlabel('t');ylabel('y')
legend('susceptible','infected','recovered')
hold on;
