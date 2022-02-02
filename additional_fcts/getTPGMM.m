function model = getTPGMM(Data, model)
%     model = init_tensorGMM_timeBased(Data, model);
    model = EM_tensorGMM(Data, model);

%Precomputation of covariance inverses
    for m=1:model.nbFrames 
        for i=1:model.nbStates
            model.invSigma(:,:,m,i) = inv(model.Sigma(:,:,m,i));
        end
    end
end