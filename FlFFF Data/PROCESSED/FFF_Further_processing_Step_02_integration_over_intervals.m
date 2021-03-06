clear;

close all;
%addpath('C:\Matlab Processing\FUCTIONFROMOTHERS\xticklabel_rotate');rot = 45;
CurrentPath ='C:\Matlab Processing\FlFFF Data\PROCESSED\FinalData\';
WorkingPath ='C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\';
SavingPath = 'C:\Matlab Processing\FlFFF Data\PROCESSED\';
Volume_sample_loop_in_ml = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info/Volume_sample_loop_in_ml.dat');
Volume_external_injection_loop_in_ml = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info/Volume_external_injection_loop_in_ml.dat');
Concentration_calibration_read_in = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Concentration Calibration/Slope_ppbQSE_Area_SENSITIVITY_COMPENSATED.dat');
Concentration_calibration_x_area_y_ug = (Concentration_calibration_read_in*Volume_external_injection_loop_in_ml)/1000;%divide 1000 is because there is 1000 ml in evety L
Color_in_letter = 'kgrb';
Tip_flow_rate_ml_per_min = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info/300Da_fall2014/Tip_flow_rate_ml_per_min.dat');
Transition_time_in_minute = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info/300Da_fall2014/Transition_time_in_minute.dat');
Intervalintepolation = 0.005;%0.0005
Intervalintepolation_time = 0.005;
Detectors_data_extracted = {'UV_1';'UV_2';'FLD1';'FLD2'};
Detectors_for_file_name = {'UV1';'UV2';'FLD1';'FLD2'};
Detectors_for_plot = {'UV_2_5_4';'UV_3_5_5';'Fluo_3_5_0_/_4_5_0';'Fluo_2_7_5_/_3_4_0'};
Color_integration_segment = 'ygmrbck';
Marker_integration_segment ='h^v<>so';
Size_segment_Name_Da = {...
'<0.3 kDa';
'0.3-1 kDa';
'1-5 kDa';
'5-10 kDa';
'10-50 kDa';
'50-100 kDa';
'100 kDa-700nm'};
Size_segment_Name_nm = {... 
'0.5-4 nm';
'4-8 nm';
'8-25 nm';
'25-50 nm';
'50-55 nm';
'55-700 nm';
};
fnames = fopen(strcat(WorkingPath,'fns.txt'),'r');
counter_names = 0;
while 1;
    line = fgetl(fnames);
    eof = feof(fnames);
    if eof ==1;
        counter_names = counter_names + 1;
        break;
    else
        counter_names = counter_names + 1;
    end;
end;

fclose(fnames);
Total_sample_number = counter_names;
Sample_Names = cell(Total_sample_number,1);
Table_Concentration_in_intervals_Da = zeros(Total_sample_number,(size(Detectors_data_extracted,1)*size(Size_segment_Name_Da,1)));
Table_Concentration_in_intervals_nm = zeros(Total_sample_number,(size(Detectors_data_extracted,1)*size(Size_segment_Name_nm,1)));
 
