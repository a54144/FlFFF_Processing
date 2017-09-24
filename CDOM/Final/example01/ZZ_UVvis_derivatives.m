% clear;
% clc;
% close all;

%*********************--------------------------***********************
% 1. Define basic parameters
light_path_in_meter = 0.01;
factor = 2.303/light_path_in_meter;
lamdazero = 375;
AddDOCIndicator =1;
Plot_figure = 1;
% Helms et al 2008: Slope ratio (SR) was calculated as the ratio of 
% linear regression result of S275-295 and S350-400
Sinterval1 = [275 295];
Sinterval2 = [350 400];
Picked_Wavelengths = [254;280;355;370;412;440];
%**********************************************************************

%*********************--------------------------***********************
% 2. Load data & define wavelength intervals for spectral slope calculation
DatagridAllSampleCorrected = load('C:\Matlab Processing\CDOM\Processed\example01\PUREDATA_UVvis.dat');
doc = load('C:\Matlab Processing\CDOM\RAWDATA\example01\doc.dat');
sampleno = size(DatagridAllSampleCorrected,2)-1;
wavelength = DatagridAllSampleCorrected(:,1);
waveinterval = (max(wavelength)-min(wavelength))/(length(wavelength)-1);
if wavelength(1)-wavelength(10) >0; 
    SWAVEinterval1 = Sinterval1(2):-waveinterval:Sinterval1(1);
    SWAVEinterval2 = Sinterval2(2):-waveinterval:Sinterval2(1);
end;
if wavelength(1)-wavelength(10) <0;
    SWAVEinterval1 = Sinterval1(1):waveinterval:Sinterval1(2);
    SWAVEinterval2 = Sinterval2(1):waveinterval:Sinterval2(2);
end;
SWAVEinterval1 = SWAVEinterval1';SWAVEinterval2 = SWAVEinterval2';%This is necessary, since absorpregre1 is ordered as one row per wavelength (size(absorpregre1,2) = 1), SWAVEinterval1 also need to be like this (size(SWAVEinterval1,2) = 1), "MODELFUN should return a vector of fitted values the same length as Y"
fsamplename = fopen('C:\Matlab Processing\CDOM\Processed\example01\ReadyToUseSampleNames.dat');
if AddDOCIndicator ==1; number_of_column = (size(Picked_Wavelengths,1)*3+6); else number_of_column = (size(Picked_Wavelengths,1)*3+5);end;%3 is for absorbance, absorption, and suva; 5 is for S_NLF_1,S_LF_1,S_NLF_2,S_LF_2 and SR, 6 would mean there is also DOC added to the end of the file
Table = zeros(sampleno,number_of_column);
%**********************************************************************

