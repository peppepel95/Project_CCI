function [pos, match] = find_max(choice,w,n)
    bit_to_flip = [];
    temp = [];
    match = 0;
    massimo = max(choice);
    peso_massimo = 0;
    for i=1:n
        if choice(i) == massimo
            if (choice(i)/w(i) > peso_massimo)
                  peso_massimo = choice(i)/w(i);
            end
            bit_to_flip = [bit_to_flip i];
        end
    end
    
    m = length(bit_to_flip);
    
    for i=1:m
        if choice(bit_to_flip(i))/w(bit_to_flip(i)) == peso_massimo
            temp = [temp bit_to_flip(i)];
        end
    end
    
    l = length(temp);
    if (l >= 2)
        temp
        match = 1;
    end
    index = randi(l);
    pos = temp(index);
end