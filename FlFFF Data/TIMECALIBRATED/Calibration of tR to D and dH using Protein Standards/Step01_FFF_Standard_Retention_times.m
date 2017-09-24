clear;
clc;
close all;


t0_Time_baseline_in_minute = [0.53 0.55];

Percentage_t0_data_used = 1/15;

Transition_time_in_minutes = 0.5;

Plot_Selected_Detectors = 1;

Special_Treat_for_Finding_Maximum_Intensity = 0;

addpath('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU');
addpath('/Users/zhengzhenzhouyeah/study/GUO/FFF/RAWDATA/UWM/300Da/20140910'); 
WorkingPath = '/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of tR to D and dH using Protein Standards/';
Tube_Time = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of tR to D and dH using Protein Standards/Tube time/Average/Tube_Time_Selected_Detectors_average.dat');

%-----------------------************************-----------------------
%These two lines are also in the function
%'ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2'
%I post them here for better clearance
Detectors_want_to_plot = {'UV_1';'UV_2';'FLD1';'FLD2'};
%End of commands already in the function
%'ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2'
%----------------------------------------------------------------------
Detectors_want_to_plot_modified_names = {'UV_2_5_4';'UV_2_8_0';'FLD_3_5_0_/_4_5_0';'FLD_2_7_5_/_3_4_0'};
Color_in_letter = 'kgrb';


fnames = fopen(strcat(WorkingPath,'FileNames_Protein_Standards_for_Calibration_of_tR_to_dH.txt'),'r');counter_names = 0;while 1;line = fgetl(fnames);eof = feof(fnames);counter_names = counter_names + 1;if eof ==1;break;end;end;fclose(fnames);
Total_protein_standard_number = counter_names;
fnames = fopen(strcat(WorkingPath,'FileNames_Protein_Standards_for_Calibration_of_tR_to_dH.txt'),'r');
Protein_Standard_Names = cell(Total_protein_standard_number,1);
tR_Selected_Detectors = zeros(Total_protein_standard_number,size(Detectors_want_to_plot,1));

for File_Names_id = 1:Total_protein_standard_number;
    
    filename = fgetl(fnames);
    Protein_Standard_Names{File_Names_id,1} = filename(1:(length(filename)-4));
%     Selected_Data = ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2(strcat(Raw_Data_Path,filename));
    Selected_Data = ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2(filename);
    time_in_minutes_col_id = 1;
    time_in_minutes = Selected_Data(:,time_in_minutes_col_id);


    %-----------------------************************-----------------------
    %     t0
    if File_Names_id == 1;
        wanted_data_length = floor(size(Selected_Data,1)*Percentage_t0_data_used);
        Selected_Data = Selected_Data(1: wanted_data_length,:);
        time_in_minutes = time_in_minutes(1: wanted_data_length,:);
        if Plot_Selected_Detectors == 1;
            h_figure = figure;
            for detectorr = 1: size(Detectors_want_to_plot,1);
                plot(time_in_minutes,Selected_Data(:,(1+detectorr)),'color',Color_in_letter(detectorr));
                hold on;
            end;
            legend(Detectors_want_to_plot_modified_names);%legend(Detectors_want_to_plot);
            saveas(h_figure,strcat('T0 with ',filename(1:length(filename)-4)),'pdf');
            close all;
        end;

        for detectorr = 1: size(Detectors_want_to_plot,1);
            Data = Selected_Data(:,(1+detectorr));
            time = time_in_minutes;
            time_of_peak = time_in_minutes(Data == max(Data));
            baseline = mean( Data(time >= t0_Time_baseline_in_minute (1,1) & time <= t0_Time_baseline_in_minute (1,2)));
            Real_Data = Data - baseline;
            time_in_minutes_tubetime_subtracted = time_in_minutes - Tube_Time (1,detectorr);
            time_in_minutes_tubetime_subtracted_2 = time_in_minutes_tubetime_subtracted(time_in_minutes_tubetime_subtracted>=0);
            Real_Data_tubetime_subtracted = Real_Data(time_in_minutes_tubetime_subtracted>=0);
            
            Real_Data = Real_Data_tubetime_subtracted;
            time_in_minutes = time_in_minutes_tubetime_subtracted_2;
            
            N_of_peak = find(Real_Data == max(Real_Data));
            N = 0;
            for j = 1:N_of_peak;
                if Real_Data(j)<=0.86* max(Real_Data)
                    N = N+1;
                end;
            end;
            if abs(Real_Data(N)-0.86* max(Real_Data)) > abs(Real_Data(N+1)-0.86* max(Real_Data))
                N = N+1;
            end;
            time_of_86percent_peak = time_in_minutes(N);
            Tubetime = 1.5* time_of_86percent_peak;
            tR_Selected_Detectors(File_Names_id,detectorr) =  Tubetime;
        end;
    end;
    %----------------------------------------------------------------------
    
    
    %-----------------------************************-----------------------
    %     Protein standards
    if File_Names_id > 1;
    
        if Plot_Selected_Detectors == 1;
            h_figure = figure;
            for detectorr = 1: size(Detectors_want_to_plot,1);
                plot(time_in_minutes,Selected_Data(:,(1+detectorr)),'color',Color_in_letter(detectorr));
                hold on;
            end;
            legend(Detectors_want_to_plot_modified_names);%legend(Detectors_want_to_plot);
            saveas(h_figure,filename(1:length(filename)-4),'pdf');
            close all;
        end;
        %-----------------------************************-------------------
        %Finding Maximum of data for all the four detectors.
        for detectorr = 1: size(Detectors_want_to_plot,1);
            Data = Selected_Data(:,(1+detectorr));
            %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!        
            Data2 = Data (time_in_minutes < 20);

            tR = time_in_minutes(Data==max(Data2));
            tR = min(tR);
            %         tR = time_in_minutes(Data==max(Data));
            %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if Special_Treat_for_Finding_Maximum_Intensity ==1;
                if detectorr ==3;
                    Data_range = Data(time_in_minutes>3.39 & time_in_minutes<10);
                    Max_in_Data_range = max(Data_range);
                    tR = time_in_minutes(Data==Max_in_Data_range);
                    %!!!Note that there was more than one time that the 
                    %intensity was at maximum
                    tR = max(tR);
                    %!!!Note that there was more than one time that the 
                    %intensity was at maximum
                end;
            end;
            tR = mean(tR);
            tR_Selected_Detectors(File_Names_id,detectorr) = tR;
        end;
        %------------------------------------------------------------------
    end;
    %----------------------------------------------------------------------
