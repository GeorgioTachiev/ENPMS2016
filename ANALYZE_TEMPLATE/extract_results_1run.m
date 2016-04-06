function  main
% do not modify;
%clear('all'); % this clear the breakpoints when debugging
[INI.ROOT,NAME,EXT] = fileparts(pwd()); % path string of ROOT Directory/
INI.ROOT = [INI.ROOT '/'];
INI.CURRENT_PATH =[char(pwd()) '/']; % path string of folder MAIN
INI.A1 = 0; INI.A2 = 0; INI.A2a = 0; INI.A3 = 0; INI.A3a = 0; 
INI.A3exp = 0; INI.A4 = 0; INI.A5 = 0; INI.A6 = 0; INI.A7 = 0;INI.A8 = 0;
% end do not modify
%---------------------------------------------
%{
FUNCTION DESCRIPTION:

Utility to extract output from model output files and save in model directories in matlab form

Originally from Georgio Tachiev and modified by RJF and KEB at NPS.
Credit also goes to the student that helped organize this for GIT - Tushar Gadkari,
Other credits go to Marcelo Lago, Amy Cook, and Jordan Barr.

%}

%---------------------------------------------------------------------
% SET UP PATH AND LOCATION OF DIRECTORIES AND SCRIPTS
%---------------------------------------------------------------------
i = 0; % Don't change this

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

%---------------------------------------------------------------------
% CHOOSE SIMULATIONS TO BE ANALYZED (will extract all dates)
%---------------------------------------------------------------------
i = i + 1;  INI.MODEL_SIMULATION_SET{i} = {INI.ResultDirHome, 'V914V3', ''};

%---------------------------------------------------------------------
% SELECT DATATYPES YOU WANT TO EXTRACT DATA FOR
%---------------------------------------------------------------------
LOAD_MOLUZ    = 1;  % Detailed Timeseries stored on UZ/OC timesteps (loads all items)
LOAD_M11      = 1;  % Detailed Timeseries (loads all items)
LOAD_MSHE     = 1;  % Detailed Timeseries (loads all items)
LOAD_OL       = 1;  % Overland dfs2 file (loads cells defined in xls spreadsheet)
LOAD_3DSZQ    = 1;  % Saturated zone dfs3 flow file (loads cells defined in xls spreadsheet)


