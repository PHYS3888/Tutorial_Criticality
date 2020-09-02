function [binCenters,Nnorm] = binLogLog(numBins,dataVector)
if nargin < 1
    numBins = 25;
end
%-------------------------------------------------------------------------------
% log10-spaced bin edges:
binEdges = logspace(log10(min(dataVector)),log10(max(dataVector)),numBins);

% Bin the data using custom bin edges:
[N,binEdges] = histcounts(dataVector,binEdges);

% Bin centers as middle points between bin edges:
binCenters = mean([binEdges(1:end-1);binEdges(2:end)]);

% Convert counts to probabilities:
Nnorm = N/sum(N);

end
