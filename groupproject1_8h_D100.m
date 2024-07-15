%Group project 1 code
clearvars
close all
clc

format longg %display more decimal points

a = 1/61.3; %elimination half-life = 61.3 min
k = 1/100; %doubling time is 20 min for bacteria if there is unlimited food and space
g = 1/10; %number of bacterial cells killed per unit drug per minute
D1 = 100; %use molecules of amoxicillin - units need to match that of bacteria. assume 50 molecules = 500 mg dose, since 
         %we are scaling [drug] and [bacteria] down to have a workable
         %model
         %assume double that amount, i.e. 100, is toxic
repeateddose = 100;
B1 = 100;
l = 0; %before add in for loop
    tend = 480; %480 minutes = 8 hour between doses
    doserange = 1:1:tend; %1 x 480 matrix. Still 1 to 480 regardless of which dose you are on. Only initial conditions change
    %tend2 = 480;

    %simple model works
    %F=@(t,y) [-a*y(1); k*y(2)]; %multiply by y(1) to prevent it from going to zero %F=@(t,y) [(-a*y(1)-1/g*y(2))*y(1)/100; k*(K-y(2))/K*y(2) - g*y(1)];
    
    %make more complicated
    F=@(t1,y1) [-a*y1(1); (k*y1(2) - g*y1(1))*y1(2)/100]; %assume no drug is used up via interaction with bacteria
    % multiply by 100 scaling so results aren't extreme, make it not too directly proportional so changes aren't too big at beginning
    %play around with magnitude of parameters so results don't go crazy or
    %diverge too quickly 
    
    [t1,y1] = ode45(F,doserange,[D1;B1]); %solve the differential equations

    %add derivative of bacterial cell abundance to plot as well to more
    %easily locate the fixed points where dB/dt = 0
    dBdt = zeros(tend,1); %B values are stored in y1(2) 
    for r=1:tend
        dBdt(r) = (k*y1(r,2) - g*y1(r,1))*y1(r,2)/100; %drug concentrations are in y1(:,2) and drug concentrations are in y1(:,1)
    end
    tdBdt = horzcat(t1,dBdt);

    figure, hold on %plot of drug
    plot(t1,y1(:,1),'-o')
    plot(t1,0,'Color','black')
    %plot(t+t*l,y(:,2),'-o') 
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(l)]);
    legend('drug concentration (molecules)') %legend('drug concentration (ug/mL)','bacteria abundance (# cells)')
    title(['dose = ' num2str(repeateddose) ', drug efficacy = ' num2str(g)]);
    hold off 

    figure, hold on %plot of bacteria
    %plot(t+t*l,y(:,1),'-o') 
    plot(t1,y1(:,2),'-o') 
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(l)]);
    legend('bacteria abundance (# cells)')
    title(['dose = ' num2str(D1) ', drug efficacy = ' num2str(g)]);
    hold off 

    figure, hold on %plot of bacteria and drug together
    plot(t1,y1(:,1),'-o') 
    plot(t1,y1(:,2),'-o')
    plot(t1,dBdt)
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(1)]);
    legend('drug concentration (molecules)','bacteria abundance (# cells)','dB/dt')
    title(['dose = ' num2str(D1) ', drug efficacy = ' num2str(g)]);
    hold off 



    %dose 2
    %
    %
    %
    %set initial conditions for next dose
    if y1(length(y1(:,1)),2) < 0 %if population dropped below zero, make zero
        B1 = 0;
    else
        B1 = y1(length(y1(:,1)),2); %else, set final concentration of bacteria as initial concentration for next time period
    end 
    if y1(length(y1(:,1)),1) < 0 %if drug concentration fell below zero
        D1 = repeateddose;
    else 
        D1 = y1(length(y1(:,1)),1) + repeateddose; %where we left off + new dose (D1)
    end
    
    F=@(t2,y2) [-a*y2(1); (k*y2(2) - g*y2(1))*y2(2)/100]; %assume no drug is used up via interaction with bacteria
    % multiply by 100 scaling so results aren't extreme, make it not too directly proportional so changes aren't too big at beginning
    %play around with magnitude of parameters so results don't go crazy or
    %diverge too quickly 
    
    [t2,y2] = ode45(F,doserange,[D1;B1]);

    ttotal = 1:1:(tend*2);
    ytotal = [y1;y2];
   

    dBdt2 = zeros(tend,1); %B values are stored in y1(2) 
    for r=1:tend
        dBdt2(r) = (k*y2(r,2) - g*y2(r,1))*y2(r,2)/100; %drug concentrations are in y1(:,2) and drug concentrations are in y1(:,1)
    end
    tdBdt2 = horzcat(((tend+1):1:tend*2)',dBdt2);

    dBdt_total = [dBdt;dBdt2]; %actually derives don't look good on graph

    figure(2), hold on %plot of bacteria and drug together
    plot(ttotal,ytotal(:,1),'-o') 
    plot(ttotal,ytotal(:,2),'-o') 
    %plot(ttotal,dBdt_total)
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(2)]);
    legend('drug concentration (molecules)','bacteria abundance (# cells)')
    title(['dose = ' num2str(repeateddose) ', drug efficacy = ' num2str(g)]);
    hold off





    %dose 3
    %
    %
    %
     %set initial conditions for next dose
    if y2(length(y2(:,1)),2) < 0 %if population dropped below zero, make zero
        B1 = 0;
    else
        B1 = y2(length(y2(:,1)),2); %else, set final concentration of bacteria as initial concentration for next time period
    end 
    if y2(length(y2(:,1)),1) < 0 %if drug concentration fell below zero
        D1 = repeateddose;
    else 
        D1 = y2(length(y2(:,1)),1) + repeateddose; %where we left off + new dose (D1)
    end 
    
    
    F=@(t3,y3) [-a*y3(1); (k*y3(2) - g*y3(1))*y3(2)/100]; %assume no drug is used up via interaction with bacteria
    % multiply by 100 scaling so results aren't extreme, make it not too directly proportional so changes aren't too big at beginning
    %play around with magnitude of parameters so results don't go crazy or
    %diverge too quickly 
    
    [t3,y3] = ode45(F,doserange,[D1;B1]);

    ttotal = 1:1:(3*tend);
    ytotal = [y1;y2;y3];
    
    %find fixed point
    dBdt3 = zeros(tend,1); %B values are stored in y1(2) 
    for r=1:tend
        dBdt3(r) = (k*y3(r,2) - g*y3(r,1))*y3(r,2)/100; %drug concentrations are in y1(:,2) and drug concentrations are in y1(:,1)
    end
    tdBdt3 = horzcat(((tend*2+1):1:(tend*3))',dBdt3);

    figure(2), hold on %plot of bacteria and drug together
    plot(ttotal,ytotal(:,1),'-o') 
    plot(ttotal,ytotal(:,2),'-o') 
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(3)]);
    legend('drug concentration (molecules)','bacteria abundance (# cells)')
    title(['dose = ' num2str(repeateddose) ', drug efficacy = ' num2str(g)]);
    hold off
    

    
    %dose 4
    %
    %
    %
    %set initial conditions for next dose
    if y3(length(y3(:,1)),2) < 0 %if population dropped below zero, make zero
        B1 = 0;
    else
        B1 = y3(length(y3(:,1)),2); %else, set final concentration of bacteria as initial concentration for next time period
    end 
    if y3(length(y3(:,1)),1) < 0 %if drug concentration fell below zero
        D1 = repeateddose;
    else 
        D1 = y3(length(y3(:,1)),1) + repeateddose; %where we left off + new dose (D1)
    end 
    
    F=@(t4,y4) [-a*y4(1); (k*y4(2) - g*y4(1))*y4(2)/100]; %assume no drug is used up via interaction with bacteria
    % multiply by 100 scaling so results aren't extreme, make it not too directly proportional so changes aren't too big at beginning
    %play around with magnitude of parameters so results don't go crazy or
    %diverge too quickly 
    
    [t4,y4] = ode45(F,doserange,[D1;B1]);

    ttotal = 1:1:(4*tend);
    ytotal = [y1;y2;y3;y4];
    
    %find fixed point
    dBdt4 = zeros(tend,1); %B values are stored in y1(2) 
    for r=1:tend
        dBdt4(r) = (k*y4(r,2) - g*y4(r,1))*y4(r,2)/100; %drug concentrations are in y1(:,2) and drug concentrations are in y1(:,1)
    end
    tdBdt4 = horzcat(((tend*3+1):1:(tend*4))',dBdt4);

    figure(2), hold on %plot of bacteria and drug together
    plot(ttotal,ytotal(:,1),'-o') 
    plot(ttotal,ytotal(:,2),'-o') 
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(4)]);
    legend('drug concentration (molecules)','bacteria abundance (# cells)')
    title(['dose = ' num2str(repeateddose) ', drug efficacy = ' num2str(g)]);
    hold off
    



    %
    %
    %
    %dose 5
    %
    %



    if y4(length(y4(:,1)),2) < 0 %if population dropped below zero, make zero
        B1 = 0;
    else
        B1 = y4(length(y4(:,1)),2); %else, set final concentration of bacteria as initial concentration for next time period
    end 
    if y4(length(y4(:,1)),1) < 0 %if drug concentration fell below zero
        D1 = repeateddose;
    else 
        D1 = y4(length(y4(:,1)),1) + repeateddose; %where we left off + new dose (D1)
    end 
    
    F=@(t5,y5) [-a*y5(1); (k*y5(2) - g*y5(1))*y5(2)/100]; %assume no drug is used up via interaction with bacteria
    % multiply by 100 scaling so results aren't extreme, make it not too directly proportional so changes aren't too big at beginning
    %play around with magnitude of parameters so results don't go crazy or
    %diverge too quickly 
    
    [t5,y5] = ode45(F,doserange,[D1;B1]);

    ttotal = 1:1:(5*tend);
    ytotal = [y1;y2;y3;y4;y5];
    
    %find fixed point
    dBdt5 = zeros(tend,1); %B values are stored in y1(2) 
    for r=1:tend
        dBdt5(r) = (k*y5(r,2) - g*y5(r,1))*y5(r,2)/100; %drug concentrations are in y1(:,2) and drug concentrations are in y1(:,1)
    end
    tdBdt5 = horzcat(((tend*4+1):1:(tend*5))',dBdt5);

    figure(2), hold on %plot of bacteria and drug together
    plot(ttotal,ytotal(:,1),'-o') 
    plot(ttotal,ytotal(:,2),'-o') 
    ylabel('y');
    xlabel('time')
    xlabel(['timesteps. elapsed doses = ' num2str(5)]);
    legend('drug concentration (molecules)','bacteria abundance (# cells)')
    title(['dose = ' num2str(repeateddose) ', drug efficacy = ' num2str(g)]);
    hold off
    
    %observe at what point in time bacterial cell count falls below zero
    M = horzcat(ttotal',ytotal);