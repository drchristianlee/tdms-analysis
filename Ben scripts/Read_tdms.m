% this script will read all of the data into a matrix which will need to be traversed later on to extract
%licks 
clear
clc

[newfolder] = uigetdir;
cd(newfolder)
filePattern = fullfile(newfolder, '*.tdms');
tdmsfiles = dir(filePattern);
readTDMS
gh = ['C:\Users\margolislab.LIFE_SCIENCES\Desktop\tdms files test 2\Ben'];
cd(gh)
