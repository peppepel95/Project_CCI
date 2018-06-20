function [bit cw eps eps_bin] = changeChannelCrossover(num)
    step = 1/num;
    bit = [];
    cw = [];
    for i=0:step:0.5
        [peb, pecw, x, x1] = calculatePE(1000, [0.5 0.5], i);
        bit = [bit x];
        cw = [cw x1];
    end
    eps = 0:step:0.5;
    eps_bin = [];
    for i=eps
        eps_bin = [eps_bin binomiale(i)];
    end
end

%xlabel('100*epsilon','FontSize',16)
%title('Probabilità di errore del codice Hamming(7,4)','FontSize',18)
%ylabel('P(e)','FontSize',18)