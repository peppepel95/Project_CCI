function [correct_cw, j] = bit_flipping(cw, H, K)
    [~, n] = size(H);
    w = zeros(1,n);
    %% peso per matrici irregolari
    for i=1:n
        w(i) = sum(H(1:end,i));
    end
    j = 0;
    %% K numero di iterazioni
    while(j < K)
        %% calcolo del check-sum
        check_sum = mod(H*cw,2);
        if (sum(check_sum) > 0)
            %% flipping dei bit
            choice = check_sum'*H;
            %% find_max
            [pos, ~] = find_max(choice,w,n);
            cw(pos) = mod(cw(pos)+1,2);
            j = j+1;
        else
            break;
        end
    end
    correct_cw = cw;
end
% 
% H = [1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
%     1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0;
%     0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0;
%     0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0;
%     0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0;
%     0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1;
%     1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0;
%     0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0;
%     0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0;
%     0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0 0;
%     0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1];

% H = [1 0 0 1 1 1 0 0; 1 0 1 0 1 1 0 0; 1 0 1 1 0 1 0 0; 0 1 0 1 0 0 1 1; 0 1 0 0 1 0 1 1; 0 1 1 0 0 0 1 1]
