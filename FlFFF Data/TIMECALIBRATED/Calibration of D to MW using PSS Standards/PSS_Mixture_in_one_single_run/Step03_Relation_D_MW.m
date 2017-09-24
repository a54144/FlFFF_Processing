clear;
close all;
%WorkingPath = '/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of D to MW using PSS Standards/PSS_Mixture_in_one_single_run/01_Derive_D_of_PSSStandards/';
%C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\01_Derive_D_of_PSSStandards\
WorkingPath = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\01_Derive_D_of_PSSStandards\';
Parameter_Names = {'Slope';'Intercept';'Rsquared';'P value'}; number_parameter = size(Parameter_Names,1);
Detectors_data_extracted = {'UV_1';'UV_2';'FLD1';'FLD2'};number_detectors = size(Detectors_data_extracted,1);
Table_relation_DC_MW = zeros(number_parameter,number_detectors);

Table_Diffusion_coefficient_at_Peak = load('Table_Diffusion_coefficient_at_Peak.dat');
MW_Samples = load(strcat(WorkingPath,'MW_Samples.dat'));

for detectorr = 1:number_detectors;
    DC_this_detector = Table_Diffusion_coefficient_at_Peak (:,detectorr);
    log_recip_DC = log10(1./DC_this_detector);
    log_MW_Samples = log10(MW_Samples);
    linearfitting = polyfit(log_MW_Samples,log_recip_DC, 1);
    slope = linearfitting(1);
    intercept = linearfitting(2);
    [r,p] = corrcoef (log_MW_Samples,log_recip_DC);
    rsquared = r(1,2)^2;
    pvalue = p(1,2);
    parameter_array = [slope;intercept;rsquared;pvalue];
    Table_relation_DC_MW(:,detectorr ) = parameter_array;
end;
save Table_relation_DC_MW.dat Table_relation_DC_MW -ascii -tabs;


fid_table = fopen('Table_relation_DC_MW.xls','wt');
fprintf(fid_table,'\t');
for detectorr = 1: size(Detectors_data_extracted,1);
    fprintf (fid_table,Detectors_data_extracted{detectorr});
    fprintf (fid_table,'\t');
end;
fprintf (fid_table,'\n');
fid_data = fopen('Table_relation_DC_MW.dat','r');
for number_parameter = 1: size(Table_relation_DC_MW,1);
    fprintf (fid_table,Parameter_Names{number_parameter,1});
    fprintf (fid_table,'\t');
    line = fgetl(fid_data);
    fprintf (fid_table,line);
    fprintf (fid_table,'\n');
end;
fclose(fid_data);
fclose(fid_table);

