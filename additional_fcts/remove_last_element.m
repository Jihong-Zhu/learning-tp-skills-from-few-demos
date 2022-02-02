function [s, nbSamples] = remove_last_element(s, nbSamples)
l = length(s);
s(l) = [];
nbSamples = nbSamples - 1;
end