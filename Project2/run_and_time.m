Parity = [1 0 1; 1 1 0; 1 1 1; 0 1 1];
G = [eye(4) Parity];
H = [Parity' eye(3)];
[pe_vector, pe_vector1] = test_LDPC(H, 10000, 10);