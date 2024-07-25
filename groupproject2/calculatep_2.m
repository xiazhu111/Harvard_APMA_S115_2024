function [p_litter,p_notlitter] = calculatep_2(d)
    if d <= 3.7
        %d = 3.7 m or less
        p_litter = 0.12;
        p_notlitter = 1-p_litter;
    elseif d > 3.7 && d < 9.7 %sample a representative number of distances around Harvard first before choosing lower & upper bounds
        p_litter = 0.3/(1+exp(-(d-4.11)));
        p_notlitter = 1-p_litter; 
    else %any distance > 9.7 m 
        p_litter = 0.3;
        p_notlitter = 1- p_litter; 
    end
end 
