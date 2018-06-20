%% Costruzione matrici G e H
n = 7;
k = 4;
Parity = [1 0 1; 1 1 0; 1 1 1; 0 1 1];
G = [eye(4) Parity]
H = [Parity' eye(3)]

%% Informazione da trasmettere
p = [1 0 1 1]

%% Codifica
cw = mod(p*G, 2)

%% Canale BSC
cw_bsc_out = bsc(cw, 0.1)

%% Decodifica
result = mod(cw_bsc_out*H', 2)
if (sum(result) == 0)
     disp('Parola Codice!');
     disp('è stato trasmesso :');
     cw_bsc_out(1:k)
else
    disp('Non è una Parola Codice!');
    disp('Cerco di correggere 1 Errore');
    i = 0;
    passo = n-k;
    while (sum(H(1+i*passo:i*passo+passo) ~= result) > 0)
        i = i + 1;
    end
    i
    cw_bsc_out(i) = mod(cw_bsc_out(i)+1, 2)
    disp('è stato trasmesso :');
    cw_bsc_out(1:k)
end
    
    
    
    
    
    
    
    
    
    
    
    