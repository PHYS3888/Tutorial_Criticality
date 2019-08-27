function E = energyCalc(y,fs)
% energyCalc
%
%---INPUTS:
%   'y' - Recording
%   'fs' - Sampling frequeny
%
%---OUTPUT:
%   'E' - Energy of each crackle
%-------------------------------------------------------------------------------

if nargin < 1
    error('Some audio data, please');
end
if nargin < 2
    error('Sampling rate, please');
end


% Find all peaks
pks = findpeaks(abs(y));

% Energy of event is amplitude squared
E = round(pks,8).^2./fs;

end
