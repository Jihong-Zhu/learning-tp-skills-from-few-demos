function Data = get_the_data_for_training(s, model, nbSamples, nbData)
    Data = zeros(model.nbVar, model.nbFrames, nbSamples*nbData);
    for n=1:nbSamples
        for m=1:model.nbFrames
            Data(:,m,(n-1)*nbData+1:n*nbData) = s(n).p(m).A \ (s(n).Data0 - repmat(s(n).p(m).b, 1, nbData));
        end
    end
end