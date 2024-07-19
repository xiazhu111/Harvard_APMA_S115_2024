function pop2=epidemic1D(nc,pt,pop1)
%this stochastic epidemic simulation calculates a new pop2
%vector of 's', 'i', and 'r' from the current pop1 assuming
%that all 'i' cells go to 'r' after each has nc random
%infectious contacts with other cells. An 's' cell goes
%to 'i' with probability, pt, if it is contacted by an 'i'.
pop2=pop1;  %set up new vector
n=length(pop1); 
for j=1:n
    if pop1(j)=='i' % i = infected. Each entry in pop1 is a different individual. That means n = # of individuals
        for c=1:nc   %nc contacts, number of contact parameters that specify the particular population
            k=j; 
            while k==j %try to generate a random k NOT equal to j
                k=randi([1,n]); %random individual to contact
            end
            if pop1(k)=='s' && rand<pt %rand<pt generates a Bernoulli trial % s = susceptible
                %pt = number of virulence parameters which specify the
                %particular disease
                pop2(k)='i';  %infect the 's' cell
            end
        end
        pop2(j)='r';  %then the jth individual recovers  % r = immune, recovered
    end
end
