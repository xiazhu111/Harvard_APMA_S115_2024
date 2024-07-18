%we care about profit margin
%relevant processes: $ per meal, $used to make meal, service time (how fast
%to prepare food) mean and distribution, customer arrival pattern (how
%customer will respond to your policy) depends on time guarantee you set
count = 1;
profitsum = zeros(99,1); %for 1:0.5:20 interval
for guarantee=1:0.05:50
    % average number of arrivals per minute
    a = changeA(guarantee);
    b = 3; % average number of people served per minute (reduce from 1.5 to 1.1 or 0.95)
    ncust = 10000; %number of customers
    make = 5; %money spent to make food
    sell = 20; %money made when sell food
    %start with time guarantee of 10 min - use to calculate profit, use to
    %inform behaviour response function 
    
    % at = arrival time of a person joining the queue, average # start time,
    % cumulative minutes; each row is a person
    % st = service time once they reach the front
    % ft = finish time after waiting and being served.
    at = zeros(ncust,1);
    ft = zeros(ncust,1);
    profit = zeros(ncust,1);
    % Generate random arrival times assuming Poisson process:
    r = rand(ncust,1);
    iat = -1/a * log(r); % Generate inter-arrival times, exponential distribution
    at(1) = iat(1); % Arrival time of first customer
    for i=2:ncust
        at(i) = at(i-1) + iat(i); % arrival times of other customers
    end
    % Generate random service times for each customer:
    r = rand(ncust,1);
    st = -1/b * log(r); % service time for each customer, follow an exponential distribution 
    % Compute time each customer finishes:
    ft(1) = at(1)+st(1); % finish time for first customer
    for i=2:ncust
        % compute finish time for each customer as the larger of
        % arrival time plus service time (if no wait)
        % finish time of previous customer plus service time (if wait)
        ft(i) = max(at(i)+st(i), ft(i-1)+st(i));
    end
    
    total_time = ft - at; % total time spent by each customer
    wait_time = total_time - st; % time spent waiting before being served
    ave_service_time = sum(st)/ncust
    ave_wait_time = sum(wait_time)/ncust
    ave_total_time = sum(total_time)/ncust
    
    for i=1:ncust %guarantee = 10
        if total_time(i) <= guarantee
            profit(i) = sell - make;
        else
            profit(i) = -make;
        end
    end
    
    %sum profits and store in profitsum()
    profitsum(count) = sum(profit)/ft(end);
    count = count +1;

end


%store_profits=zeros(10, 1)
%idx, a in enumerate(a)
%for a=1:0.1:2
%    store_profit[count(a)]=profit_calc(a)


% Plot histogram of waiting times:

%%clf
%subplot(3,1,1)
%hist(total_time,0.25:.5:floor(max(total_time))+0.25);axis tight;
%ylabel('# of occurrence');
%xlabel('Total time spent (minutes))');
%subplot(2,1,2)
%plot(at,total_time)
figure(1), hold on
plot(1:0.05:50,profitsum,'-','Color','blue');
xlabel('Time guaranteed (minutes)');
ylabel('Profit ($)');
hold off

profitsum
