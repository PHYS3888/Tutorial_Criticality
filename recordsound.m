function [y,fs] = recordsound(timeRec,fs)
% recordsound
%-------------------------------------------------------------------------------
%---INPUTS:
%   'timeRec' - Recording duration (s)
%   'fs' - Sampling rate (Hz)
%---OUTPUTS:
%   'y' - The audio recording as a time series
%-------------------------------------------------------------------------------

% Set default sampling rate:
if nargin < 2
    fs = 8000;
end
numBits = 16;
numChannels = 1; % mono

% Make recording:
disp('Start speaking.')
recObj = audiorecorder(fs,numBits,numChannels);
recordblocking(recObj,timeRec);
disp('End of Recording.');

% Load recording as a variable:
y = getaudiodata(recObj);

end
