% clear;
% clc;
% close all;
% addpath('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of tR to D and dH using Protein Standards\Tube time\PreSelect\');
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of tR to D and dH using Protein Standards\Tube time\PreSelect\FFF_Tube_time.m');
% display('Calibration of tR to D and dH uisng Protein Standards - Preselect has done.');
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of tR to D and dH using Protein Standards\Tube time\Average\FFF_Tube_time.m');
% display('Calibration of tR to D and dH uisng Protein Standards - Average has done.');
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\20150101\01_Derive_D_of_PSSStandards\Step01_Derive_D_of_PSS_Standards.m');
% display('Calibration of tR to D and dH uisng PSS Standards - step 1-has done.');
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\20150101\Step02_Find_D_at_Peak_Signal.m');
% display('Calibration of tR to D and dH uisng PSS Standards - step 2-has done.');
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\20150101\Step03_Relation_D_MW.m');
% display('Calibration of tR to D and dH uisng PSS Standards - Final Step-has done!');
% 
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\01_Derive_D_of_PSSStandards\Step01_Derive_D_of_PSS_Standards.m')
% display('Calibration of tR to D and dH uisng PSS Standards-PSS Mixture-Step1-has done!');
% 
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\Step02_Find_D_at_Peak_Signal.m')
% display('Calibration of tR to D and dH uisng PSS Standards-PSS Mixture-Step2-has done!');
% 
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\Step03_Relation_D_MW.m')
% display('Calibration of tR to D and dH uisng PSS Standards-PSS Mixture-Step3-has done!');

%%Processed Begin
% run('C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\AsFFF_time_calibration_Aug2013.m');
% display('Time calibrated.');
run('C:\Matlab Processing\FlFFF Data\PROCESSED\FFF_Further_processing_Step_01_concentration_calibration.m')
display('Processed Step1 Compeleted');
run('C:\Matlab Processing\FlFFF Data\PROCESSED\FFF_Further_processing_Step_02_integration_over_intervals.m')
display('Processed Step2 Compeleted');
run('C:\Matlab Processing\FlFFF Data\PROCESSED\FFF_Further_processing_Step_03_visualization.m');
display('Processed Final Step Compeleted');
display('ALL COMPELETED');


