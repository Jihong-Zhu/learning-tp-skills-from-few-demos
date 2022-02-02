function [cost, r] = GMRrepo(s, model, nbData, nbSamples)
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
    
    
    for n=1:nbSamples
        MuTmp = zeros(length(out), nbData, model.nbFrames);
        SigmaTmp = zeros(length(out), length(out), nbData, model.nbFrames);
        pTmp = s(n).p;
        r(n).p = pTmp;

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
            r(n).Sigma(:,:,t) = inv(SigmaP);
            r(n).Data(:,t) = r(n).Sigma(:,:,t) * MuP;
        end
        
%         for t=1:nbData
%             SigmaP = zeros(length(out));
%             MuP = zeros(length(out), 1);
%             % Compute the distance
%             total_weight = 0;
%             weight = ones(1, 2);
%             for m=1:model.nbFrames
%                 total_weight = 1 / norm(MuGMR(:,t,m)) + total_weight;
%             end
%             for m=1:model.nbFrames
%                 weight(m) = (1 / norm(MuGMR(:,t,m))) / total_weight;
%             end
%             for m=1:model.nbFrames
%                 SigmaP = SigmaP + inv(SigmaTmp(:,:,t,m)) * weight(m);
%                 MuP = MuP + SigmaTmp(:,:,t,m) \ MuTmp(:,t,m) * weight(m);
%             end
%             r(n).Sigma(:,:,t) = inv(SigmaP);
%             r(n).Data(:,t) = r(n).Sigma(:,:,t) * MuP;
%         end
    end
    % compute distance from 2-norm:
    cost = 0;
    for n=1:nbSamples
        demo = s(n).Data(2:3,:)';
        repo = r(n).Data(1:2,:)';
        cost = sqrt(sum(vecnorm(repo - demo, 2, 2).^2)) + cost;
    end
    cost = cost / nbSamples;
    % another cost definition: (Not able to add any data)
%     cost = [];
%     for n=1:nbSamples
%         demo = s(n).Data(2:3,:)';
%         repo = r(n).Data(1:2,:)';
%         temp = sqrt(sum(vecnorm(repo - demo, 2, 2).^2));
%         cost = [temp, cost];
%     end
    
end