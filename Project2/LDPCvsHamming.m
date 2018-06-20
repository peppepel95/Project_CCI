function pe = LDPCvsHamming(H, num_iteration, epsilon, K)
    i = 0;
    sum_pe = 0;
    sum_pe_hamming = 0;
    Hrr = mod((abs(rref(H))),2);
    [righe, colonne] = size(Hrr);
    Parity = Hrr(1:end,righe+1:end);
    Hstd = [Parity eye(righe)];
    G = [eye(colonne-righe), Parity'];
    [m, n] = size(H);
    k = n - m;
    H = Hstd; % per Hamming
    
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
         %% Decodifica
        output = Decodifica_Hamming(CW_err, H, k, n);
        [~, pe_hamming] = biterr(str_bin, output);
        if (pe_hamming > 0)
            sum_pe_hamming = sum_pe_hamming + pe_hamming;
        end
        
        %% count ++
        i = i + 1;
    end
    pe_ldpc = sum_pe/num_iteration;
    pe_hamming = sum_pe_hamming/num_iteration;
    pe = [pe_ldpc pe_hamming];
end