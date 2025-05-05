function goship_csv2mat(GS_folder,GS_name)

% Used to read the GO-SHIP N2O dataset .csv file and convert to .mat files,
% matching outputs from glodap2_csv2mat
%
% Input: GS_folder - folder where 'allgoshipn2o.csv' is located
%        datafile_name - 'allgoshipn2o' or whatever you've renamed it to,
%        WITHOUT the .csv extension
%
% Output: a .mat file with the reference data and a .mat file with the
%         lookup table used by define_domain
% 
%
%
% Colette Kelly 2025-04-16
% last modified 2025-04-16

fclose('all');

outputfilename='2ndQC_GSReferenceData';

% load headers data
fname=cat(2,[GS_folder filesep GS_name '.csv']);
fid = fopen(fname, 'r');
headerline = fgetl(fid);           % Read the first line from the CSV
fclose(fid);

GSheaders = strsplit(headerline, ',');  % Split into a 1×N cell array
GSheaders = GSheaders(:);               % Convert to an N×1 column cell array
sz = size(GSheaders);                   % Get size if needed

% prefix 'GS' on all header names
GSheader=cell(size(GSheaders));
for i=1:sz(1)
    H=char(GSheaders{i});
    s = size(H);
    if s(2) == 0
        GSheader{i,:}='GSindex';
    else
        strcheck=strcmp(H(1:2),'GS');
        if strcheck==0
            GSheader{i,:}=cat(2,['GS',GSheaders{i}]);
        else
            GSheader{i,:}=GSheaders{i};
        end
            %--------------------------------------------------------------
    end
    clear strcheck newname
end

% define non-numeric columns to keep as strings
alphanumeric_cols = ["GSEXPOCODE", "GSstartDate", "GSendDate", "GSwoce_lines", "GSsource", ...
                     "GSSECT_ID", "GSBIOME_ABREV", "GSBIOME_FULL"];

% Reopen file to read the rest of the CSV (skip first line)
opts = delimitedTextImportOptions('NumVariables', sz(1));
opts.DataLines = [2, Inf];
opts.Delimiter = ',';
opts.ExtraColumnsRule = 'ignore';
opts.MissingRule = 'fill';
opts = setvartype(opts, repmat("string", 1, sz(1)));  % Start with all strings

% Read the data
GSdata = readtable(fname, opts);
% Apply new header names
GSdata.Properties.VariableNames = GSheader;

% Convert all columns except alphanumeric ones to numeric
for i = 1:numel(GSheader)
    varname = GSheader{i};
    if ~ismember(varname, alphanumeric_cols)
        GSdata.(varname) = str2double(GSdata.(varname));
    end
end

% Convert date columns to datetime
GSdata.GSstartDate = datetime(GSdata.GSstartDate, 'InputFormat', 'yyyy-MM-dd', 'Format', 'yyyy-MM-dd');
GSdata.GSendDate   = datetime(GSdata.GSendDate,   'InputFormat', 'yyyy-MM-dd', 'Format', 'yyyy-MM-dd');

% Extract month and day
GSdata.GSdate_dt = datetime(string(GSdata.GSDATE), 'InputFormat', 'yyyyMMdd');
GSdata.GSmonth = month(GSdata.GSdate_dt);
GSdata.GSday   = day(GSdata.GSdate_dt);

% Extract hour and minute
% Convert GSTIME to string with leading zeros if needed
GS_time_str = pad(string(GSdata.GSTIME), 4, 'left', '0');
% Extract hour and minute
GSdata.GShour   = str2double(extractBetween(GS_time_str, 1, 2));
GSdata.GSminute = str2double(extractBetween(GS_time_str, 3, 4));

