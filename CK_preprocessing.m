%cruise_folder = '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/data/GLODAP';
%datafile_name = 'GLODAPv2.2022_Merged_Master_File';
%expocode_file_name = 'EXPOCODES.txt';

%glodap2_csv2mat(cruise_folder,datafile_name,expocode_file_name)

GS_folder = '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/data/GO-SHIP';
GS_name = 'allgoshipn2o';

goship_csv2mat(GS_folder,GS_name)

%expocode = string(crossovers{1, 'EXPOCODE1'});
%xoverpath = '/Users/colette/Library/CloudStorage/GoogleDrive-colette.kelly@whoi.edu/My Drive/postdoc_research/code/2nd_QC_tool/goshipxovers';
%filename = sprintf('%s%s%s%s%s.mat', xoverpath, filesep, expocode, filesep, expocode);
%load(filename)

%expocode = '33RO20150410';


%cruise_folder = sprintf('%s%s%s%s%s.mat', xoverpath, filesep, expocode);
%GSreadreformatted(cruise_folder)
%GSexcread(cruise_folder)