function s = fireArea(data)

% Find connected clusters nearest neighbours in succesive timesteps
CC = bwconncomp(data==2,18);

% Find number of trees within a connected cluster
SS = regionprops(CC,'Area');
s = cat(1,SS.Area);

end
