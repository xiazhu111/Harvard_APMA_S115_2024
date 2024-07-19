function aa = changeA(guarantee)
    if guarantee <= 10
        aa = 5 ;
    elseif guarantee <= 30 && guarantee > 10
        aa = -1/5 * guarantee + 7;
    else
        aa = 1 ;
    end 
end