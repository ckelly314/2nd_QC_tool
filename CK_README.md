# before running code, needed to:
1) download and install m_map for MATLAB: https://www-old.eoas.ubc.ca/~rich/mapug.html#p1
	- no need to also install high-res. coastlines or topography
2) download and install the MATLAB seawater toolbox (NOTE: NOT GSW, OLDER VERSION): https://www.cmar.csiro.au/datacentre/ext_docs/seawater.html
3) download GLODAP synthesis files: https://glodap.info/index.php/merged-and-adjusted-data-product-v2-2022/
	- EXPOCODES.txt
	- Merged Master File in both .csv and .mat formats
4) pre-process GLODAP reference data with glodap2_csv2mat to generate 'ReferencePositions_LookupTable.mat'
	- created short script to do this: CK_preprocessing.mat
5) you need the cruise hydrofiles to be in their original format

# to run without GUI:
1. add paths to m_map, seawater, and 2nd_QC_tool paths
2. update path to GLODAP dataset
3. update path to cruise data
4. update param of interest

NEED TO MAKE SURE YOU'RE RUNNING FROM WITHIN "2nd_QC_tool" folder!