load('goshipxovers/33RO20230306/XoverRESULTS_DENSITY/1000m_2degrees/2025-04-24/n2o_Xresults.mat');
load('goshipxovers/33RO20230306/XoverRESULTS_DENSITY/1000m_2degrees/2025-04-24/n2o_XID.mat')

offsets = RESULT(:,1);
offsetstdevs = RESULT(:,2);
refyears = RESULT(:,4);
refexpocodes = ID: