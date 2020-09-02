function data = ForestFireModel(T,PG,PL,plotFF,analyzeFF,watchMore)
% FOREST-FIRE MODEL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUTS:
% The main adjustable parameters are
%   1) 'T' - Number of generations simulation is ran for
%   2) 'PG' - Scales the probability that a forest will grow in a cell
%       that is unoccupied.
%   3) 'PL' - Scales the probability that a forest with no burning
%       neighbors will ignite ('Lightning' rule; Drossel and Schwabl 1992)
%   4) 'plotFF' - Flag to plot FFM
%   5) 'analyzeFF' - Flag to save each timestep for an output vector data
%   6) 'watchMore' - Flag to watch ratio of densities evolve through time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS:
% Output is the 3D array 'data' which shows the matrix for each time
% step so code can be debugged, statistics can be calculated.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------------
% Set defaults:
%-------------------------------------------------------------------------------
if nargin < 1
    T = 100;
end
if nargin < 2
    PG = 1;
end
if nargin < 3
    PL = 1;
end
if nargin < 4
    plotFF = true;
end
if nargin < 5
    analyzeFF = false;
end
if nargin < 6
    watchMore = false;
end
%-------------------------------------------------------------------------------

close('all')

%% Plot and analyse

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to adjust
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Size of grid
Dimensions = 300; %Bak et al. 1990 used 256

% Probability a tree will grow from bare ground
probGrow = 1/200;
probGrow = probGrow*PG;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETER SET BY INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Probabiliy that a lightning strike will ignite a tree
probLight = probGrow/170;
probLight = probLight*PL;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output
%%%%%%%%%%%%%%%%%%%%%%%%%%
if analyzeFF
    data = zeros(Dimensions,Dimensions,T);
else
    data = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here we need to implement a random grid comprising 3 states:
% 0, 1 & 2
x = floor(3.*rand(Dimensions,Dimensions));

% Meaning:
% 0 = empty ground
% 1 = trees
% 2 = fire

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotFF
    f = figure('color','w');
    h = imagesc(x);
    colormap([1,1,1;0,1,0;1,0,0])
    cB = colorbar;
    cB.Limits = [0 2];
    cB.Ticks = [1/3,1,5/3];
    cB.TickLabels = {'empty','trees','fire'};
    caxis([0 2])
    axis('square')
end
for t = 1:T

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rule 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialize an empty grid
    xi = x;
    x = zeros(Dimensions,Dimensions);
    % Here we want to set all burning trees to zero while saving all trees
    x(xi==1) = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rule 3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % We want empty ground to grow trees with probability p
    p = rand(Dimensions,Dimensions);
    x(xi==0 & p<probGrow) = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rule 4
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fire spreads to it's neighbouring trees in the next time step

    % First find all active trees
    [ii,jj] = find(xi==2);

    %Loop through each tree
    for m=1:numel(ii)

        if ~ismember([ii(m); jj(m)],[1 Dimensions])

            %Here we want to set each of a burning trees neighbours alight
            if xi(ii(m)-1,jj(m))==1
                x(ii(m)-1,jj(m))=2;
            end
            if xi(ii(m),jj(m)+1)==1
                x(ii(m),jj(m)+1)=2;
            end
            if xi(ii(m),jj(m)-1)==1
                x(ii(m),jj(m)-1)=2;
            end
            if xi(ii(m)+1,jj(m))==1
                x(ii(m)+1,jj(m))=2;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rule 5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RULE 5 a tree becomes a burning tree with probability f if
    % no neighbour is burning
    f = rand(Dimensions,Dimensions);
    x(xi==1 & f<probLight) = 2;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Statistics calculated for later
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate how much land is occupied by fires, bare ground and forest
    Fires = sum(sum(x==2));
    Bare = sum(sum(x==0));
    Forest = sum(sum(x==1));

    FRatio = 100*Fires/(Dimensions*Dimensions);
    BRatio = 100*Bare/(Dimensions*Dimensions);
    ForRatio = 100*Forest/(Dimensions*Dimensions);

    %%%%%%%%%%%%%%%%%%%%%
    % Save the computation domain
    if analyzeFF
        data(:,:,t)=x;
    end
    %%%%%%%%%%%%%%%%%%%%%

    % If plotting:
    if plotFF && ~mod(t,5)
        %PLOTS
        %Simulation
        if watchMore
            ax = subplot(3,1,1:2);
        end
        h.CData = x;
        title(sprintf('t = %u, probGrow= %.2f, probLight= %.2f',t,PG,PL))
        drawnow('limitrate')
        % Percentage of land occupied by each state
        if watchMore
            subplot(3,1,3)
            scatter(t,FRatio,'r*')
            hold on
            scatter(t,ForRatio,'g*')
            scatter(t,BRatio,'k*')
            axis([0 T 0 100])
            legend('Fire','Forest','Bare Ground')
            xlabel('Time (generations)')
            ylabel('% of Area')
        end
    end

    % Exit loop if fires are extinguished
    if probLight==0 && Fires==0
        Error('There are no more Fires!!!')
    end
end

end
