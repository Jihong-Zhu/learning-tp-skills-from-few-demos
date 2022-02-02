function plot_demo(s, model, init_nbSamples, nbSamples)
    figure
%     title('Expert demonstrations and generated demonstrations');
    hold on; box off;axis off;
%     title('Reproductions with GMR');
%     xx = round(linspace(1,64,nbSamples));
%     clrmap = colormap('jet');
%     clrmap = min(clrmap(xx,:),.95);
    limAxes = [-1.2 0.8 -1.1 0.9];
    colPegs = [0.2863 0.0392 0.2392; 0.9137 0.4980 0.0078];
    for n=1:nbSamples % number of demonstrations
        %Plot frames
        for m=1:model.nbFrames
            plotPegs(s(n).p(m), colPegs(m,:));
        end
        %Plot trajectories
        if n <= init_nbSamples
            plot(s(n).Data(2,1), s(n).Data(3,1),'.','markersize',15,'color','blue');
            plot(s(n).Data(2,:), s(n).Data(3,:),'-','linewidth',1.5,'color','blue');
        else
            plot(s(n).Data(2,1), s(n).Data(3,1),'.','markersize',15,'color','red');
            plot(s(n).Data(2,:), s(n).Data(3,:),'-','linewidth',1.5,'color','red');
        end
    end
    axis(limAxes); axis square; set(gca,'xtick',[],'ytick',[]);
    figure
%     title('Expert demonstrations');
    hold on; box off;axis off;
    for n=1:init_nbSamples % number of demonstrations
        %Plot frames
        for m=1:model.nbFrames
            plotPegs(s(n).p(m), colPegs(m,:));
        end
        %Plot trajectories
        plot(s(n).Data(2,1), s(n).Data(3,1),'.','markersize',15,'color','blue');
        plot(s(n).Data(2,:), s(n).Data(3,:),'-','linewidth',1.5,'color','blue');
    end
    axis(limAxes); axis square; set(gca,'xtick',[],'ytick',[]);
end