function [] = A3_create_figures_timeseries( INI )
%---------------------------------------------
% FUNCTION DESCRIPTION:
%
% this function is after load computed_timeseries, it requires the computed
% and observed to be loaded in a map
%
% BUGS:
% COMMENTS:
%----------------------------------------
% REVISION HISTORY:
%
% v2f: 2016-02-29 keb incremented to plot_timeseries_v8 and plot_timeseries_accumulated_v9
% v2e: 2015-12-30 keb iterated to plot_timeseries_v7b
% changes introduced to v1:  (keb 7/7/2011)
%  -calling make_figures_station_v1 (instead of v0) which calls plot_timeseries_v2
%   (instead of v1) and plot_timeseries_accumulated_v1 (instead of v0)
%----------------------------------------
format compact;
fprintf('\n Beginning A3_create_figures_timeseries: %s \n',datestr(now));

FILEDATA = INI.FILESAVE_TS;
fprintf('... Loading Computed and observed data:\n\t %s\n', char(FILEDATA));
load(FILEDATA, '-mat');

% only do the selected stations
STATIONS_LIST = INI.SELECTED_STATIONS.list.stat;

i = 1;
for M = STATIONS_LIST
    %    pause(0.01)
    fprintf('\n...%d processing timeseries plot: %s', i, char(M))
    try
        STATION = MAP_ALL_DATA(char(M));  %get a tmp structure, modify values

        plot_timeseries(STATION,INI); % comment to plot only accumulated
    catch
        fprintf(' --> ...WARNING: A3: exception in plot_timeseries(%s) STATION.NAME not present in MAP_ALL_DATA', char(M))
    end
    try
        if strcmp(STATION.DFSTYPE,'Discharge') | ...
                strcmp(STATION.DFSTYPE,'SZ flow') | ...
                strcmp(STATION.DFSTYPE,'SZ exchange flow with river') | ...
                strcmp(STATION.DFSTYPE,'groundwater flow in x-direction') | ...
                strcmp(STATION.DFSTYPE,'groundwater flow in y-direction') | ...
                strcmp(STATION.DFSTYPE,'groundwater flow in z-direction')
            plot_timeseries_accumulated(STATION,INI);
        end
        %       fprintf('\n')
    catch
        fprintf(' --> ...WARNING: A3: exception in plot_timeseries_accumulated(%s)\n', char(M))
    end
    i = i + 1;

end

end


