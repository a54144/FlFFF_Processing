clear;
clc
close all;
% % % % % % % Cytochrome C (Horse heart) 13.0*10^(-11)
% % % % % % % alpha Chymotrypsinogen A 9.48*10^(-11)
% % % % % % % Bovin Serum Albumin	6.15*10^(-11)
% % % % % % % beta-Amylase	4.42*10^(-11)
% % % % % % % Ferritin	3.61*10^(-11)
% % % % % % % Thyroglobulin	2.61*10^(-11)


% % % % % % % Samples present 
% % % % % % % t0
% % % % % % % alpha Chymotrypsinogen A
% % % % % % % BSA
% % % % % % % Ferritin
% % % % % % % Thyroglobulin

Detectors_want_to_plot = {'UV_1';'UV_2';'FLD1';'FLD2'};
Detectors_want_to_plot_modified_names = {'UV_2_5_4';'UV_2_8_0';'FLD_3_5_0_/_4_5_0';'FLD_2_7_5_/_3_4_0'};
Color_in_letter = 'kgrb';

Plot_Selected_Sample_Selected_Detectors = 1;
If_Just_Using_UV_data_and_offset_times = 1;
tR_Combined = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of tR to D and dH using Protein Standards/tR_Tubetime_corrected_Transition_time_compensated_Unit_second.dat');

% Change   t0     into   t0/3.    t0 is the first row of data
tR_Combined_t0_a_third = tR_Combined;
tR_Combined_t0_a_third(1,:) = tR_Combined(1,:)./3;
tR_Combined = tR_Combined_t0_a_third;


D = [9.48*10^(-11);6.15*10^(-11);3.61*10^(-11);2.61*10^(-11)];
D_reciprocal = 1./D;
D_reciprocal = [0;D_reciprocal];


Fitting_Results_to_report = {'Slope';'Intercept';'R_squared';'P_value'};
D_reciprocal_tR_Fitting_results = zeros(size(Fitting_Results_to_report,1),size(Detectors_want_to_plot,1));

h_figure = figure;
for detectorr = 1: size(Detectors_want_to_plot,1);
    subplot(2,2,detectorr)
    plot(D_reciprocal,tR_Combined(:,detectorr ),'marker','o','markerfacecolor',Color_in_letter(detectorr),'markeredgecolor',Color_in_letter(detectorr),'linestyle','none');
    xlabel('D^-^1 (s m^-^2)','fontname','times','fontsize',12);
    ylabel('t_R (s)','fontname','times','fontsize',12);
    title(Detectors_want_to_plot_modified_names{detectorr},'fontname','times','fontsize',12);
    set(gca,'fontname','times','fontsize',12);
    

    intercept = tR_Combined(1,detectorr);
    slope = ((sum(D_reciprocal.*tR_Combined(:,detectorr)))-(intercept*sum(D_reciprocal)))/(sum(D_reciprocal.^2));
%     THE SAME EQUATION FOR SLOPE CALCULATION, BUT ORIGINALLY FROM BJORN
%     EXCEL: x = D_reciprocal; y = tR_Combined(:,detectorr);intercept = y(1);slope = ((x(1)-intercept)*(y(1)-intercept)+(x(2)-intercept)*(y(2)-intercept)+(x(3)-intercept)*(y(3)-intercept)+(x(4)-intercept)*(y(4)-intercept)+(x(5)-intercept)*(y(5)-intercept))/((x(1)-intercept)^2+(x(2)-intercept)^2+(x(3)-intercept)^2+(x(4)-intercept)^2+(x(5)-intercept)^2);
%     linearfitting = polyfit(D_reciprocal,tR_Combined(:,detectorr), 1);
%     slope = linearfitting(1);intercept = linearfitting(2);
    [r,p] = corrcoef (D_reciprocal,tR_Combined(:,detectorr));
    rsquared = r(1,2)^2;pvalue = p(1,2);
    table = [slope;intercept;rsquared;pvalue];
    D_reciprocal_tR_Fitting_results (:,detectorr) = table;
end;
saveas (h_figure,'Reciprocal of diffusion coefficient Versus Retention time - Protein Standards','pdf');
close all;
save D_reciprocal_tR_Fitting_results.dat D_reciprocal_tR_Fitting_results -ascii -tabs;
fid = fopen('D_reciprocal_tR_Fitting_results.xls','wt');
fprintf(fid,'\t');
for detectorr = 1: size(Detectors_want_to_plot,1);
    fprintf (fid,Detectors_want_to_plot{detectorr});
    fprintf (fid,'\t');
end;
fprintf (fid,'\n');
fiddata = fopen('D_reciprocal_tR_Fitting_results.dat','r');
for fittingg = 1: size(Fitting_Results_to_report,1);
    fprintf (fid,Fitting_Results_to_report{fittingg});
    fprintf (fid,'\t');
    line = fgetl(fiddata);
    fprintf (fid,line);
    fprintf (fid,'\n');
end;
fclose(fid);
fclose(fiddata);