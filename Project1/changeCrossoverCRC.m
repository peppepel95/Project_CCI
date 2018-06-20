function [pe_bit, pe_cw, eps, eps_sym, Rate] = changeCrossoverCRC(num)
    %% generazione degli oggetti gen e detect
    gen = comm.CRCGenerator([1 0 0 1],'ChecksumsPerFrame',1);
    detect = comm.CRCDetector([1 0 0 1],'ChecksumsPerFrame',1);

    % Passo aumento crossover
    step = 1/num;
    % Probabilità di errore di bit media
    pe_bit = [];
    %probabilità di errore di simbolo media
    pe_cw = [];
    %Rate per ogni canale utilizzato
    Rate = [];
    
    % per epsilon che va da 0 a 0.5
    for i=0:step:0.5
        % calcolo P(e)
        [x, x1, rate] = test_CRC(1000*1000,[0.5 0.5],i,gen,detect);
        % append delle due probabilità di errore medie
        pe_bit = [pe_bit x];
        pe_cw = [pe_cw x1];
        % append del rate
        Rate = [Rate rate];
    end
    
    % derivazione dei valori di crossover da comparare
    eps = 0:step:0.5;
    eps_sym = [];
    for i=eps
        eps_sym = [eps_sym symbol_channel_pe(i)];
    end
    
    % Plotting
    plot(eps)
    hold
    plot(eps_sym)
    plot(pe_bit)
    plot(pe_cw)
    legend
    xlabel('100*epsilon')
    xlabel('100*epsilon','FontSize',16)
    title('Probabilità di errore del codice CRC con feedback','FontSize',18)
    ylabel('P(e)','FontSize',18)
end

function [pbit, pcw, Rate] = test_CRC(n,pmf,epsilon,gen,detect)
    %% numero di bit errati per ogni stringa
    occ = [];
    % numero usi totali del canale
    usi_totali = 0;
    % numero di simboli errati
    nerr = 0;
    for i=1:n
        % generazione random del messaggio
        msg = randsrc(4,1,[0 1;pmf]);
        % codifica e trasmissione
        [corrente, usi] = CRC(msg,epsilon,gen,detect);
        % append degli errori e degli usi
        occ = [occ corrente];
        usi_totali = usi_totali + usi;
    end
    % media
    pbit = sum(occ)/(4*n);
    for el=occ
        if (el > 0)
            nerr = nerr + 1;
        end
    end
    % media
    pcw = nerr/n;
    % rate medio
    Rate = 4*n/usi_totali;
end

function [n_bit_err, usi_di_canale] = CRC(msg,epsilon,gen,detect)
    %% Caso senza ritrasmissione
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
        % trasmissione + ack
        usi_di_canale = 8;
        % Se il trasmettitore riceve l'ack rimanda il simbolo
        if (ack == 1)
            codeword_long = step(gen,msg);
            out1 = bsc(codeword_long,epsilon);
            [out2,~] = step(detect,out1);
            % doppia trasmissione + ack
            usi_di_canale = 15;
        end
    end
    [n_bit_err, ~] = biterr(msg,out2);
    
end

function pe = symbol_channel_pe(x)
    %% calcolo della probabilità di errore per epsilon = x
    pe = 4*(x*(1-x)^3)+6*(x^2 *(1-x)^2)+4*(x^3*(1-x))+x^4;
end