for detectorr = 1:size(Detectors_data_extracted,1);
    fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
    for File_Names_id = 1:Total_sample_number;
        samplename = fgetl(fsamplenames);
        Sample_Names{File_Names_id,1} = samplename;
        if File_Names_id == 1;
            sampleninfile = samplename;
        end;
        Data_processed_dH = load(strcat(CurrentPath,'PROCESSED_FFF_Data_dH_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
        Data_processed_MW = load(strcat(CurrentPath,'PROCESSED_FFF_Data_MW_',samplename,'_',Detectors_for_file_name{detectorr},'.dat')); 
        Data_processed_tR = load(strcat(CurrentPath,'PROCESSED_FFF_Data_tR_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
        Hydrodynamic_diameter = Data_processed_dH(:,1);
        Retention_Time = Data_processed_tR(:,1);
        Molecular_Weight = Data_processed_MW(:,1);
        Concentration = Data_processed_MW(:,2);
        Size_segment_kDa = ...
            [0 0.3; 
            0.3 1; 
            1 5;
            5 10;
            10 50;
            50 100;
            100 (max(Data_processed_MW(:,1))/1000)];        
        Size_segment_Da = Size_segment_kDa .*1000;
        Size_segment_nm = ...
            [0.5 4;
            4 8;
            8 25;
            25 50;
            50 55;
            55 max(Data_processed_dH(:,1))];
        for segmement_ID = 1:size(Size_segment_Da,1)
            Range_start = Size_segment_Da(segmement_ID,1);
            Range_end = Size_segment_Da(segmement_ID,2);
            Concentration_segment = Concentration((Molecular_Weight>=Range_start) & (Molecular_Weight<Range_end));
            Retention_Time_segment = Retention_Time((Molecular_Weight>=Range_start) & (Molecular_Weight<Range_end));
            Retention_Time_segment_interpolated = min(Retention_Time_segment):Intervalintepolation:max(Retention_Time_segment);
            Concentration_segment_interpolated = interp1(Retention_Time_segment, Concentration_segment, Retention_Time_segment_interpolated);
            Integration_segment = sum(Concentration_segment_interpolated * Intervalintepolation);
            Concentration_segment = Integration_segment*Tip_flow_rate_ml_per_min/(Volume_sample_loop_in_ml*60);
            Table_Concentration_in_intervals_Da(File_Names_id,((detectorr-1)*size(Size_segment_Da,1)+segmement_ID)) = Concentration_segment;
        end;
        
        for segmement_ID = 1:size(Size_segment_nm,1)
            Range_start = Size_segment_nm(segmement_ID,1);
            Range_end = Size_segment_nm(segmement_ID,2);
            Concentration_segment = Concentration((Hydrodynamic_diameter >=Range_start) & (Hydrodynamic_diameter <Range_end));
            Retention_Time_segment = Retention_Time((Hydrodynamic_diameter >=Range_start) & (Hydrodynamic_diameter <Range_end));
            Retention_Time_segment_interpolated = min(Retention_Time_segment):Intervalintepolation:max(Retention_Time_segment);
            Concentration_segment_interpolated = interp1(Retention_Time_segment, Concentration_segment, Retention_Time_segment_interpolated);
            Integration_segment = sum(Concentration_segment_interpolated * Intervalintepolation);
            Concentration_segment = Integration_segment*Tip_flow_rate_ml_per_min/(Volume_sample_loop_in_ml*60);
            Table_Concentration_in_intervals_nm(File_Names_id,((detectorr-1)*size(Size_segment_nm,1)+segmement_ID)) = Concentration_segment;
        end;    
    end;
end;  

% fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
% samplename = fgetl(fsamplenames);
% sampleninfile = samplename;
fid_datatable = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',' ',sampleninfile,'.dat'),'wt');
for raw_datatable = 1:size(Table_Concentration_in_intervals_Da,1);
    fprintf(fid_datatable,'%20.10f \t',Table_Concentration_in_intervals_Da(raw_datatable,:));
    fprintf(fid_datatable,'\n');
end;
fclose(fid_datatable);
fid = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',' ',sampleninfile,'.xls'),'wt');
fprintf (fid,'\t');


% Size_segment_kDa = ...
%             [0 0.3; 
%             0.3 1; 
%             1 5;
%             5 10;
%             10 50;
%             50 100;
%             100 (max(Data_processed_MW(:,1))/1000)];        Size_segment_Da = Size_segment_kDa .*1000;
        
for detectorr = 1: size(Detectors_data_extracted,1);
    for segmement_ID = 0:1:size(Size_segment_Da,1);
        if segmement_ID <= 2;
            fprintf (fid,'\t');
        end;
        if segmement_ID == 3;
            fprintf (fid,Detectors_data_extracted{detectorr});
            fprintf (fid,' (��mol/L)');
        end;   
        if segmement_ID >= 4;
            fprintf (fid,'\t');
        end;
        
    end;
end;
fprintf (fid,'\n');
fprintf (fid,'\t');
for detectorr = 1: size(Detectors_data_extracted,1);
    for segmement_ID = 1:size(Size_segment_Da,1);
        fprintf (fid,Size_segment_Name_Da{segmement_ID});
        fprintf (fid,'\t');
    end;
end;
fprintf (fid,'\n');
 
fiddata = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',' ',sampleninfile,'.dat'),'r');
for i = 1: Total_sample_number;
    fprintf (fid,Sample_Names{i} );
    fprintf (fid,'\t');
    line = fgetl(fiddata);
    fprintf (fid,line);
    fprintf (fid,'\n');
end;
fclose(fid);
fclose(fiddata);
 
 
 
 
 
 
 
fid_nmtatable = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nm',' ',sampleninfile,'.dat'),'wt');
for raw_datatable = 1:size(Table_Concentration_in_intervals_nm,1);
    fprintf(fid_nmtatable,'%20.10f \t',Table_Concentration_in_intervals_nm(raw_datatable,:));
    fprintf(fid_nmtatable,'\n');
end;
fclose(fid_nmtatable);
fid = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nm',' ',sampleninfile,'.xls'),'wt');
fprintf (fid,'\t');
for detectorr = 1: size(Detectors_data_extracted ,1);
    for segmement_ID = 1:1:size(Size_segment_nm,1);
            fprintf (fid,Detectors_data_extracted {detectorr});
            fprintf (fid,' (��mol/L)');
            fprintf (fid,'\t');
    end;
end;
% % % for detectorr = 1: size(Detectors_data_extracted ,1);
% % %     for segmement_ID = 0:1:size(Size_segment_nm,1);
% % %         if segmement_ID <= 2;
% % %             fprintf (fid,'\t');
% % %         end;
% % %         if segmement_ID == 3;
% % %             fprintf (fid,Detectors_data_extracted {detectorr});
% % %             fprintf (fid,' (�g/L)');
% % %         end;   
% % %         if segmement_ID >= 4;
% % %             fprintf (fid,'\t');
% % %         end;
% % %         
% % %     end;
% % % end;
fprintf (fid,'\n');
fprintf (fid,'\t');
for detectorr = 1: size(Detectors_data_extracted ,1);
    for segmement_ID = 1:size(Size_segment_nm,1);
        fprintf (fid,Size_segment_Name_nm{segmement_ID});
        fprintf (fid,'\t');
    end;
end;
fprintf (fid,'\n');
 
fiddata = fopen(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nm',' ',sampleninfile,'.dat'),'r');
for i = 1: Total_sample_number;
    fprintf (fid,Sample_Names{i} );
    fprintf (fid,'\t');
    line = fgetl(fiddata);
    fprintf (fid,line);
    fprintf (fid,'\n');
end;
fclose(fid);
fclose(fiddata);

