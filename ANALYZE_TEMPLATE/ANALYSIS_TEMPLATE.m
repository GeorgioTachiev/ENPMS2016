function  main
% do not modify;
%clear('all'); % this clear the breakpoints when debugging
tic; % initialize time counter to clock script begin to end
[INI.ROOT,NAME,EXT] = fileparts(pwd()); % path string of ROOT Directory/
INI.ROOT = [INI.ROOT '/'];
INI.CURRENT_PATH =[char(pwd()) '/']; % path string of folder MAIN
INI.A1 = 0; INI.A2 = 0; INI.A2a = 0; INI.A3 = 0; INI.A3a = 0; 
INI.A3exp = 0; INI.A4 = 0; INI.A5 = 0; INI.A6 = 0; INI.A7 = 0;INI.A8 = 0;
% end do not modify
%---------------------------------------------
%{
FUNCTION DESCRIPTION:

Master script for initializing postprocessing variables and calling other
postproc, graphing, and statistics calculation scripts.
Originally from Georgio Tachiev and modified by RJF and KEB at NPS.
Credit also goes to the student that helped organize this for GIT - Tushar Gadkari,
Other credits go to Marcelo Lago, Amy Cook, and Jordan Barr.

BUGS:s
COMMENTS:
----------------------------------------
REVISION HISTORY:


%}

%---------------------------------------------------------------------
% SET UP PATH AND LOCATION OF DIRECTORIES AND SCRIPTS
%---------------------------------------------------------------------

%THIS IS NOT NEEDED
INI.ANALYSIS_PATH = INI.CURRENT_PATH;

