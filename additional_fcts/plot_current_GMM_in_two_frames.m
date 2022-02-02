function plot_current_GMM_in_two_frames(Data, model, s, nbSamples, init_nbSamples)
figure
xx = round(linspace(1,64,nbSamples));
clrmap = colormap('jet');
clrmap = min(clrmap(xx,:),.95);
clrmap_2 = colormap('parula');
yy = round(linspace(1,256,model.nbStates));
clrmap_2 = clrmap_2(yy,:);
limAxes = [-1.2 0.8 -1.1 0.9];
colPegs = [0.2863 0.0392 0.2392; 0.9137 0.4980 0.0078];
p0.A = eye(2);
p0.b = zeros(2,1);
color = eye(3);
for m=1:model.nbFrames
	subplot(1,model.nbFrames,m); hold on; grid on; box on; title(['Frame ' num2str(m)]);
	for n=1:nbSamples
        if n <= init_nbSamples
            plot(squeeze(Data(2,m,(n-1)*s(1).nbData+1)), ...
                squeeze(Data(3,m,(n-1)*s(1).nbData+1)), '.','markersize',15,'color', 'blue');
            plot(squeeze(Data(2,m,(n-1)*s(1).nbData+1:n*s(1).nbData)), ...
                squeeze(Data(3,m,(n-1)*s(1).nbData+1:n*s(1).nbData)), '-','linewidth',1.5,'color','black');
        else
            plot(squeeze(Data(2,m,(n-1)*s(1).nbData+1)), ...
                squeeze(Data(3,m,(n-1)*s(1).nbData+1)), '.','markersize',15,'color', 'red');
            plot(squeeze(Data(2,m,(n-1)*s(1).nbData+1:n*s(1).nbData)), ...
                squeeze(Data(3,m,(n-1)*s(1).nbData+1:n*s(1).nbData)), '--','linewidth',1.5,'color','black');
        end
	end
% 	plotGMM(squeeze(model.Mu(:,m,:)), squeeze(model.Sigma(:,:,m,:)), color,.8);
    for n=1 : model.nbStates
        plotGMM(model.Mu(2:3,m, n), model.Sigma(2:3,2:3,m,n), clrmap_2(n,:), .6);
    end
% 	plotPegs(p0, colPegs(m,:));
	axis equal; axis([-4.5 4.5 -1 8]); set(gca,'xtick',[0],'ytick',[0]);
end
hold off
end