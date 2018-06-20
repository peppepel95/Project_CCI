function [pbit pcw Rate] = test_CRC(n,pmf,epsilon,gen,detect)
    occ = [];
    usi_totali = 0;
    nerr = 0;
    for i=1:n
        msg = randsrc(4,1,[0 1;pmf]);
        [corrente usi] = CRC(msg,epsilon,gen,detect);
        occ = [occ corrente];
        usi_totali = usi_totali + usi;
    end
    pbit = sum(occ)/(4*n);
    for el=occ
        if (el > 0)
            nerr = nerr + 1;
        end
    end
    pcw = nerr/n;
    Rate = 4*n/usi_totali;
end