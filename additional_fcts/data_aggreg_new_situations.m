function [init_cost, final_cost, model] = data_aggreg_new_situations(model, demo_data, max_nbSamples, max_iterations)
addpath('./m_fcts/');
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model.nbStates = 6; %Number of Gaussians in the GMM
% model.nbFrames = 2; %Number of candidate frames of reference
% model.nbVar = 3; %Dimension of the datapoints in the dataset (here: t,x1,x2)
% model.params_diagRegFact = 1E-4; %Optional regularization term
nbData = 200; %Number of datapoints in a trajectory
%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Load 3rd order tensor data...');
% s(n).Data0 is the n-th demonstration of a trajectory of s(n).nbData datapoints, with s(n).p(m).b and 's(n).p(m).A describing
% the context in which this demonstration takes place (position and orientation of the m-th candidate coordinate system)
load(demo_data);
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

%% TP-GMM learning with augmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Parameters estimation of TP-GMM with EM:');
model = init_tensorGMM_timeBased(Data, model); 
model = getTPGMM(Data, model);
model_init = model;
init_nbSamples = nbSamples;
% compute the cost 
[cost, ~] = GMRrepo(s, model_init, nbData, init_nbSamples);
init_cost = cost;
% plot_repo(r, model_init, init_nbSamples, 'Reproduction by original TP-GMM')
% plot_current_GMM_in_two_frames(Data, model, s, nbSamples, init_nbSamples);
% generate new situations
iteration = 1;
% list_of_cost = cost;
while nbSamples < max_nbSamples && iteration < max_iterations
    % select a random sample:
    new_data = generate_random_situation_2(s, model, nbData, 1);
%     idx = ceil(rand * init_nbSamples);
%     new_data.p = s(idx).p;
    % generate noise
%     movement = s(idx).Data(2:3, :);
%     movement = awgn(movement', SNR_level, 'measured')';
%     new_data.Data = movement;
%     gain = 0.0;
%     noise = randn(2, 200) * gain;
%     new_data.Data = s(idx).Data(2:3, :) + noise;
    %     plot_repo(new_data, model, 1)
    % Augment the dataset
    [s, nbSamples] = dataset_aggre(s, new_data, nbSamples);
    % Retrain TPGMM
    Data = get_the_data_for_training(s, model, nbSamples, nbData);
    %model = init_tensorGMM_kmeans(Data, model); 
    model_next = getTPGMM(Data, model);
    % Compute the cost again
    [cost_next, ~] = GMRrepo(s, model_next, nbData, init_nbSamples);
    %     plot_repo(r, model, nbSamples)
    if prod(cost_next < cost)
        fprintf('cost reduction: %d \n', cost_next - cost);
        fprintf('new demonstration data added. \n');
        model = model_next; % new TPGMM model
        cost = cost_next;
%         list_of_cost = [list_of_cost, cost];
%         plot_current_GMM_in_two_frames(Data, model, s, nbSamples, init_nbSamples);
    else
        [s, nbSamples] = remove_last_element(s, nbSamples); % remove the last data
    end
    iteration = iteration + 1;
end
final_cost = cost;
end