% rename existing columns to match GLODAP format
GSdata.Properties.VariableNames{'GSSTNNBR'} = 'GSstation';
GSdata.Properties.VariableNames{'GSCASTNO'} = 'GScast';
GSdata.Properties.VariableNames{'GSYEAR'} = 'GSyear';
GSdata.Properties.VariableNames{'GSLATITUDE'} = 'GSlatitude';
GSdata.Properties.VariableNames{'GSLONGITUDE'} = 'GSlongitude';
GSdata.Properties.VariableNames{'GSDEPTH'} = 'GSbottomdepth';
GSdata.Properties.VariableNames{'GSBTLNBR'} = 'GSbottle';
GSdata.Properties.VariableNames{'GSBTLNBR_FLAG_W'} = 'GSbottlef';
GSdata.Properties.VariableNames{'GSCTDPRS'} = 'GSpressure';
GSdata.Properties.VariableNames{'GSCTDPRS_FLAG_W'} = 'GSpressuref';
GSdata.Properties.VariableNames{'GSCTDTMP'} = 'GStemperature';
GSdata.Properties.VariableNames{'GSCTDTMP_FLAG_W'} = 'GStemperaturef';
GSdata.Properties.VariableNames{'GSCT'} = 'GStheta';
GSdata.Properties.VariableNames{'GSCTDSAL'} = 'GSsalinity';
GSdata.Properties.VariableNames{'GSCTDSAL_FLAG_W'} = 'GSsalinityf';
GSdata.Properties.VariableNames{'GSCTDOXY'} = 'GSoxygen';
GSdata.Properties.VariableNames{'GSCTDOXY_FLAG_W'} = 'GSoxygenf';
GSdata.Properties.VariableNames{'GSAOU'} = 'GSaou';
GSdata.Properties.VariableNames{'GSNITRAT'} = 'GSnitrate';
GSdata.Properties.VariableNames{'GSNITRAT_FLAG_W'} = 'GSnitratef';
GSdata.Properties.VariableNames{'GSSILCAT'} = 'GSsilicate';
GSdata.Properties.VariableNames{'GSSILCAT_FLAG_W'} = 'GSsilicatef';
GSdata.Properties.VariableNames{'GSPHSPHT'} = 'GSphosphate';
GSdata.Properties.VariableNames{'GSPHSPHT_FLAG_W'} = 'GSphosphatef';
GSdata.Properties.VariableNames{'GSTCARBN'} = 'GStco2';
GSdata.Properties.VariableNames{'GSTCARBN_FLAG_W'} = 'GStco2f';
GSdata.Properties.VariableNames{'GSALKALI'} = 'GStalk';
GSdata.Properties.VariableNames{'GSALKALI_FLAG_W'} = 'GStalkf';
GSdata.Properties.VariableNames{'GSCFC-11'} = 'GScfc11';
GSdata.Properties.VariableNames{'GSCFC-11_FLAG_W'} = 'GScfc11f';
GSdata.Properties.VariableNames{'GSCFC-12'} = 'GScfc12';
GSdata.Properties.VariableNames{'GSCFC-12_FLAG_W'} = 'GScfc12f';
GSdata.Properties.VariableNames{'GSSF6'} = 'GSsf6';
GSdata.Properties.VariableNames{'GSSF6_FLAG_W'} = 'GSsf6f';
GSdata.Properties.VariableNames{'GSN2O'} = 'GSn2o';
GSdata.Properties.VariableNames{'GSN2O_FLAG_W'} = 'GSn2of';

% removed bad-flagged bottles, CTD pres temp sal, and GS
goodRows = ~ismember(GSdata.GSbottlef, [3, 4, 9]) & ... % define based on bad flags because some data doesn't have bottle flags
           ~ismember(GSdata.GSpressuref, [3, 4, 9]) & ...
           ~ismember(GSdata.GStemperaturef, [3, 4, 9]) & ...
           ~ismember(GSdata.GSsalinityf, [3, 4, 9]) & ...
           ismember(GSdata.GSn2of,    [2, 6, 7, 8]);

GSdata = GSdata(goodRows, :);

