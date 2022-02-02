function [s, nbSamples] = dataset_aggre(s, new_data, nbSamples)
    s_new.p = new_data.p;
    Data = [s(1).Data(1, :); new_data.Data];
    Data0 = [s(1).Data0(1, :); new_data.Data];
    s_new.nbData = s(1).nbData;
    s_new.Data = Data;
    s_new.Data0 = Data0;
    l = length(s);
    s(l + 1) = s_new;
    nbSamples = nbSamples + 1;
end