end;
fclose(fnames);

save tR_Selected_Detectors.dat tR_Selected_Detectors -ascii -tabs;
fid_tR = fopen('tR_Selected_Detectors.xls','wt');
fprintf (fid_tR,'\t');
for detectorr = 1: size(Detectors_want_to_plot,1);
    fprintf (fid_tR,Detectors_want_to_plot{detectorr});
    fprintf (fid_tR,'\t');
end;
fprintf (fid_tR,'\n');
fid = fopen('tR_Selected_Detectors.dat','r');
for i = 1:Total_protein_standard_number;
    fprintf (fid_tR,Protein_Standard_Names{i});
    fprintf (fid_tR,'\t');
    line = fgetl(fid);
    fprintf (fid_tR,line);
    fprintf (fid_tR,'\n');
end;
fclose(fid_tR);
fclose(fid);


% Tube_Time = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/TIMECALIBRATED/UWM/300Da/Calibration of tR to dH using Protein Standards/Tube time/Average/Tube_Time_Selected_Detectors_average.dat');
Tube_Time_matrix = zeros(Total_protein_standard_number,size(Tube_Time,2));% Basically just expand the Tube time array to the same size as tR matrix
for i = 2:Total_protein_standard_number
    Tube_Time_matrix(i,:) = Tube_Time;
end;

tR_Tubetime_corrected_Selected_Detectors = tR_Selected_Detectors - Tube_Time_matrix ;

tR_Tubetime_corr_Transition_time_NOT_compensated_Unit_minute = tR_Tubetime_corrected_Selected_Detectors;
tR_Tubetime_corrected_Transition_time_compensated_Unit_minute = tR_Tubetime_corr_Transition_time_NOT_compensated_Unit_minute - Transition_time_in_minutes; % Transition_time_in_minutes is the transition time. The beginnning point of data collection was after focusing.
tR_Tubetime_corrected_Transition_time_compensated_Unit_second = tR_Tubetime_corrected_Transition_time_compensated_Unit_minute.*60; % unit switch from minute to second.

save tR_Tubetime_corrected_Transition_time_compensated_Unit_second.dat tR_Tubetime_corrected_Transition_time_compensated_Unit_second -ascii -tabs;
fid_tR_tube = fopen('tR_Tubetime_corrected_Transition_time_compensated_Unit_second.xls','wt');
fprintf (fid_tR_tube ,'\t');
for detectorr = 1: size(Detectors_want_to_plot,1);
    fprintf (fid_tR_tube,Detectors_want_to_plot{detectorr});
    fprintf (fid_tR_tube,'\t');
end;
fprintf (fid_tR_tube,'\n');
fid = fopen('tR_Tubetime_corrected_Transition_time_compensated_Unit_second.dat','r');
for i = 1:Total_protein_standard_number;
    fprintf (fid_tR_tube,Protein_Standard_Names{i});
    fprintf (fid_tR_tube,'\t');
    line = fgetl(fid);
    fprintf (fid_tR_tube,line);
    fprintf (fid_tR_tube,'\n');
end;
fclose(fid_tR_tube);
fclose(fid);