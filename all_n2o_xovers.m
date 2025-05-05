clear all;close all

%% USER DEFINED INPUT - CHANGE AS APPROPRIATE

% you have to add the pathway to the m-map and seawater toolboxes, as well as the 2QC toolbox
% if you have these pathways saved in your matlab search path already you
% can comment out this section or simply ignore it (in the latter case you will get a warning in your matlab command window)
addpath '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/code/m_map'; warning off
addpath '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/code/seawater_ver3_3.1'; warning off
addpath '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/code/2nd_QC_tool'; warning off

ref_path='/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/data/GO-SHIP';

xoverpath = '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/code/2nd_QC_tool/goshipxovers';


crossovers = readtable('goshipxovers/crossovers.csv');
s = size(crossovers);
for i=1:3 %s(1)
expocode = crossovers.EXPOCODE{i};
mindepth = crossovers.mindepth(i);
maxdist = crossovers.maxdist(i);
latbox = [crossovers.lat1(i) crossovers.lat2(i)];
lonbox = [crossovers.lon1(i) crossovers.lon2(i)];

data_folder = sprintf('%s%s%s', xoverpath, filesep, expocode);

y_param='density (i.e. sigma4)';
param={'N2O'};

GSrun_2QC_toolbox_wrapper(ref_path, data_folder, mindepth, maxdist, y_param, param, latbox, lonbox, false)

end
