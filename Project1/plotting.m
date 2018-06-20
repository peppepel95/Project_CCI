function plotting(peb, pecw, num, crossover)
    y=0:1:num;
    x = sum(peb)/num;
    plot(peb)
    hold
    grid
    plot(y, x*ones(size(y)), 'LineWidth', 2)
    plot(y, crossover*ones(size(y)), 'LineWidth', 2)
    plot(crossover*2)
    plot(0)
    figure
    x1 = sum(pecw)/num;
    plot(pecw)
    hold
    grid
    plot(y, x1*ones(size(y)), 'LineWidth', 2)
    plot(y, crossover*4*ones(size(y)), 'LineWidth', 2)
    plot(crossover*8)
    plot(0)
end
