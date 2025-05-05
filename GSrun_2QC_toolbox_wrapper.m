function GSrun_2QC_toolbox_wrapper(ref_path, data_folder, mindepth, maxdist, y_param, param, latbox, lonbox, closeplots)

%% -----------------------------------------------------------------------
%% DO NOT CHANGE ANYTHING BELOW THIS!!!
%% -----------------------------------------------------------------------

f=which('m_grid');
[path,name]=fileparts(f); addpath(path);warning off; clear path name
if isempty(f)
    disp('YOU HAVE TO ADD YOUR PATH TO THE M-MAP TOOLBOX')
end

f=which('sw_pden');
[path,name]=fileparts(f); addpath(path);warning off; clear path name
if isempty(f)
    disp('YOU HAVE TO ADD YOUR PATH TO THE SEAWATER TOOLBOX')
end

f=which('toolbox_2QC');
[path, name]=fileparts(f); addpath(path);warning off; clear path name
if isempty(f)
    disp('YOU HAVE TO ADD YOUR PATH TO THE 2QC TOOLBOX')
end

addpath(data_folder); warning off
[path,name]=fileparts(data_folder); clear dr
folder=name;

ref_name='2ndQC_GSReferenceData.mat'; 

P=zeros(1,25);
for i=1:size(param,2)
switch param{i}
    case 'TCARBN'
        P(1)=1;
    case 'ALKALI'
        P(2)=2;
    case 'OXYGEN'
        P(3)=3;
    case 'NITRAT'
        P(4)=4;
    case 'PHSPHT'
        P(5)=5;
    case 'SILCAT'
        P(6)=6;
    case 'SALNTY'
        P(7)=7;
    case 'CTDSAL'
        P(8)=8;
    case 'CTDOXY'
        P(9)=9;
    case 'PH'
        P(10)=10;
    case 'THETA'
        P(11)=11;
    case 'DOC'
        P(12)=12;
    case 'CFC_11'
        P(13)=13;
    case 'CFC_12'
        P(14)=14;
    case 'N2O'
        P(15)=15;
end
end

switch y_param
    case 'density (i.e. sigma4)'
        surface=[1 1 1 1 1 1 2 2 1 1 1 1 1 1 1];
        Y='XoverRESULTS_DENSITY';
    case 'pressure'
        surface=[2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];
        Y='XoverRESULTS_PRESSURE';
end  

latlim=maxdist;

fname=cat(2,[ref_path filesep '2QC_toolbox_log.txt']);
fid=fopen(fname,'a');

if exist('latbox', 'var') && exist('lonbox', 'var')
    disp('latbox and lonbox were provided. Using them directly.');
else
    disp('latbox and/or lonbox not defined. Please click on the map to define domain.');
    latbox = [];
    lonbox = [];
end

% call function with latbox and lonbox:
GStoolbox_2QC(fid,path,ref_path,ref_name,folder,mindepth,latlim,P,surface,Y, latbox, lonbox, closeplots)

end