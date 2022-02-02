function plot_repo(r, model, nbSamples, figure_title, m, color)
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
            xx = round(linspace(1,64, nbSamples));
        case 2
            xx = round(linspace(192,256, nbSamples));
        case 3
            xx = round(linspace(129,192, nbSamples));
        case 4
            xx = round(linspace(65,128, nbSamples));    
    end
    clrmap = colormap('jet');
    clrmap = min(clrmap(xx,:),.95);
    limAxes = [-1.2 0.8 -1.1 0.9];
    colPegs = [0.2863 0.0392 0.2392; 0.9137 0.4980 0.0078];
    for n=1:nbSamples
        %Plot frames
        for m=1:model.nbFrames
            plotPegs(r(n).p(m), colPegs(m,:));
        end
    end
    for n=1:nbSamples
%         Plot Gaussians
        plotGMM(r(n).Data(:,1:5:end), r(n).Sigma(:,:,1:5:end), [0 0 1], .05);
    end
    for n=1:nbSamples
        %Plot trajectories
        plot(r(n).Data(1,1), r(n).Data(2,1),'.','markersize',12,'color','black');
        plot(r(n).Data(1,:), r(n).Data(2,:),'-','linewidth',1.5,'color','black');
        plot(r(n).Data(1,1), r(n).Data(2,1),'.','markersize',12,'color','r');
        plot(r(n).Data(1,:), r(n).Data(2,:),'-','linewidth',1.5,'color','r');
    end
    axis(limAxes); axis square; set(gca,'xtick',[],'ytick',[]);
    title(figure_title)
end