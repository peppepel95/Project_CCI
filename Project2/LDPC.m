
function pe = LDPC(H, num_iteration, epsilon, K)
    i = 0;
    sum_pe = 0;
    Hrr = mod((abs(rref(H))),2);
    [righe, colonne] = size(Hrr);
    Parity = Hrr(1:end,righe+1:end);
    Hstd = [Parity eye(righe)];
    G = [eye(colonne-righe), Parity'];
    [m, n] = size(H);
    k = n - m;
    
    while (i < num_iteration)
        str_bin = randsrc(1, k, [0 1; 0.5 0.5]);

        CW = mod((str_bin*G),2);

        CW_err = bsc(CW, epsilon);
        
        %% decodifica LDPC
        [correct_cw, ~] = bit_flipping(CW_err', Hstd, K);
        [~, pe] = biterr(str_bin, correct_cw(1:k)');
        if (pe > 0)
            sum_pe = sum_pe + pe;
        end
        %% count ++
        i = i + 1;
    end
    pe_ldpc = sum_pe/num_iteration;
    pe = pe_ldpc;
end
