function [pe_bit, pe_cw, eps, eps_sym] = changeCrossoverH74(num)
    %% Aumento crossover
    step = 1/num;
    % Probabilità di errore di bit media
    pe_bit = [];
    %probabilità di errore di simbolo media
    pe_cw = [];
    
    % per epsilon che va da 0 a 0.5
    for i=0:step:0.5
        % calcolo P(e)
        [~, ~, x, x1] = calculatePE(1000, [0.5 0.5], i);
        % append delle due probabilità di errore medie
        pe_bit = [pe_bit x];
        pe_cw = [pe_cw x1];
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
    title('Probabilità di errore del codice Hamming(7,4)','FontSize',18)
    ylabel('P(e)','FontSize',18)
end

function [peb, pecw, x, x1] = calculatePE(num, pmf_source, crossover)
    %% Probabilità di errore di bit per la stringa
    peb = [];
    % Probabilità di errore di simbolo per la stringa
    pecw = [];
    
    for i=1:num
        [wrongbit, wrongcw] = proveMC(num, pmf_source, crossover);
        peb_curr = sum(wrongbit)/num;
        pecw_curr = sum(wrongcw)*4/num;
        peb = [peb peb_curr];
        pecw = [pecw pecw_curr];
    end
    x = sum(peb)/num;
    x1 = sum(pecw)/num;
end

function [wrongbit, wrongcw] = proveMC(num, pmf_source, crossover)
    %% numero di bit errati
    wrongbit = [];
    % numero di simboli errati
    wrongcw = [];
    % numero di simboli
    n = num/4;
    for i=1:n
        % simbolo errato
        er = 0;
        % genero simbolo
        msg = randsrc(1,4,[0 1; pmf_source]);
        % codifico e trasmetto
        out = hamming74Function(msg, crossover);
        % calcolo l'errore tra il messaggio e l'uscita del decodificatore
        error = sum(mod(msg + out,2));
        % append dei bit errati
        wrongbit = [wrongbit error];
        
        if (error > 0)
            % simbolo errato
            er = 1;
        end
        % append dei simboli errati
        wrongcw = [wrongcw er];
    end
end

function pe = symbol_channel_pe(x)
    %% calcolo della probabilità di errore per epsilon = x
    pe = 4*(x*(1-x)^3)+6*(x^2 *(1-x)^2)+4*(x^3*(1-x))+x^4;
end


function output = hamming74Function(p, crossover)
    %% Costruzione matrici G e H
    n = 7;
    k = 4;
    Parity = [1 0 1; 1 1 0; 1 1 1; 0 1 1];
    G = [eye(4) Parity];
    H = [Parity' eye(3)];

    %% Codifica
    cw = mod(p*G, 2);

    %% Canale BSC
    cw_bsc_out = bsc(cw, crossover);

    %% Decodifica
    result = mod(cw_bsc_out*H', 2);
    if (sum(result) == 0)
         %Parola Codice
         output = cw_bsc_out(1:k);
    else
        %Non è una Parola Codice
        i = 0;
        passo = n-k;
        while (sum(H(1+i*passo:i*passo+passo) ~= result) > 0)
            i = i + 1;
        end
        i = i + 1;
        cw_bsc_out(i) = mod(cw_bsc_out(i)+1, 2);
        output = cw_bsc_out(1:k);
    end
end
