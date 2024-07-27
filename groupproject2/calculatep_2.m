function [p_litter,p_notlitter] = calculatep_2(d)
    if d <= 6.096
        %d = 6.096 m or less (20 ft)
        p_litter = 0.12;
        p_notlitter = 1-p_litter;
    elseif d >= 6 && d <= 18.59 %6.096 m = 20 ft, 18.59 m = 61 ft
        p_litter = 0.0144*d + 0.0323;
        p_notlitter = 1-p_litter; 
    else %any distance > 18.59 m
        p_litter = 0.3;
        p_notlitter = 1- p_litter; 
    end
end 

%from Schultz et al. (2011) a study of littering behavior at 130 outdoor public spaces