%*********************--------------------------***********************
% 3. Process data, figure plotting, export data in .dat file
for i = 1:sampleno
    filename = fgetl(fsamplename);
    disp(filename);
    data = DatagridAllSampleCorrected(:,(i+1));
    % subtract blank
    absorb = data - mean( data( (wavelength>=650) & (wavelength<=800) ) );
    % change absorbance to absorption
    absorp = absorb*factor;
    azero = absorp(wavelength == lamdazero);
    azeros = num2str(azero);
    % Define the equation
    UVvisfun = inline([azeros,'*exp(beta(1)*(',num2str(lamdazero),'-x))+beta(2)'],'beta','x');
    % get log value of absorption
    absorplog = log(absorp);
    % Calculate spectral slope at the two wavelength intervals - non-linear and linear
    absorpregre1 = absorp(wavelength>=Sinterval1(1)& wavelength<=Sinterval1(2));
    absorplogregre1 = absorplog(wavelength>=Sinterval1(1)& wavelength<=Sinterval1(2));
    try
        [beta,Res] = nlinfit(SWAVEinterval1,absorpregre1,UVvisfun,[0 0]);
    catch me
       disp('something wrong.'); 
       continue
    end
    S_NLF_1 = beta(1); K = beta(2);
    regression = polyfit(SWAVEinterval1,absorplogregre1,1);
    S_LF_1 = -regression(1);
    absorpregre2 = absorp(wavelength>=Sinterval2(1)& wavelength<=Sinterval2(2));
    absorplogregre2 = absorplog(wavelength>=Sinterval2(1)& wavelength<=Sinterval2(2));
    [beta,Res] = nlinfit(SWAVEinterval2,absorpregre2,UVvisfun,[0 0]);
    S_NLF_2 = beta(1); K = beta(2);
    regression = polyfit(SWAVEinterval2,absorplogregre2,1);
    S_LF_2 = -regression(1);
    % Pick absorbance at certain wavelengths
    absorbance_table = zeros(1,size (Picked_Wavelengths,1));
    absorption_table = zeros(1,size (Picked_Wavelengths,1));
    for j = 1:size (Picked_Wavelengths,1);
        absorbance_table(j) = absorb(wavelength == Picked_Wavelengths(j));
        absorption_table(j) = absorp(wavelength == Picked_Wavelengths(j));
    end;
    % Calculate SR and SUVA
    SR = S_LF_1/S_LF_2;
    suva_table = absorbance_table/doc(i)/light_path_in_meter;
    % Put the data together
    if AddDOCIndicator ==1;
        Table (i,:) = [absorbance_table absorption_table suva_table S_NLF_1 S_LF_1 S_NLF_2 S_LF_2 SR doc(i)]; 
    else
        Table (i,:) = [absorbance_table absorption_table suva_table S_NLF_1 S_LF_1 S_NLF_2 S_LF_2 SR];
    end;
    % Plot the data
    if Plot_figure ==1;
        wavelength200800 = wavelength((wavelength>=200)&(wavelength<800));
        absorb200800 = absorb((wavelength>=200)&(wavelength<800));
        hfigure =figure;
        plot(wavelength200800,absorb200800);
        xlabel('Wavelength (nm)');
        ylabel('Absorbance');
        title (filename);
        saveas (hfigure, filename, 'pdf');
        close all;
    end;
end
fclose(fsamplename);
save NumericDataUVvis.dat Table -ascii -tabs;
%**********************************************************************

%*********************--------------------------***********************
% 4. Export data in excel file
fid = fopen('NumericDataUVvis.xls','wt');
fprintf(fid,'\t');
fprintf(fid,'%s','Absorbance');
for i = 1:size(Picked_Wavelengths,1);fprintf(fid,'\t'); end;
fprintf(fid,'%s', 'Absorption coefficient(m^(-1))');
for i = 1:size(Picked_Wavelengths,1);fprintf(fid,'\t'); end;
fprintf(fid,'%s', 'SUVA (L/mg-C/m)');
for i = 1:size(Picked_Wavelengths,1);fprintf(fid,'\t'); end;
fprintf(fid,'%s', 'S275-295 (non-linear) (nm^(-1)');fprintf(fid,'\t');
fprintf(fid,'%s', 'S275-295 (linear) (nm^(-1)');fprintf(fid,'\t');
fprintf(fid,'%s', 'S350-400 (non-linear) (nm^(-1)');fprintf(fid,'\t');
fprintf(fid,'%s', 'S350-400 (linear) (nm^(-1)');fprintf(fid,'\t');
fprintf(fid,'%s', 'SR');
if AddDOCIndicator ==1;
fprintf(fid,'\t');
fprintf(fid,'%s', 'DOC concentration (mg-C/L)');
end;
fprintf(fid,'\t');
fprintf(fid,'\n');
fprintf(fid,'\t');
for iii = 1:3;
    for i = 1:size(Picked_Wavelengths,1);
        fprintf(fid,num2str(Picked_Wavelengths(i)));fprintf(fid,' nm');fprintf(fid,'\t');
    end;
end;
fprintf(fid,'\n');
fiddata = fopen('NumericDataUVvis.dat','r');
fsamplename = fopen('C:\Matlab Processing\CDOM\Processed\example01\ReadyToUseSampleNames.dat','r');
for i = 1:size(Table,1);
    samplename = fgetl(fsamplename);
    fprintf(fid,samplename);
    fprintf(fid,'\t');
    line = fgetl(fiddata);
    fprintf(fid,line);
    fprintf(fid,'\n');
    
end;
fclose(fid);
fclose(fiddata);
%**********************************************************************