function plot_noisy_data(SNR_level)
addpath('./m_fcts/');
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model.nbStates = 6; %Number of Gaussians in the GMM
model.nbFrames = 2; %Number of candidate frames of reference
model.nbVar = 3; %Dimension of the datapoints in the dataset (here: t,x1,x2)
model.params_diagRegFact = 1E-4; %Optional regularization term
nbData = 200; %Number of datapoints in a trajectory


%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Load 3rd order tensor data...');
% s(n).Data0 is the n-th demonstration of a trajectory of s(n).nbData datapoints, with s(n).p(m).b and 's(n).p(m).A describing
% the context in which this demonstration takes place (position and orientation of the m-th candidate coordinate system)
load('Data02.mat');
% Observations from the perspective of each candidate coordinate system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data' contains the observations in the different coordinate systems: it is a 3rd order tensor of dimension D x P x N, 
% with D=3 the dimension of a datapoint, P=2 the number of candidate frames, and N=TM the number of datapoints in a 
% trajectory (T=200) multiplied by the number of demonstrations (M=5)
Data = zeros(model.nbVar, model.nbFrames, nbSamples*nbData);
for n=1:nbSamples
	s(n).Data0(1,:) = s(n).Data0(1,:) * 1E-1;
end
Data = get_the_data_for_training(s, model, nbSamples, nbData);
%% Add noise
for n = 1 : nbSamples
    noise_data(n).p = s(n).p;
    movement = s(n).Data(2:3, :);
    % inject noise;
    movement = awgn(movement', SNR_level, 'measured')';
    noise_data(n).Data = s(n).Data;
    noise_data(n).Data(2:3, :) = movement;
end
%% Plot
figure
hold on; box on; 
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
    plot(noise_data(n).Data(2,1), noise_data(n).Data(3,1),'.','markersize',15,'color','blue');
    plot(noise_data(n).Data(2,:), noise_data(n).Data(3,:),'-','linewidth',1.5,'color','blue');
    plot(s(n).Data(2,:), s(n).Data(3,:),'-','linewidth',1.5,'color','red');
end
axis(limAxes); axis square; set(gca,'xtick',[],'ytick',[]);
end
    
    
    