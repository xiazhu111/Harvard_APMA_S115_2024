%Final Project
%Modelling concentrations of nanoplastic particles (50-100 nm diameter) in human blood
clearvars
close all
clc

%Contributions to field: 
% 1) determine rates of transfer of NPs from GI tract to specific organs using inverse modelling
% 2) compare modelled amounts to toxicity thresholds that have come out since Nor et al. (2021)

%define parameters - intake 
k_ingest = 883; %median intake of 883 particles/day for adults (Nor et al., 2021); divided by 3 meals ~ 300 particles/meal 
k_inhale = 80; %(inhalation rate) = 9.7-26.7 m^3/day for an adult. 
% C(air) = 95th percentile is 4.28 particles/m3, Nor et al. (2021) used skew-normal distribution 
%to represent concentration of MP in air. 4 particles/m3 * 20 m^3/day. For an adult = 80 particles/day %50th
%percentile is 1.56 particles/m3

%define parameters - rate constants (particles/s) and probabilities
f_sizefraction = 1; %we are doing a specific size fraction of NPs. Calculate what fraction of ingested particles this accounts for
f_abs = 0.003; %0.2-0.45% of plastic in GI tract is absorbed into intestinal tissue and made available to the rest of the body
f_dep = 0.83; % 83% of particles deposited in nasopharyngeal cavity gets swallowed and ingested
f_heart = 0.2; f_kidney = 0.2; %vary the values of these parameters to see which partitioning coefficients agree with data 
f_else = 1 - f_heart - f_kidney;

%define parameters - elimination (particles/s)
k_biliary = 0.61; %scenario-based analysis in Nor et al. (2021): 0, 0.067, 0.61, 8.30 d-1 
k_loss = 2; %stool frequency = 0.4-3 day-1 for an adult
M_loss = 400; %stool mass = 51-796 g/person/day 
%plastic lost per day = M_loss * k_loss * concentration MP in stool
C_SS = 1; %steady-state concentration of nanoplastic in the gut (GI tract)

tend = 21; %8 hour periods; 3*8*7 = 21 8-hour periods in a week
timestep = 1; %1 hour
%define a function using all of these parameters that continuously adds
%additional particles based on when people breath and eat. See
%'climate_hysteresis' for example. Use this function in ode45
%set initial conditions
GI = 300; heart = 0; kidney = 0; else0 = 0; tstart = 0; tend = 8; count = 0; 
Cgi = GI;Cheart = heart;Ckidney = kidney;Celse = else0; totaltime = [];
%eating at regular intervals - assuming inhalation does not matter at the
%hourly timescale 
for m=2:1:tend %21 8-hour periods in a week
    Cgi_prev = Cgi(m-1);
    Cheart_prev = Cheart(m-1);
    Ckidney_prev = Ckidney(m-1);
    Celse_prev = Celse(m-1); 
    %y(1) = Cgi, y(2) = Cheart, y(3) = Ckidney, y(4) = C in rest of body
    F=@(t,y) [(1-f_abs*f_sizefraction)*k_ingest+(1-f_abs)*(f_dep)*k_inhale + k_biliary*(y(2) + y(3) + y(4)) - k_loss*C_SS/M_loss; f_heart*f_abs*f_sizefraction*k_ingest + f_heart*f_abs*k_inhale*f_dep - k_biliary*y(2);f_kidney*f_abs*f_sizefraction*k_ingest + f_kidney*f_abs*k_inhale*f_dep - k_biliary*y(3)];
    
    [t,y] = ode45(F,[tstart tend],[GI;heart;kidney]); 
    error_tolerance = 1e-5;
    %set values for next period 
    if mod(t,8) < error_tolerance
        GI = y(length(y(:,1)),1) + 300; %you ate another 300 pieces of nanoplastic
    else
        GI = y(length(y(:,1)),1); 
    end 
    heart = y(length(y(:,1)),2); %last entry of second column
    kidney = y(length(y(:,1)),3); 

    %after every hour, append the concentrations & times to 
    %the existing vectors 
    totaltime = [totaltime;t]; 
    Cgi = [Cgi;y(1)]; Cheart = [Cheart;y(2)]; Ckidney = [Ckidney;y(3)]; 
    count = count + 1;
    tstart = count*8; %advance to next 8-hour period 
    tend = (count+1)*8; 
end 

%one-time occupational exposure in addition to regular breathing and eating
%GI = 300 ingestion + a large number for inhalation

%at end of simulation, convert counts to ug, divide by mass of organ, and plot concentration of nanoplastic (ug/g) in each of the four
%locations in the human body over time
Cgi_mass = Cgi*10^-9; %1 particle ~ 1 ng 
Cheart_mass = Cheart*10^9; %ng
Ckidney_mass = Ckidney*10^9; %ng 
Mgi = 1; %mass of GI tract (g)
Mheart = 1; %mass of heart (g)
Mkidney = 1; %mass of kidney (g) 

time = 1:1:tend; 
figure(1), hold on
plot(time,Cgi_mass/Mgi) %ng/g
plot(time,Cheart_mass/Mheart) %ng/g
plot(time,Ckidney_mass/Mkidney) %ng/g
xlabel('time (s)'); ylabel('Concentration')
title('Temporal dynamics of micro- and nano-plastic particles in the human body')
legend('Conc. in GI tract','Conc. in heart','Conc. in kidney') %'Conc. in liver')

%to validate results or choose suitable values for uncertain parameters:
%compare with measurements of concentration of plastic in blood, feces
%[plastic] in blood = 1.6 ug/mL
%[plastic] in feces = 0.093-16.13 ug/g
