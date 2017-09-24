clear;

close all;
%WorkingPath = '/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of D to MW using PSS Standards/PSS_Mixture_in_one_single_run/01_Derive_D_of_PSSStandards/';
WorkingPath = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\01_Derive_D_of_PSSStandards\';
fnames = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW_abbreviated.txt'),'r');counter_names = 0;while 1;line = fgetl(fnames);eof = feof(fnames);counter_names = counter_names + 1;if eof ==1;break;end;end;fclose(fnames);
number_fns = counter_names; 
Detectors_data_extracted = {'UV_1';'UV_2';'FLD1';'FLD2'};
number_detectors = size(Detectors_data_extracted,1);
MW_Samples = load(strcat(WorkingPath,'MW_Samples.dat'));
Intended_Peak_Number = size(MW_Samples,1);
Table_Diffusion_coefficient_at_Peak = zeros(Intended_Peak_Number,number_detectors);

fnames = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW_abbreviated2.txt'),'r');
fid_fns = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW_abbreviated.txt'),'r');
Sample_Names = cell(number_fns,1);
for n_sample = 1%:number_fns;
    filename = fgetl(fid_fns);filenamea = fgetl(fnames);
    Sample_Names{n_sample,1} = filenamea;
    Data_with_Diffusion_Coefficient = load(strcat(WorkingPath,'Data_with_Diffusion_Coefficient',filename,'.dat'));
    Data_with_Hydrodynamic_Diameter = load(strcat(WorkingPath,'Data_with_Hydrodynamic_Diameter',filename,'.dat'));
    for detectorr = 1:number_detectors;
        DC_and_data_Selected_Detectors = Data_with_Diffusion_Coefficient(:,(detectorr*2-1):(detectorr*2));% Column_of_time_HD_MW_and_data_Detectors = [1 2;3 4;5 6;7 8];%first two UV1, second UV2, third FLD1, fourth FLD2
        original_data = DC_and_data_Selected_Detectors;wherenan= abs(DC_and_data_Selected_Detectors-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        DC_and_data_Selected_Detectors = target_data;
        Diffusion_Coefficient = DC_and_data_Selected_Detectors(:,1);
        Signal = DC_and_data_Selected_Detectors(:,2);
        dH_and_data_Selected_Detectors = Data_with_Hydrodynamic_Diameter(:,(detectorr*2-1):(detectorr*2));% Column_of_time_HD_MW_and_data_Detectors = [1 2;3 4;5 6;7 8];%first two UV1, second UV2, third FLD1, fourth FLD2
        original_data = dH_and_data_Selected_Detectors;wherenan= abs(dH_and_data_Selected_Detectors-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        dH_and_data_Selected_Detectors = target_data;
        Hydrodynamic_Diameter = dH_and_data_Selected_Detectors(:,1);%Signal2 = dH_and_data_Selected_Detectors(:,2);
        Signal_cut = Signal (Hydrodynamic_Diameter < 50);
        [PKS,LOCS]= findpeaks(Signal_cut,'MINPEAKDISTANCE',50);  %50      % [PKS,LOCS]= findpeaks(Signal,'minpeakheight',Minpeakheight);% [PKS,LOCS]= findpeaks(Signal,'THRESHOLD',Minpeakheight);% Minpeakheight = min(Signal) + (max(Signal)-min(Signal))/7; %  Diffusion_Coefficient_peakS = imregionalmax(Signal)
        Hydrodynamic_Diameter(LOCS);  %This is for you to check whehther the peaks were found at right positions
        Diffusion_coefficient_at_Peaks = Diffusion_Coefficient(LOCS); 
        for nn = 1:size(Diffusion_coefficient_at_Peaks,1)
            Table_Diffusion_coefficient_at_Peak(nn,detectorr) = Diffusion_coefficient_at_Peaks(nn);
        end;
    end;
end;
fclose(fid_fns);
Table_Diffusion_coefficient_at_Peak(3:4,3) = Table_Diffusion_coefficient_at_Peak(3:4,4);  
save Table_Diffusion_coefficient_at_Peak.dat Table_Diffusion_coefficient_at_Peak -ascii -tabs;
fid_table = fopen('Table_Diffusion_coefficient_at_Peak.xls','wt');
fprintf(fid_table,'\t');
for detectorr = 1: size(Detectors_data_extracted,1);
    fprintf (fid_table,Detectors_data_extracted{detectorr});
    fprintf (fid_table,'\t');
end;
fprintf (fid_table,'\n');
fid_data = fopen('Table_Diffusion_coefficient_at_Peak.dat','r');
for n_sample = 1: size(Table_Diffusion_coefficient_at_Peak,1);
    fprintf (fid_table,'%s',num2str(MW_Samples(n_sample,1)));
    fprintf (fid_table,'\t');
    line = fgetl(fid_data);
    fprintf (fid_table,line);
    fprintf (fid_table,'\n');
end;
fclose(fid_data);
fclose(fid_table);