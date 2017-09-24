% clear;
% clc;
% close all;

%*********************--------------------------***********************
% 1. Define basic parameters
addpath('C:\Matlab Processing\FUNCTIONZHOU');
addpath('C:\Matlab Processing\CDOM\RAWDATA\example01'); 
wavelength = (190:1:1100)';
sampleno = load('C:\Matlab Processing\CDOM\RAWDATA\example01\sampleno.dat');
% You actually have sampleno+1 sets of data, the 1 is for WATER BLANK
duplicityarray = 3*ones((sampleno+1),1);
% duplicityarray(i) stands for number of duplicate measurement for the sample number i, remember, i = 1 is for the WATER BLANK
if 0; duplicityarray(1) = 3; duplicityarray(2) = 3;end;% you can change the number of duplicates for any sample
lastsamplelocator = zeros(sampleno,1);
for p = 1:sampleno
    lastsamplelocator(p) = sum(duplicityarray(1:(p+1)));
end
datamatrix = ones( length(wavelength) , (sum(duplicityarray) ) );
samplematrix = ones( length(wavelength) , (sampleno + 1) );
blank = zeros(length(wavelength) ,1);
%**********************************************************************

%*********************--------------------------***********************
% 2. Read raws data from the CSV files
fnames = fopen('fns.dat','r');
fid = fopen('PUREDATA_UVvis.xls','wt');
fisamplename = fopen('ReadyToUseSampleNames.dat','wt');
fprintf(fid, '%s','Wavelength (nm)');
fprintf (fid, '\t');
for k = 1: sum(duplicityarray);
    filename = fgetl(fnames);
    disp(k)  %This helps to locate which sample is currently being read in
    aaa= ZZcsvreadUVvisspectrophotometerGuo2010(filename);%Read data from the CSV file using the function
    datamatrix(:,(k)) = aaa(:,2);
    ii = find(lastsamplelocator == k);
    if ii ~= 0;
        filename = filename (1:length(filename)-7);
        fprintf (fid, '%s \t' , filename);
        fprintf (fisamplename, '%s' , filename);
        fprintf (fisamplename, '\n');
    end
    if k == sum(duplicityarray)
        fprintf (fid, '\n');
    end
end
fclose(fisamplename);
%**********************************************************************

%*********************--------------------------***********************
% 3. Further Process raw data
% Take the average of its duplicates and determine the water blank
for i = 1 : (length(wavelength))
    blank(i) = mean(datamatrix(i,1:duplicityarray(1)));
end
samplematrix(:,1) = wavelength;
% Take the average of each sample's duplicates and subtract the water blank
for which_wavelength = 1 : (length(wavelength))
    fprintf (fid, '%d \t', samplematrix(which_wavelength,1));
    for which_sample = 2: (sampleno+1)
        samplematrix(which_wavelength,which_sample) = mean(datamatrix(which_wavelength,((sum(duplicityarray(1:(which_sample-1)))+1):sum(duplicityarray(1:which_sample)))))-blank(which_wavelength);
        fprintf (fid, '%6.3f \t', samplematrix(which_wavelength,which_sample));
        if which_sample == sampleno+1
            fprintf (fid, '\n');
        end
    end
end
save PUREDATA_UVvis.dat samplematrix -ascii -tabs;
fclose(fid);
fclose(fnames);
%**********************************************************************