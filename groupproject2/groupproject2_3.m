%Code for Group Project 2
%Optimizing distance between public trash receptacles on sidewalks in
%Harvard Square

%Objectives of this project: 
%1) determine minimum achievable amount of littering while taking costs of
%operation into consideration
%2) explore the phenomenon of overflowing trash receptacles and what factors influence this issue,
% including bin size, frequency of collection, budget cuts, etc. 
%3) compare model results to empirical data

%the "calculatep_2" function calculates the four p's using d

Vmax = 2; %keep bin size constant at 2 m^3
%keep frequency of collection constant at once every 3 days (for Boston)
%we want to find threshold at which litter generated in 3 days = 2 m^3
%midday period on a weekday, i.e. 12-2 pm at Harvard Square
tend = 43200; %30 days * 24 hours * 60 minutes = 43200 minutes
lower = 20;
upper = 50; 
d = 100; %for 100 m between trash receptacles %there are some trash receptacles in around Harvard campus & in Harvard Square area that are > 100 m apart 

%cost function: 
%choose a maximum annual budget 
%figure out how much the receptacles and labor costs in a year
%use "1 bin/100 m" density and divide total length of Boston's major roads
%by this number to get # bins
%cost per bin * # of bins + work hours*wage*# workers - compare with max budget to determine threshold bin density the city can afford

P = zeros(tend,1); V = zeros(tend,1); L = zeros(tend,1); %define matrices for storing people, trash volume, and litter items per minute
cumulativeV = zeros(tend,1);
overflow = zeros(tend,1);
P(1) = 0; V(1) = 0; L(1) = 0; 
error_tolerance = 1e-5; %for boolean operations to do what we want them to do
for t = 1:1:tend %assume we start the simulation the day of trash collection day at noon, and that garbage collection was at 8 am
    %at each timestep, we sum the litter produced per person
    
    rpeople = round(lower + (upper-lower).*rand(1,1)); %pick a random number of people who pass by a given spot on the sidewalk between 20 and 50
    for j = 1:rpeople %for each person
        dpeople = rand(1,1)*d; %generate a random distance where each person "spawns", i.e. starts at, between 0 m and 100 m
        r = rand(1,1); %random number for littering probability Monte Carlo
        [p_litter,p_notlitter] = calculatep_2(dpeople);
        if r < p_litter %someone will litter
            P(t) = P(t) + 1;
            L(t) = L(t) + 1; %record number of items littered in that minute
        else
            P(t) = P(t) + 1; %record number of people in that minute = random # per minute * total # of minutes (tend) 
            V(t) = V(t) + 0.1;  %assume a litter item has a volume of 0.1 m^3.
        end
    end
    cumulativeV(t) = cumulativeV(t-1) + V(t);
    if (mod(t,2640)-0) == error_tolerance %start at noon; 24 hours + 20 hours until 8 am of 3rd day. 44 hours * 60 = 2640 min
        if cumulativeV(t) > Vmax
            overflow(t) = cumulativeV(t)-Vmax; %assume all overflow ends up in the environment
        end
        cumulativeV(t) = 0; %empty the trash receptacle. When next for loop iteration starts, this will become the previous state
    end 
end 

sumoverflow = sum(overflow); %total overflow within a 30 day-period
%plot the results over time

tiledlayout(1,3); %one row, two columns 
time = 1:1:tend; 
nexttile %the cumulative volume vs time plot, and plot overflow on same axes
plot(time,cumulativeV)
plot(time,overflow)
xlabel('time')
ylabel('Volume of trash inside receptacle (m^3)')
title(['Volume vs time for distance between receptacles = ' num2str(d)])

nexttile %plot the number of people per minute vs time plot
plot(time,P)
xlabel('time')
ylabel('People')
title(['Number of people per minute over a ' num2str(tend) 'day period'])

nexttile %plot the number of litter items per minute vs time
plot(time,L)
xlabel('time')
ylabel('Litter (items)')
title(['Litter items generated per minute over a ' num2str(tend) 'day period'])

