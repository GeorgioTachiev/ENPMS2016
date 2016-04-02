----------------------
GENERAL INFORMATION
----------------------

- These scripts essentially load all the data from the Detailed Timeseries output files for a chosen set of model runs, and then plot the data along with the observed data by station.

- It is important to note that when observed data exists for a station, the scripts will only plot the model data points that correspond to the observed data. For example, if station NE4 has 3 observed data points and 10 modeled data points, the plots would only show 3 modeled data points. This can become important especially for accumulated flow plots.

- A nice feature of these plots is that they include a line indicating land surface elevation for the stage plots.

- Summary statistics for stage data are also generated and added to the monthly average stage box plots.

- The scripts generate a LaTeX file that can be run in a LaTeX editor to produce a pdf document that contains the plots for all the stations, in alphabetical order, with bookmarks and hyperlinks for easy navigation.

- The scripts also generate ‘statgis.asc’, which can be loaded into ARC and will show the performance statistics on a map for easy geographical referencing.

- The scripts save the individual plots in subfolders. A Google Earth kml file has been created that can be used to pull up individual plots through the Google Earth viewer by clicking on the station names on the map. This file needs to be copied from the data folder into the folder containing the plots, and is still a bit hacky.

- As interim steps in the postprocessing scripts, MATLAB data files containing the extracted data are saved into two directories called 'matlab'. The individual model output is saved into the Results folder for each model run, and files containing data from all model output requested is saved into the analysis directory.

- Only the template script will need to be edited to choose alternatives and time periods

- Boxplots and statistics will not work if fewer than two years of data is available

- This code requires the use of the DHI MATLAB toolbox, which is the set of scripts in the 'DHI/mbin' directory.

- The 'CODE' section below details the general functional structure of these MATLAB code, and contains comments on what the code does.

- The 'DATA FILES' section below lists the important data files used in these scripts.


----------------------
COMMENTS
----------------------
Last revised 3/19/2016 keb  (might not be entirely accurate listing - use caution)


----------------------
DATA FILES
----------------------

monpts3lyrV8.xlsx (new - slightly different format. GEORGIO: if you have anything you want to incorporate from monptsV14-11.xlsx please do so.)
selected_station_list.txt
DATA_OBS20150604lyr3.MATLAB
MDR_SEEPAGE.dfs2
seepageValuesXL.xlsx

----------------------
CODE
----------------------

ANALYSIS SIMULATION TEMPLATE

	get_INI
		readXLSmonptsV8 (meant to eventually replace readXLSmonpts but many dependencies need to be checked)
		get_station_list

	A1_load_computed_timeseries  *this script creates and saves MAP_ALL_DATA structure as 'tag_TIMESERIES_DATA.MATLAB'
		read_computed_timeseries  *this is where the flow units get fixed for graphs
			get_daily_data
		read_and_group_computed_timeseries *does not work for datasets of any large size - needs to be fixed
			xlsread
			InputDFS2
			InputDFS3
			pivottable  *to be replaced with new method discussed with GIT
		combine_computed  *combines data arrays into one container, and trims or expands dates to requested start-end times
		add_observed - hard for me to say whcih version to use. needs further investigation  *adds observed data and elevations to container if we extracted them
			extract_period_ts

	A2_generate_timeseries_stat *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_DATA.MATLAB', modifies it, and saves it as 'tag_TIMESERIES_STAT.MATLAB'
		remove_nan
		get_station_stat
			get_COUNT
			get_ME
			get_MAE
			get_RMSE
			get_STDres  (RJF has new one - verify that is what GIT wants to use)
			get_NS
			get_COVAR
			get_COR
			get_PEV
			calculate_exceedance

	A2a_cumulative_flows   *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_STAT.MATLAB', modifies it, and saves it back as 'tag_TIMESERIES_STAT.MATLAB'
		summarize_YM
		write_QYM
		print_M_AVE
		print_Y_AVE

	A3_create_figures_timeseries  *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_DATA.MATLAB'
		plot_timeseries
			tscollection (part of DHI MATLAB toolbox)
			timeseries (part of DHI MATLAB toolbox)
			gettimeseriesnames (part of DHI MATLAB toolbox)
			% commented out: plot_figureV0
			add_ground_level
		plot_timeseries_accumulated
			tscollection (part of DHI MATLAB toolbox)
			timeseries (part of DHI MATLAB toolbox)
			gettimeseriesnames (part of DHI MATLAB toolbox)
			% commented out: plot_figureV0
			% commented out: printfigureV0

	A3a_boxmat *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_DATA.MATLAB'
		get_station_list
		TSmerge
		mthyr
		computestats
		plotboxcomb *This function is at the end of A3a_boxmat.m
			add_ground_level
		plotempty  *This function is at the end of A3a_boxmat.m

	A3a_boxmatEXP   *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_DATA.MATLAB'
		get_station_list
		TSmerge
		mthyr
		computestats
		plotboxcombEXP  *This function is at the end of A3a_boxmatEXPs.m
			add_ground_level

	A4_create_figures_exceedance  *this script loads MAP_ALL_DATA structure from 'tag_TIMESERIES_STAT.MATLAB'
		plot_exceedance
			add_ground_level

	A5_create_summary_stat   *this script creates the latex files and loads MAP_ALL_DATA structure from 'tag_TIMESERIES_STAT.MATLAB'
		get_map_station_stat
			get_stat_station
				get_PE
		generate_latex_files
			generate_latex_head
			generate_page_figures
			generate_area_tables
				print_table_stat_header
				print_table_PE_header
			generate_latex_tail

	A6_GW_MAP_COMPARE

	A7_MDR_SEEPAGE
