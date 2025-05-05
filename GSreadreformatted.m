function GSreadreformatted(cruise_folder)

% Highly modified version of exceread.m (by Steven Van Heuven), use to read
% exchange formatted oceanographic bottle data files and convert them to 
% .mat files
%
% Input: cruise_folder - This is the folder where your data file is located
%                        The name of this folder must be the expocode of
%                        the cruise (12 digit alphanumeric string, e.g. 
%                        06MS20081031)
%                        Input files are exchange formatted *.csv files
%
% Output: a .mat file named by the expocode of the cruise (i.e. the same
%         name as the folder it is inside
% 
%
% Before running a few checks have to be made:
%   1) Make sure that the names in the header of the exchange file exactly 
%   match the VARS2USE.  If there are discrepancies please change the 
%   header in the exchange file.  DO NOT change VARS2USE!
%   2) Make sure that there is at least one line (with text) before the
%   headers in the exchange file.
%   3) Remove any '' that occurs before the # in the exchange file (open
%   the file in a text reader to find such occurrances).
%   4) Read the header information in the exchange file.
%
% Are Olsen, March 2012
% modified by Siv Lauvset 2013-09-06
% modified by Siv Lauvset 2016-07-25

fclose('all');


%Define variables to read
VARS2USE = {'EXPOCODE','STNNBR','CASTNO','SAMPNO','BTLNBR','BTLNBR_FLAG_W','DATE','TIME','LATITUDE','LONGITUDE',...
    'DEPTH','CTDPRS','CTDTMP','CTDSAL','CTDSAL_FLAG_W','SALNTY','SALNTY_FLAG_W','OXYGEN','OXYGEN_FLAG_W','SILCAT',...
    'SILCAT_FLAG_W','NITRAT','NITRAT_FLAG_W','PHSPHT','PHSPHT_FLAG_W','ALKALI','ALKALI_FLAG_W','TCARBN','TCARBN_FLAG_W',...
    'CTDOXY','CTDOXY_FLAG_W','PH_SWS','PH_SWS_FLAG_W','PH_TMP','PH_TMP_FLAG_W','PH_TOT','PH_TOT_FLAG_W','PH','PH_FLAG_W',...
    'THETA','DOC','DOC_FLAG_W','CFC_11','CFC_11_FLAG_W','CFC_12','CFC_12_FLAG_W','N2O','N2O_FLAG_W'};

%%%%%%%%%%%%%%%% END: USER DEFINED INPUT %%%%%%%%%%%%%%%%%%%%%%%
% define expocode
expocode = cruise_folder(:,end-11:end);

% Locate and load file
A = dir(fullfile(cruise_folder, [expocode '.csv']));
file = fullfile(cruise_folder, A.name);

% Import only needed variables
opts = detectImportOptions(file);
opts.SelectedVariableNames = intersect(VARS2USE, opts.VariableNames);
opts = setvartype(opts, 'BTLNBR', 'string');  % Read BTLNBR as string
opts.VariableNamingRule = 'modify';           % Clean variable names

T = readtable(file, opts);

% Replace -999 with NaN in numeric variables
for var = opts.SelectedVariableNames
    if isnumeric(T.(var{1}))
        T.(var{1})(T.(var{1}) == -999) = NaN;
    end
end

% handle sparse N2O data in P01
if iscell(T.N2O)
    T.N2O = cellfun(@str2double, T.N2O);
end

if iscell(T.N2O_FLAG_W)
    T.N2O_FLAG_W = cellfun(@str2double, T.N2O_FLAG_W);
end

% Assign each column to a separate variable (to match legacy code)
for var = VARS2USE
    varname = var{1};
    if ismember(varname, T.Properties.VariableNames)
        eval([varname ' = T.(varname);']);
    else
        eval([varname ' = [];']);
    end
end

% Create legacy-style save path
outputname = fullfile(cruise_folder, [cruise_folder(end-11:end) '.mat']);

% Save all variables individually, same as original script
save(outputname, VARS2USE{:});
% check to make sure we have all the variables we need
disp(who)
disp('.mat file created')

end