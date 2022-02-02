function plot_repo_2(r, model, nbSamples, m, color)
    if nargin < 5
        figure;
        color = 1;
    else
        figure(m);
    end
%     title(figure_title);
    hold on; box off;
    switch color
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
    limAxes = [-1.2 1 -1.1 1];
    colPegs = [0.2863 0.0392 0.2392; 0.9137 0.4980 0.0078];
    for n=1:nbSamples
        %Plot frames
        for m=1:model.nbFrames
            plotPegs(r(n).p(m), colPegs(m,:));
        end
    end
    for n=1:nbSamples
        %Plot trajectories
%         plot(r(n).Data(1,1), r(n).Data(2,1),'.','markersize',12,'color','black');
%         plot(r(n).Data(1,:), r(n).Data(2,:),'-','linewidth',1.5,'color','black');
        plot(r(n).Data(1,1), r(n).Data(2,1),'.','markersize',12,'color', co);
        plot(r(n).Data(1,:), r(n).Data(2,:),'-','linewidth',1.5,'color', co);
    end
    axis(limAxes); axis square; set(gca,'xtick',[],'ytick',[]);
end