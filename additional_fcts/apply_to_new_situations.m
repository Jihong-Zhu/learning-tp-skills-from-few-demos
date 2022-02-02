function [list_of_distance, list_of_velocity] = apply_to_new_situations(s, models, nbData, nb_repo)
nb_models = length(models);
list_of_distance = zeros(nb_repo, nb_models);
list_of_velocity = zeros(nb_repo, nb_models, nbData-1);
% Extrapolation
for new_idx = 1 : nb_repo
    for m=1:models(1).nbFrames
        if m == 1
            pTmp(m).b = s(1).p(m).b;
            pTmp(m).A = s(1).p(m).A;
        else
            b_new = 0.8 * rand(2,1);
            b_new = [0; b_new];
            pTmp(m).b = b_new;
            rand_angle = 60 + rand * 120;
            A_new = rotx(rand_angle);
            A_new(2:3, 2:3) = sqrt(0.1) * A_new(2:3, 2:3);
            A_new(2:3, 2) = -A_new(2:3, 2);
            pTmp(m).A = A_new;     
        end
    end
    %pTmp(2).b = pTmp(2).b + 1; %test further extrapolation
    rr.p = pTmp;
    for k = 1:nb_models
        model = models(k);
        DataIn(1,:) = s(1).Data0(1,:); %1:nbData;
        in = 1;
        out = 2:model.nbVar;
        MuGMR = zeros(length(out), nbData, model.nbFrames);
        SigmaGMR = zeros(length(out), length(out), nbData, model.nbFrames);
        for m=1:model.nbFrames 
            %Compute activation weights
            for i=1:model.nbStates
                H(i,:) = model.Priors(i) * gaussPDF(DataIn, model.Mu(in,m,i), model.Sigma(in,in,m,i));
            end
            H = H ./ (repmat(sum(H),model.nbStates,1)+realmin);

            for t=1:nbData
                %Compute conditional means
                for i=1:model.nbStates
                    MuTmp(:,i) = model.Mu(out,m,i) + model.Sigma(out,in,m,i) / model.Sigma(in,in,m,i) * (DataIn(:,t) - model.Mu(in,m,i));
                    MuGMR(:,t,m) = MuGMR(:,t,m) + H(i,t) * MuTmp(:,i);
                end
                %Compute conditional covariances
                for i=1:model.nbStates
                    SigmaTmp = model.Sigma(out,out,m,i) - model.Sigma(out,in,m,i) / model.Sigma(in,in,m,i) * model.Sigma(in,out,m,i);
                    SigmaGMR(:,:,t,m) = SigmaGMR(:,:,t,m) + H(i,t) * (SigmaTmp + MuTmp(:,i)*MuTmp(:,i)');
                end
                SigmaGMR(:,:,t,m) = SigmaGMR(:,:,t,m) - MuGMR(:,t,m) * MuGMR(:,t,m)' + eye(length(out)) * model.params_diagRegFact; 
            end
        end
        MuTmp = zeros(length(out), nbData, model.nbFrames);
        SigmaTmp = zeros(length(out), length(out), nbData, model.nbFrames);
        %Linear transformation of the retrieved Gaussians
        for m=1:model.nbFrames
            MuTmp(:,:,m) = pTmp(m).A(2:end,2:end) * MuGMR(:,:,m) + repmat(pTmp(m).b(2:end),1,nbData);
            for t=1:nbData
                SigmaTmp(:,:,t,m) = pTmp(m).A(2:end,2:end) * SigmaGMR(:,:,t,m) * pTmp(m).A(2:end,2:end)';
            end
        end

        %Product of Gaussians (fusion of information from the different coordinate systems)
        for t=1:nbData
            SigmaP = zeros(length(out));
            MuP = zeros(length(out), 1);
            for m=1:model.nbFrames
                SigmaP = SigmaP + inv(SigmaTmp(:,:,t,m));
                MuP = MuP + SigmaTmp(:,:,t,m) \ MuTmp(:,t,m);
            end
            rr.Sigma(:,:,t) = inv(SigmaP);
            rr.Data(:,t) = rr.Sigma(:,:,t) * MuP;
        end
%         plot_repo(rr, model, 1, 'new situation', m, k)
        plot_repo_2(rr, model, 1,  m, k)
        % total distance
        [~, v_norm] = motion_velocity(rr);
        dist = motion_distance(rr);
        list_of_distance(new_idx, k) = dist;
        list_of_velocity(new_idx, k, :) = v_norm;
        % derivarive
    end
end
end