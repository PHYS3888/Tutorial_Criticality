function E = energyCalc(y,fs,minEventSize)
% energyCalc
%
%---INPUTS:
%   'y' - Recording
%   'fs' - Sampling frequeny
%   'minEventSize' - a minimum event size to consider
%---OUTPUT:
%   'E' - Energy of each crackle
%-------------------------------------------------------------------------------

if nargin < 1
    error('Some audio data, please');
end
if nargin < 2
    error('Sampling rate, please');
end
if nargin < 3
    minEventSize = 0;
end
%-------------------------------------------------------------------------------

% Find all peaks
pks = findpeaks(abs(y),'MinPeakHeight',minEventSize);

% Energy of event is amplitude squared
E = pks.^2./fs;

end