%LOCATION OF SCRIPTS FOR ANALYSIS - currently this is the 'ENPMS' directory (end with '\'):
%INI.MATLAB_SCRIPTS = 'C:\Users\georgio\Desktop\MATLAB_SCRIPTS_03262016\ENPMS\';
INI.MATLAB_SCRIPTS = 'C:\home\MODELS\MATLAB\ENPMS\';
% INI.MATLAB_SCRIPTS = '\\MAJORLAZER\Users\georgio\Desktop\MATLAB_SCRIPTS_03262016\ENPMS\';

% This is the equivalent of the 'Results' directory (end with '\'):
% INI.ResultDirHome = ['C:\Users\georgio\Desktop\MODEL_RESULTS_FOR_TESTING\'];
% INI.ResultDirHome = ['C:\home\MODELS\MATLAB\MODEL_RESULTS_FOR_TESTING\'];
% INI.ResultDirHome = ['\\MAJORLAZER\Users\georgio\Desktop\MODEL_RESULTS_FOR_TESTING\'];
INI.ResultDirHome = ['C:\home\MODELS\Result\'];

%------------------------------------------------------------------------
% SET OPTIONS USED BY readXLSmonpts
% (note that INI.OVERWRITE_MON_PTS must be true for readXLSmonpts to execute)
% (yes we can move this section elsewhere ;)
%------------------------------------------------------------------------

% These are the parent directories where the input dfs0 timeseries files are
% stored. This is used by readxlsmonpts to create the obs data matlab file
% for postproc
INI.dfs0MSHEdir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\MSHE\TIMESERIES\'];
INI.dfs0MSHEdpthdir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\MSHE\TSDEPTH\'];
INI.dfs0M11dir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\M11\TIMESERIES\'];

% These are used to create txt files that can be imported into the model.
% This is in the last part of the readXLSmonpts script, but should probably
% be moved into its own function.
% Set to 1 to create these files, 0 to not create them
INI.MakeDetTSInputFiles = 0;
INI.printMSHEname = ['./detTSmsheALL.txt'];
INI.printM11name = ['./detTSm11ALL.txt'];


%------------------------------------------------------------------------
% Set the Tag/Name that will be given to the combined output datasets,
% directory structure, and filenames
%------------------------------------------------------------------------
INI.ANALYSIS_TAG = 'TTbridges';

%---------------------------------------------------------------------
% CHOOSE SIMULATIONS TO BE ANALYZED
%---------------------------------------------------------------------
% This should be modified to allow
% results from different directories or computers to be used without
% copying the data, i.e. INI.ResultDirHome can vary

% initialize simulation count
i = 0; % Don't change this

% 1st cell: Results Directory, 2nd cell: simulation run, 3rd cell: legend entry
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'ShortRun2TestWith-2014', 'Short 1'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'ShortRun2TestWith', 'Short 2'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3', 'Base'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3calib', 'Calib'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3cw2mi', '2 mile CW'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3cw5mi', '5 mile CW'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-L31NupperLined', '5 mile Lined'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-S332DhighLined', 'S332D HHC Lined'};
% i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-C111upperLined', 'C111 Upper Lined'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-TwoBridges-L29overflowFC', 'L29FC Overflow Method'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-TwoBridges-L29overflow', 'L29 Overflow Method'};
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3-TwoBridgesFCfix', 'Culvert Method'};

%---------------------------------------------------------------------
% CHOOSE TIME PERIOD THAT PLOTS AND STATISTICS WILL BE GENERATED FOR
%---------------------------------------------------------------------
% BEGIN(I) AND END(F) DATES FOR POSTPROC

% note this makes black pngs for timespan<9 days
% INI.ANALYZE_DATE_I = [1999 1 1 0 0 0];   % use for ShortRun2TestWith
% INI.ANALYZE_DATE_F = [1999 1 31 0 0 0]; % use for ShortRun2TestWith

INI.ANALYZE_DATE_I = [1999 1 1 0 0 0];   % use for V914V3
INI.ANALYZE_DATE_F = [2001 12 31 0 0 0]; % use for V914V3
%INI.ANALYZE_DATE_I = [1999 1 1 0 0 0]; % 
%INI.ANALYZE_DATE_F = [1999 5 1 0 0 0]; % 

%---------------------------------------------------------------------
% CHOOSE WHICH MODULES TO RUN  1=yes, 0=no
%---------------------------------------------------------------------

% INI.A1    = 1; % A1_load_computed_timeseries
% INI.A2    = 1; % A2_generate_timeseries_stat
% INI.A2a   = 1; % A2a_cumulative_flows
% INI.A3    = 1; % A3_create_figures_timeseries
INI.A3a   = 1; % A3a_boxmat
% INI.A3exp = 1; % A3a_boxmatEXP
INI.A4    = 1; % A4_create_figures_exceedance
INI.A5    = 1; % A5_create_summary_stat
% INI.A6    = 1; % A6_GW_MAP_COMPARE
% INI.A7    = 1; % A7_SEEPAGE_MAP

% not implemented yet:
% INI.A8    = 1; % A7_SEEPAGE_EXCEL

%---------------------------------------------------------------------
% OTHER STUFF
%---------------------------------------------------------------------

% Location of observed data timeseries (in matlab dataset form)
U.FILE_OBSERVED = 'DATA_OBS_20150604.MATLAB';

% Location of observed data metadata
U.STATION_DATA = 'monpts_20160401.xlsx';

U.SELECTED_STATION_LIST = 'SelectedStationList-all-V3.txt';
%U.SELECTED_STATION_LIST = 'selected_station_list-testing.txt';

% map of requested seepage, note the scripts are MAPF specfic because they
% accumulate X and Y seepage values in specific way
U.MAPF = 'SEEPAGE_MAP.dfs2';

INI.SAVEFIGS = 1;

%---------------------------------------------------------------------
%---------------------------------------------------------------------
%  END USER DEFINITIONS
%---------------------------------------------------------------------
%---------------------------------------------------------------------

%hidden from the user%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adds all paths within the root repository
%recursively add local libraries and directories
try
   addpath(genpath(INI.MATLAB_SCRIPTS));
catch
   addpath(genpath(INI.MATLAB_SCRIPTS,0));
end

%---------------------------------------------------------------------
%  INITIALILIZE STRUCTURE INI
%---------------------------------------------------------------------
INI = setup_ini(INI,U);

%---------------------------------------------------------------
% Run the modules
%---------------------------------------------------------------
INI = analyze_data_set(INI);

fprintf('\n %s Successful completion of all for %.3g seconds\n',datestr(now), toc);

end
