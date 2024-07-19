%Code for Group Project 2
%Optimizing distance between public trash receptacles on sidewalks in
%Harvard Square

%p = 0 for scenario where bins are lined up shoulder-to-shoulder (in an
%ideal world where there are no bad apples)
%(d = 0 m)
%p = 1 after some threshold, set at 100 m
%for every 5 m increase, probability of littering increases by 0.05

%keep bin size constant at 2 m^3
%keep frequency of collection constant at once every 3 days (for Boston)
%we want to find threshold at which litter generated in 3 days = 2 m^3

%need to go out and measure this, but for now assume number of people
%passing by a given spot on the street can be modelled using a uniform
%distribution with lower bound at 20 people and upper bound at 50 for
%midday period on a weekday, i.e. 12-2 pm at Harvard Square
half_d = 50; %corresponds to p = 0.5; can probably do all the p's from 0 to 1
lower = 20; 
upper = 50;
p = 0.5; %50 m to the nearest trash bin. For simplicity, assume the person is smack-dab in the middle of two trash receptacles. 
% So we are actually modelling d/2
tend = 43200; %30 days * 24 hours * 60 minutes = 43200 minutes

T = zeros(tend,1); P = zeros(tend,1); V = zeros(tend,1); %define matrices for storing cumulative time, people, and volume of trash
T(1) = 0; P(1) = 0; V(1) = 0; 
error_tolerance = 1e-5; %for boolean operations to do what we want them to do
for t = 1:1:tend %assume we start the simulation the day of trash collection day at noon, and that garbage collection was at 8 am
    rpeople = round(lower + (upper-lower).*rand(1,1)); %pick a random number of people who pass by a given spot on the sidewalk between 20 and 50
    for j = 1:rpeople %for each person
        rlitter = rand(1,1);
        if r < p %someone will litter
            V(t) = V(t) + 0.1; %assume a litter item has a volume of 0.1 m^3
            P(t) = P(t) + 1; %measure cumulative number of people = random # per minute * total # of minutes (tend) 
        end 
    end
    if (mod(t,2640)-0) == error_tolerance %start at noon; 24 hours + 20 hours until 8 am of 3rd day. 44 hours * 60 = 2640 min
        V(t) = 0; %empty the trash receptacle
    end 
end 

%plot the results over time to see at which "d/2" the volume stays within
%the trash receptacle volume treshold (2 m^3)
tiledlayout(1,2); %one row, two columns 
time = 1:1:tend; 

nexttile %the volume vs time plot
plot(time,V)
xlabel('time')
ylabel('Volume of trash inside receptacle (m^3)')
title(['Volume vs time for distance between receptacles = ' num2str(half_d*2)])

nexttile %plot the cumulative people vs time plot
plot(time,P)
xlabel('time')
ylabel('People')
title(['Cumulative number of people over a ' num2str(tend) 'day period'])