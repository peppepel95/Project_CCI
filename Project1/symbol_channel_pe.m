function pe = symbol_channel_pe(x)
    %% calcolo della probabilità di errore per epsilon = x
    pe = 4*(x*(1-x)^3)+6*(x^2 *(1-x)^2)+4*(x^3*(1-x))+x^4;
end