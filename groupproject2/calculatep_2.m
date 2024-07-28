function p_litter = calculatep_2(d)
    if d <= 6.096
        %d = 6.096 m or less (20 ft)
        p_litter = 0.12;
    elseif d >= 6 && d <= 18.59 %6.096 m = 20 ft, 18.59 m = 61 ft
        p_litter = 0.0144*d + 0.0323;
    else %any distance > 18.59 m
        p_litter = 0.3;
    end
end 

%from Schultz et al. (2011) a study of littering behavior at 130 outdoor public spaces