function plot_velocity_norm(v_norm)
figure
v_norm = reshape(v_norm, [5, 199]);
for i = 1 : 5
    switch i
        case 1
            co = 'k';
        case 2
            co = 'r';
        case 3
            co = 'b';
        case 4
            co = 'm';
        case 5
            co = 'g';
    end
    plot(v_norm(i, :),'-','linewidth',1.5,'color', co);hold on;
    axis off
end
legend('Init', 'Method 1', 'Method 2', 'Method 3', 'Baseline')
set(gca,'FontSize',16)