% calculate additional sigma levels
GSdata.('GSsigma1') = (sw_pden(GSdata.('GSsalinity'), GSdata.('GStemperature'), GSdata.('GSpressure'), 1000)) - 1000;
GSdata.('GSsigma2') = (sw_pden(GSdata.('GSsalinity'), GSdata.('GStemperature'), GSdata.('GSpressure'), 2000)) - 1000;
GSdata.('GSsigma3') = (sw_pden(GSdata.('GSsalinity'), GSdata.('GStemperature'), GSdata.('GSpressure'), 3000)) - 1000;
GSdata.('GSsigma4') = (sw_pden(GSdata.('GSsalinity'), GSdata.('GStemperature'), GSdata.('GSpressure'), 4000)) - 1000;

% add cruise number index
[unique_cruises, ~, cruise_idx] = unique(GSdata.GSEXPOCODE, 'stable');
GSdata.GScruise = cruise_idx;

% save out filtered data to .mat file
matfilename=cat(2,[GS_folder filesep GS_name '.mat']);
save(matfilename, 'GSdata');

% define reference variables, i.e. those used in 2QC
GSref_vars={'GScruise';'GSstation';'GScast';'GSyear';'GSmonth';'GSday';...
    'GShour';'GSminute';'GSlatitude';'GSlongitude';'GSbottomdepth';'GSbottle';...
    'GSpressure';'GStemperature';'GStheta';'GSsalinity';'GSsalinityf';...
    'GSsigma0';'GSsigma1';'GSsigma2';'GSsigma3';'GSsigma4';'GSoxygen';...
    'GSoxygenf';'GSaou';'GSnitrate';...
    'GSnitratef';'GSsilicate';'GSsilicatef';'GSphosphate';...
    'GSphosphatef';'GStco2';'GStco2f';'GStalk';'GStalkf';...
    'GScfc11';'GScfc11f';'GScfc12';'GScfc12f';...
    'GSsf6';'GSsf6f';'GSn2o';'GSn2of'};

% MAY NEED TO ADD THESE LATER
missing_vars = {'GSregion';'GSmaxsampdepth'; 'GSdepth';...
    'GSgamma';'GSsalinityqc';'GSoxygenqc'; 'GSaouf';...
    'GSnitrateqc';'GSsilicateqc';'GSphosphateqc';'GStco2qc';...
    'GStalkqc';'GSfco2';'GSfco2f';'GSfco2temp';'GSphts25p0';...
    'GSphts25p0f';'GSphtsinsitutp';'GSphtsinsitutpf';'GSphtsqc';...
    'GSpcfc11';'GScfc11qc';'GSpcfc12';'GScfc12qc';'GScfc113';...
    'GSpcfc113';'GScfc113f';'GScfc113qc';'GSccl4';'GSpccl4';...
    'GSccl4f';'GSccl4qc';'GSpsf6';'GSsf6qc'};

% set up ref_vars cell array
GSref_data = [];
for i=1:size(GSref_vars,1)
var=cat(2,['GSref_data(:,i)=double(GSdata.',GSref_vars{i,:},');']);
eval(var)
end

GSunique_cruises=unique(GSdata.GSEXPOCODE,'stable');

GSref_UC=unique(GSdata.GScruise);
GSref_expocodes = cellstr(GSunique_cruises);

% save as .mat file
outputname=cat(2,[GS_folder filesep outputfilename '.mat']); 
save(outputname,'GSref_data','GSref_vars','GSunique_cruises','GSref_UC','GSref_expocodes');

% create lookup table for subsampling the reference dataset when running Xovers
outputname=cat(2,[GS_folder filesep 'ReferencePositions_LookupTable.mat']);
rlat=GSdata.GSlatitude; rlon=GSdata.GSlongitude; rcruise=GSdata.GScruise;
save(outputname,'rcruise','rlat','rlon');

disp('.mat file created')
