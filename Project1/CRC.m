function [my_CRC usi_di_canale] = CRC(msg,epsilon,gen,detect)
    usi_di_canale = 7;
    % Codifica
    codeword = step(gen,msg);
    % Canale
    out1 = bsc(codeword,epsilon);
    % Decodifica
    [out2,err] = step(detect,out1);
    
    if (sum(err) > 0) % Errore
        % Invio un ack per indicare l'errata trasmissione
        ack = bsc(1,epsilon);
        usi_di_canale = 8;
        % Se i trasmettitore riceve l'ack rimanda il simbolo
        if (ack == 1)
            codeword_long = step(gen,msg);
            out1 = bsc(codeword_long,epsilon);
            [out2,err] = step(detect,out1);
            usi_di_canale = 15;
        end
    end
    [my_CRC, perc] = biterr(msg,out2);
    
end