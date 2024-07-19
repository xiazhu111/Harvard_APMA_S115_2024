function pop=initial1D(s0,i0,r0)
%sets an initial population vector for the epidemic simulation
%each state subpopulation is appended to the growing vector, pop
%NOTE: if position in the array is important,eg. if you are modeling
%local neighborhood contacts, each individual must be placed 
%randomly in the array
pop=[];
for i=1:s0
    pop=[pop,'s']; %assign 's' to all the entities in the first column to begin with
end
for i=1:i0
    pop=[pop,'i']; %assign 'i' to all the entities in the second column to begin with
end
for i=1:r0
    pop=[pop,'r']; %%assign 'r' to all the entities in the third column to begin with
end
