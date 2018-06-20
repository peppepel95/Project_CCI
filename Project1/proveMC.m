function [wrongbit, wrongcw] = proveMC(num, pmf_source, crossover)
    wrongbit = [];
    wrongcw = [];
    n = num/4;
    for i=1:n
        er = 0;
        msg = randsrc(1,4,[0 1; pmf_source]);
        out = hamming74Function(msg, crossover);
        error = sum(mod(msg + out,2));
        wrongbit = [wrongbit error];
        if (error > 0)
            er = 1;
        end
        wrongcw = [wrongcw er];
    end
end