%Group Project 1, what doses of the drug should be given and what should
%the period between doses be? 

%% System of Equations and Solving the Equations
%dDdt = -a*D + 1/g*B
%dBdt = k*B - g*D

for j=5000%[5 10 15] %examine effect of dose on bacteria population dynamics; 4.75, 6.5, or 8.5 ug/mL
    for g = 10%[1 100 1000] %assess sensitivity of drug efficacy/degree of antibiotic resistance. %try 3, 5, 20 bacteria killed per unit drug (1 ug/mL)
        
        %defining variables, initializing matrices, and defining initial states
        K = 10^10; %bacterial carrying capacity
        tend = 300; %time between doses = 8 hours. 8*60 = 480 minutes
        dt = 1e-3; %timestep
        nt = tend/dt; %nt = 2880001 timesteps for 8 hours; 300,000 for 5 hours
        trange = 0:dt:tend; %t = 0 to end of 8-hour period.
        a = 1/61.3; %elimination half-life = 61.3 min
        k = 1/2; %doubling time is 20 min for bacteria
        D1 = j; %initial drug concentration concides with peak plasma concentration for intravenous injection = 4.75 ug/mL for 250 mg dose
                  %6.5 ug/mL for 500 mg dose,
                  %or 8.5 ug/mL for 1000 mg dose (extrapolation)
        B1 = 10^6; %choose a big population of bacteria to begin with = infection
        %figure, hold on
        %tiledlayout(1,3) %for stringing resulting plots together

        for l=1:3 %168 hours in a week / 8 hours = 21
           
            %define the function. D = y(1), B = y(2). y's are the dependent variables
            opts=odeset('reltol',1.e-6);
            F=@(t,y) [-a*(K-y(1))/K*y(1) - 1/g*y(2); k*y(2)-g*y(1)]; %the two states of system; equations
            [t,y] = ode15s(F,trange,[D1;B1],opts); %ode45(F, [time range], [y(1) initial state; y(2) initial state])
            
            %nexttile 
            figure
            plot((t+tend*l),y,'-o') %plot y = plot y(1), y(2) 
            ylabel('y');
            xlabel(['timesteps. elapsed time (hour) = ' num2str(l*8)]);
            legend('drug concentration (ug/mL)','bacteria abundance (# cells)')
            title(['dose = ' num2str(j) ', drug efficacy = ' num2str(g)]);
            
            trange = 0:dt:tend; %move onto next 8 hours, but still start from what model considers as zero
            if y(length(y(:,1)),2) < 0 %if population dropped below zero, make zero
                B1 = 0;
                B1 = y(length(y(:,1)),2) %else, set final concentration of bacteria as initial concentration for next time period
            end 
            if y(length(y(:,1)),1) < 0 %if drug concentration fell below zero
                D1 = j;
            else 
                D1 = y(length(y(:,1)),1) + j; %where we left off + new dose
            end 
        end 
        %integrate use the ode solver
        %hold off
        %plot the results
    end
end 
