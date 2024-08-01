%age of Earth workshop 
%% numerical solution

%define the number of grid points
m=2000;

%grid spacing
dx=1; %dx = 1 km, m = 6371
%Define the grid
x=linspace(dx,m*dx,m)'; %6371 km radius of Earth. m controls # of steps, x is size of step 

time_e=100; %integration time

%initial condition
y0= zeros(m,1)+2000; %all 2000s

%Define diffusivity
D=37.86; %units of km2/Myr

%define the Laplacian operator
e1=ones(m,1); % build a vector of ones
A=spdiags([e1 -2*e1 e1],[-1 0 1],m,m); %diagonals
gradient = 25; %25 oC/km 
%assume fixed y values at boundaries
b=zeros(m,1); %temperatures
b(1)=0; b(end)=y0(end); %surface conditions
% take to be the same as nearby initial values but doesn't have to be so

%If it is the no flux boundary condition, modify A as the follows
%Think about why.
%A(1,1)=-1;
%A(m,m)=-1;
%b(:)=0;

%-------------------------------------------
%use ode solvers for this; method of lines
%-------------------------------------------

F=@(t,y) D*(A*y+b)/dx^2; %losing heat function 

[t y]=ode45(F,[0 time_e],y0); %range of [0 to 100 million years] 
%for i=1:size(y,1);
%    plot(x,y(i,:),'r-o');
%    pause(0.01);
%end

%we only want to plot y(2) 
plot(t,y(:,1)) %when does temperature at distance 1 km below surface drop below 25oC
xlabel("time (million year)")
ylabel("temperature (oC)")

%% analytical solution
%plot u(x,t) = (y0-ys)/sqrt(pi*D*t)*e^(-x^2/(4*D*t))
u0 = 2000; D = 37.86; us = 0; 
t = 1:1:100;
u = zeros(100,1);
for i=1:100
    u(i) = (u0 - us)/sqrt(pi*D*t(i))*exp(-1/(4*D*t(i)));
end
plot(t,u) %100 million years

%also 54 years-ish like numerical solution



