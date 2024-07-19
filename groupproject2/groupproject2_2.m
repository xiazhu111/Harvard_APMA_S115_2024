%Code for Group Project 2
%Optimizing distance between public trash receptacles on sidewalks in
%Harvard Square

%the "calculatep" function calculates the four p's using d

%keep bin size constant at 2 m^3
%keep frequency of collection constant at once every 3 days (for Boston)
%we want to find threshold at which litter generated in 3 days = 2 m^3
%midday period on a weekday, i.e. 12-2 pm at Harvard Square
tend = 43200; %30 days * 24 hours * 60 minutes = 43200 minutes
lower = 20;
upper = 50; 
d = 10; 

P = zeros(tend,1); V = zeros(tend,1); L = zeros(tend,1); %define matrices for storing people, trash volume, and litter items per minute
cumulativeV = zeros(tend,1);
P(1) = 0; V(1) = 0; L(1) = 0; 
error_tolerance = 1e-5; %for boolean operations to do what we want them to do
for t = 1:1:tend %assume we start the simulation the day of trash collection day at noon, and that garbage collection was at 8 am
    rpeople = round(lower + (upper-lower).*rand(1,1)); %pick a random number of people who pass by a given spot on the sidewalk between 20 and 50
    for j = 1:rpeople %for each person
        r = rand(1,1); 
        [p_notlitter,p_litter,p_thisbin,p_anotherbin] = calculatep(d);
        if r < p_notlitter %someone will litter
            P(t) = P(t) + 1;
        elseif r > p_notlitter && r < (p_notlitter + p_litter)
            L(t) = L(t) + 1; %record number of items littered in that minute
            P(t) = P(t) + 1; %record number of people in that minute = random # per minute * total # of minutes (tend) 
        elseif r > (p_notlitter + p_litter) && r < (p_notlitter + p_litter + p_thisbin)
            V(t) = V(t) + 0.1; %assume a litter item has a volume of 0.1 m^3. 
        else
            %trash ended up in another bin, but we don't need to record
            %that
        end
    end
    cumulativeV(t) = cumulativeV(t-1) + V(t);
    if (mod(t,2640)-0) == error_tolerance %start at noon; 24 hours + 20 hours until 8 am of 3rd day. 44 hours * 60 = 2640 min
        cumulativeV(t) = 0; %empty the trash receptacle. When next for loop iteration starts, this will become the previous state
    end 
end 

%plot the results over time to see at which "d/2" the volume stays within
%the trash receptacle volume treshold (2 m^3)
tiledlayout(1,3); %one row, two columns 
time = 1:1:tend; 
nexttile %the cumulative volume vs time plot
plot(time,cumulativeV)
xlabel('time')
ylabel('Volume of trash inside receptacle (m^3)')
title(['Volume vs time for distance between receptacles = ' num2str(half_d*2)])

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