%---------------------------------------------------------------
% IGNORE FROM HERE TO END
%---------------------------------------------------------------
INI.dfs0MSHEdir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\MSHE\TIMESERIES\'];
INI.dfs0MSHEdpthdir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\MSHE\TSDEPTH\'];
INI.dfs0M11dir = ['C:\home\MODELS\DHIMODEL\INPUTFILES\M11\TIMESERIES\'];
INI.MakeDetTSInputFiles = 0;
INI.printMSHEname = ['./detTSmsheALL.txt'];
INI.printM11name = ['./detTSm11ALL.txt'];
INI.ANALYSIS_TAG = 'NotApplicable';
INI.ANALYZE_DATE_I = [1900 1 1 0 0 0];  
INI.ANALYZE_DATE_F = [2015 12 31 0 0 0];

INI.A1    = 1; % A1_load_computed_timeseries
U.FILE_OBSERVED = 'DATA_OBS_20150604.MATLAB';
U.STATION_DATA = 'monpts_20160401.xlsx';
U.SELECTED_STATION_LIST = 'SelectedStationList-all-V3.txt';
U.MAPF = 'SEEPAGE_MAP.dfs2';
INI.SAVEFIGS = 1;

try
   addpath(genpath(INI.MATLAB_SCRIPTS));
catch
   addpath(genpath(INI.MATLAB_SCRIPTS,0));
end

INI = setup_ini(INI,U);

% reset these to values specified above, not what is in setup.ini script
INI.LOAD_MOLUZ    = LOAD_MOLUZ;  % Detailed Timeseries stored on UZ/OC timesteps (loads all items)
INI.LOAD_M11      = LOAD_M11;  % Detailed Timeseries (loads all items)
INI.LOAD_MSHE     = LOAD_MSHE;  % Detailed Timeseries (loads all items)
INI.LOAD_OL       = LOAD_OL;  % Overland dfs2 file (loads cells defined in xls spreadsheet)
INI.LOAD_3DSZQ    = LOAD_3DSZQ;  % Saturated zone dfs3 flow file (loads cells defined in xls spreadsheet)


i = 0; % Initialize model run counter

for D = INI.MODEL_ALL_RUNS
    
    i = i + 1; % Increment model run counter
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set model output directory and filenames
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    MODEL_RESULT_DIR = INI.MODEL_FULLPATH{i};
    FILE_MOLUZ         = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_OL.dfs0']; %MIKE 2014 filename
    if ~exist(FILE_MOLUZ,'file')
        FILE_MOLUZ       = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS.dfs0']; %MIKE 2011 filename
    end
    FILE_M11           = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_M11.dfs0'];
    FILE_MSHE          = [MODEL_RESULT_DIR '/' char(D) 'DetailedTS_SZ.dfs0'];
    FILE_OL            = [MODEL_RESULT_DIR '/' char(D) '_overland.dfs2'];
    FILE_3DSZ          = [MODEL_RESULT_DIR '/' char(D) '_3DSZ.dfs3'];
    FILE_3DSZQ         = [MODEL_RESULT_DIR '/' char(D) '_3DSZflow.dfs3'];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load model output data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Load DetailedTS_OL data
    L = INI.LOAD_MOLUZ;
    MAP_COMPUTED_MOLUZ_DATA(i) = load_TS_OL (L,MODEL_RESULT_DIR,FILE_MOLUZ);
        
    % Load DetailedTS_M11 data
    L = INI.LOAD_M11;
    MAP_COMPUTED_M11_DATA(i) = load_TS_M11(L,MODEL_RESULT_DIR,FILE_M11);
    
    % Load DetailedTS_SZ data
    L = INI.LOAD_MSHE;
    MAP_COMPUTED_MSHE_DATA(i) = load_TS_MSHE(L,MODEL_RESULT_DIR,FILE_MSHE);
        
    % Load and group OL gridded data
    L = INI.LOAD_OL;
    MAP_COMPUTED_OL_DATA(i) = load_OL_GRIDDED(L,INI,MODEL_RESULT_DIR,FILE_OL);
    
    % Load and group 3DSZQ gridded data
    L = INI.LOAD_3DSZQ;
    MAP_COMPUTED_3DSZQ_DATA(i) = load_SZ_GRIDDED(L,INI,MODEL_RESULT_DIR,FILE_3DSZQ);
        
end

fclose('all');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MAP_COMPUTED_3DSZQ_DATA = load_SZ_GRIDDED(L,INI,MODEL_RESULT_DIR,FILE_3DSZQ)

MAP_COMPUTED_3DSZQ = 0;
if L
    MAP_COMPUTED_3DSZQ = {get_GRIDDED_DATA(FILE_3DSZQ,INI,INI.CELL_DEF_FILE_DIR_3DSZQ,INI.CELL_DEF_FILE_NAME_3DSZQ,INI.CELL_DEF_FILE_SHEETNAME_3DSZQ,'3DSZQ')};
%     MAP_COMPUTED_3DSZQ = {read_and_group_computed_timeseries(FILE_3DSZQ,...
%         INI.CELL_DEF_FILE_DIR_3DSZQ,INI.CELL_DEF_FILE_NAME_3DSZQ,...
%         INI.CELL_DEF_FILE_SHEETNAME_3DSZQ)};
    if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  ...
            mkdir([MODEL_RESULT_DIR '/matlab']), end
    save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZQ.MATLAB'],...
        'MAP_COMPUTED_3DSZQ', '-v7.3');
    MAP_COMPUTED_3DSZQ_DATA = MAP_COMPUTED_3DSZQ;
else
    try
        load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_3DSZQ.MATLAB'],'-mat');
        MAP_COMPUTED_3DSZQ_DATA=MAP_COMPUTED_3DSZQ;
    catch
        MAP_COMPUTED_3DSZQ_DATA = 0;
        fprintf('\n... Exception in load_SZ_GRIDDED() \n')
        fprintf('\n... -> MAP_COMPUTED_3DSZQ.MATLAB not loaded, continuing with MAP_COMPUTED_3DSZQ_DATA = 0 \n')
    end;
end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MAP_COMPUTED_OL_DATA = load_OL_GRIDDED(L,INI,MODEL_RESULT_DIR,FILE_OL)

