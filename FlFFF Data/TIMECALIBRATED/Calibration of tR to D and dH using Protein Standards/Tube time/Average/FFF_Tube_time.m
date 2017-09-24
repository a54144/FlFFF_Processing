clear;
close all;
addpath('C:\Matlab Processing\FUNCTIONZHOU');
addpath('C:\Matlab Processing\FUNCTIONZHOU\'); 
WorkingPath = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of tR to D and dH using Protein Standards\Tube time\Average\';
%-----------------------************************-----------------------
%These two lines are also in the function
%'ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2'
%I post them here for better clearance
Detectors_want_to_plot = {'UV_1';'UV_2';'FLD1';'FLD2'};
%End of commands already in the function
%'ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2'
%----------------------------------------------------------------------

Plot_Selected_Detectors = 1;
fnames = fopen(strcat(WorkingPath,'fns.txt'),'r');counter_names = 0;while 1;line = fgetl(fnames);eof = feof(fnames);counter_names = counter_names + 1;if eof ==1;break;end;end;fclose(fnames);
Total_run_number = counter_names;
Tube_Time_Selected_Detectors = zeros(counter_names,size(Detectors_want_to_plot,1));


fnames = fopen(strcat(WorkingPath,'fns.txt'),'r');



Time_baseline_in_minute = [...
0.01 0.05;%1 3;    
0.01 0.05;%1 3;     
0.01 0.05;%1 3;    
0.01 0.05;%1 3;    
];





%     0.2 0.5;
%      0.2 0.5;%0.01 0.02;
%     4.7 4.71;
%      0.2 0.5;];%0.01 0.02;];




for File_Names_id = 1:counter_names;
    filename = fgetl(fnames);
%     filename = 'Tube Time_PSS_1point6kDa_750mgL_55mM_12162013_01.dat';
    Selected_Data = ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2(filename);
    time_in_minutes_col_id = 1;
    time_in_minutes = Selected_Data(:,time_in_minutes_col_id);

    if Plot_Selected_Detectors == 1;
        %-----------------------************************-----------------------
        %Modify the detector names, define color, and plot data
        Detectors_want_to_plot_modified_names = {'UV_2_5_4';'UV_2_8_0';'FLD_3_5_0_/_4_5_0';'FLD_2_7_5_/_3_4_0'};
        Color_in_letter = 'kgrb';
        h_figure = figure;
        for detectorr = 1: size(Detectors_want_to_plot,1);
            plot(time_in_minutes,Selected_Data(:,(1+detectorr)),'color',Color_in_letter(detectorr));
            hold on;
        end;
        %     legend(Detectors_want_to_plot);
        legend(Detectors_want_to_plot_modified_names);
    %     saveas(h_figure,[filename(1:length(filename)-4),'_UV_1_UV_2_FLD1_FLD2'],'pdf');
        saveas(h_figure,filename(1:length(filename)-4),'pdf');
        close all;
        %End of Modifying etector names, defining color, and plotting data
        %----------------------------------------------------------------------
    end;

    for detectorr = 1: size(Detectors_want_to_plot,1);
        Data = Selected_Data(:,(1+detectorr));  
        time = time_in_minutes;
        time_of_peak = time_in_minutes(Data == max(Data));
        baseline = mean( Data(time >= Time_baseline_in_minute(Total_run_number,1) & time <= Time_baseline_in_minute(Total_run_number,2)));
        Real_Data = Data - baseline;
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
        
        Tube_Time_Selected_Detectors(File_Names_id,detectorr) =  Tubetime;
    end;
end;
fclose(fnames);

Tube_Time_Selected_Detectors_average = zeros(1,size(Detectors_want_to_plot,1));
for columnn = 1:size(Tube_Time_Selected_Detectors,2);
    Tube_Time_Selected_Detectors_average(1,columnn) = mean(Tube_Time_Selected_Detectors(1:Total_run_number,columnn));
end;

save Tube_Time_Selected_Detectors.dat Tube_Time_Selected_Detectors -ascii -tabs;
save Tube_Time_Selected_Detectors_average.dat Tube_Time_Selected_Detectors_average -ascii -tabs;

fid_Tube_Time = fopen('Tube_Time_Selected_Detectors.xls','wt');
fprintf (fid_Tube_Time,'\t');
for detectorr = 1: size(Detectors_want_to_plot,1);
    fprintf (fid_Tube_Time,Detectors_want_to_plot{detectorr});
    fprintf (fid_Tube_Time,'\t');
end;
fprintf (fid_Tube_Time,'\n');

fnames = fopen('fns.txt','r');
fid = fopen('Tube_Time_Selected_Detectors.dat','r');
for File_Names_id = 1:counter_names;
    filename = fgetl(fnames);
    fprintf (fid_Tube_Time,filename);
    fprintf (fid_Tube_Time,'\t');
    line = fgetl(fid);
    fprintf (fid_Tube_Time,line);
    fprintf (fid_Tube_Time,'\n');
end;

fclose(fid_Tube_Time);
fclose(fnames);
fclose(fid);



fid_Tube_Time = fopen('Tube_Time_Selected_Detectors_average.xls','wt');
for detectorr = 1: size(Detectors_want_to_plot,1);
    fprintf (fid_Tube_Time,Detectors_want_to_plot{detectorr});
    fprintf (fid_Tube_Time,'\t');
end;
fprintf (fid_Tube_Time,'\n');
fid = fopen('Tube_Time_Selected_Detectors_average.dat','r');
line = fgetl(fid);
fprintf (fid_Tube_Time,line);
fclose(fid_Tube_Time);
fclose(fid);
