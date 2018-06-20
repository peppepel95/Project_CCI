function output = Decodifica_Hamming(CW_err, H, k, n)
        result = mod(CW_err*H', 2);
        if (sum(result) == 0)
             %Parola Codice
             %disp('è stato trasmesso :');
             output = CW_err(1:k);
        else
            %Non è una Parola Codice
            %disp('Cerco di correggere degli Errore');
            j = 0;
            passo = n-k;
            while (sum(H(1+j*passo:j*passo+passo) ~= result) > 0)
                j = j + 1;
            end
            j = j + 1;
            CW_err(j) = mod(CW_err(j)+1, 2);
            %disp('è stato trasmesso :');
            output = CW_err(1:k);
        end
end