MAP_COMPUTED_OL_DATA = 0;
if L
    MAP_COMPUTED_OL = {get_GRIDDED_DATA(FILE_OL,INI,INI.CELL_DEF_FILE_DIR_OL,INI.CELL_DEF_FILE_NAME_OL,INI.CELL_DEF_FILE_SHEETNAME_OL,'OL')};
    if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  ...
            mkdir([MODEL_RESULT_DIR '/matlab']), end
%         MAP_COMPUTED_OL = {read_and_group_computed_timeseries...
%             (FILE_OL,INI.CELL_DEF_FILE_DIR_OL,INI.CELL_DEF_FILE_NAME_OL,...
%             INI.CELL_DEF_FILE_SHEETNAME_OL)};
    save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_OL.MATLAB'],...
        'MAP_COMPUTED_OL', '-v7.3');
    MAP_COMPUTED_OL_DATA = MAP_COMPUTED_OL;
else
    try
        load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_OL.MATLAB'],'-mat');
        MAP_COMPUTED_OL_DATA=MAP_COMPUTED_OL;
    catch
        fprintf('\n... Exception in load_OL_GRIDDED()')
        fprintf('\n... -> MAP_COMPUTED_OL.MATLAB not loaded, continuing with MAP_COMPUTED_OL_DATA = 0 \n')
    end;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MAP_COMPUTED_MOLUZ_DATA = load_TS_OL (L,MODEL_RESULT_DIR,FILE_MOLUZ)

MAP_COMPUTED_MOLUZ = 0;
% reads computed overland timeseries
if L
    MAP_COMPUTED_MOLUZ = {read_computed_timeseries(FILE_MOLUZ)};
    if ~exist([MODEL_RESULT_DIR '/matlab'],'file')
        mkdir([MODEL_RESULT_DIR '/matlab'])
    end
    save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MOLUZ.MATLAB'],...
        'MAP_COMPUTED_MOLUZ', '-v7.3');
    MAP_COMPUTED_MOLUZ_DATA = MAP_COMPUTED_MOLUZ;
else
    try
        load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MOLUZ.MATLAB'],'-mat');
        MAP_COMPUTED_MOLUZ_DATA = MAP_COMPUTED_MOLUZ;
    catch
        MAP_COMPUTED_MOLUZ_DATA = 0;
        fprintf('\n... Exception in load_TS_OL() \n')
    end;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MAP_COMPUTED_M11_DATA = load_TS_M11 (L,MODEL_RESULT_DIR,FILE_M11)

MAP_COMPUTED_M11_DATA = 0;
% reads computed M11 timeseries
if L
    MAP_COMPUTED_M11 = {read_computed_timeseries(FILE_M11)};
    if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
    save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_M11.MATLAB'],'MAP_COMPUTED_M11', '-v7.3');
    MAP_COMPUTED_M11_DATA = MAP_COMPUTED_M11;
else
    try
        load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_M11.MATLAB'],'-mat');
        MAP_COMPUTED_M11_DATA=MAP_COMPUTED_M11;
    catch
        MAP_COMPUTED_M11_DATA = 0;
        fprintf('\n... Exception in load_TS_OL() \n')
    end;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MAP_COMPUTED_MSHE_DATA = load_TS_MSHE (L,MODEL_RESULT_DIR,FILE_MSHE)

MAP_COMPUTED_MSHE_DATA = 0;
% reads computed MSHE timeseries

if L
    MAP_COMPUTED_MSHE = {read_computed_timeseries(FILE_MSHE)};
    if ~exist([MODEL_RESULT_DIR '/matlab'],'file'),  mkdir([MODEL_RESULT_DIR '/matlab']), end
    save([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MSHE.MATLAB'],'MAP_COMPUTED_MSHE', '-v7.3');
    MAP_COMPUTED_MSHE_DATA = MAP_COMPUTED_MSHE;
else
    try
        load([MODEL_RESULT_DIR '/matlab/MAP_COMPUTED_MSHE.MATLAB'],'-mat');
        MAP_COMPUTED_MSHE_DATA=MAP_COMPUTED_MSHE;
    catch
        MAP_COMPUTED_MSHE_DATA = 0;
        fprintf('\n... Exception in load_TS_OL() \n')
    end;
end
end


