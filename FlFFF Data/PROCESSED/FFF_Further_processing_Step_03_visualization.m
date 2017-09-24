clear;
close all;
 
Plot_fractograms = 1;
Plot_integration_nm = 1;
Plot_integration_Da = 1; 
subplot_number_in_a_figure = 4;
addpath('C:\Matlab Processing\FUCTIONFROMOTHERS\xticklabel_rotate');
rot = 45;
CurrentPath ='C:\Matlab Processing\FlFFF Data\PROCESSED/FinalData/';
WorkingPath ='C:\Matlab Processing\FlFFF Data\TIMECALIBRATED/';
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
'100 kDa-0.7¦Ìm'};
 
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
 
 %% Plot fractograms
 
if Plot_fractograms ==1;
    
    if subplot_number_in_a_figure == 4;
        Subplot_Position_X_SouthWest_22 = 0.2;
        Subplot_Position_Y_SouthWest_22 = 0.12;
        Subplot_Position_Xaxis_length_22 = 0.32;
        Subplot_Position_Yaxis_length_22 = 0.32;
        Subplot_Position_Xaxis_gap_22 = 0.1;
        Subplot_Position_Yaxis_gap_22 = 0.1;
        Subplot_2_2_1_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_2_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_3_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_4_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_X_SouthWest = [Subplot_2_2_1_X_SouthWest;Subplot_2_2_2_X_SouthWest;Subplot_2_2_3_X_SouthWest;Subplot_2_2_4_X_SouthWest];
        Subplot_2_2_Y_SouthWest = [Subplot_2_2_1_Y_SouthWest;Subplot_2_2_2_Y_SouthWest;Subplot_2_2_3_Y_SouthWest;Subplot_2_2_4_Y_SouthWest];
        X_FontSize_22 = 22;
        Y_FontSize_22 = 22;
        Size_Big_X_Label_22 = 20;
        Size_Big_Y_Label_22 = 20;
        Size_Big_Title_22 = 30;
        markersize_22 = 12;
        gca_fontsize_22 = 12;
        gca_fontsize_integration_rot_plot_22 = 15;
        label_fontsize_22 = 15; title_fontsize_22 = 18;
        linewidth_22 = 2.5; 
        BarWidth_22 = 0.5;
        X_Label_Position_from_above = [0.0 -5.8 1.0001];
        Y_Label_Position_from_above = [-1.5 -4 1.0001];
        BarWidth = 0.5;
        gca_fontsize_integration_rot_plot = 10;
    end;
    if subplot_number_in_a_figure == 6;
        Subplot_Position_X_SouthWest_32 = 0.15;
        Subplot_Position_Y_SouthWest_32 = 0.12;
        Subplot_Position_Xaxis_length_32 = 0.295;
        Subplot_Position_Yaxis_length_32 = 0.22;
        Subplot_Position_Xaxis_gap_32 = 0.08;
        Subplot_Position_Yaxis_gap_32 = 0.09;
        Subplot_3_2_1_X_SouthWest = Subplot_Position_X_SouthWest_32;
        Subplot_3_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_2_X_SouthWest = Subplot_Position_X_SouthWest_32; 
        Subplot_3_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_3_X_SouthWest = Subplot_Position_X_SouthWest_32;
        Subplot_3_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_4_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32; 
        Subplot_3_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_5_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_5_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_6_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_6_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_X_SouthWest = [Subplot_3_2_1_X_SouthWest;...
            Subplot_3_2_2_X_SouthWest;...
            Subplot_3_2_3_X_SouthWest;...
            Subplot_3_2_4_X_SouthWest;...
            Subplot_3_2_5_X_SouthWest;...
            Subplot_3_2_6_X_SouthWest];
        Subplot_3_2_Y_SouthWest = [Subplot_3_2_1_Y_SouthWest;...
            Subplot_3_2_2_Y_SouthWest;...
            Subplot_3_2_3_Y_SouthWest;...
            Subplot_3_2_4_Y_SouthWest;...
            Subplot_3_2_5_Y_SouthWest;...
            Subplot_3_2_6_Y_SouthWest];
        X_FontSize_32 = 22;
        Y_FontSize_32 = 22;
        Size_Big_X_Label_32 = 20;
        Size_Big_Y_Label_32 = 20;
        Size_Big_Title_32 = 30;
        markersize_32=12; gca_fontsize_32 = 12;
        gca_fontsize_integration_rot_plot_32 = 15;
        label_fontsize_32 = 15;
        title_fontsize_32 = 11; 
        linewidth_32 = 2.5;
        BarWidth_32 = 0.5;
        X_Label_Position_from_above = [1.8 -4.7 1.0001];
        Y_Label_Position_from_above = [0.1 -2.6 1.0001];
        BarWidth = 0.5;
        gca_fontsize_integration_rot_plot = 10;
    end
    
    %% plot hydrodynamic diameter (nm)
    for detectorr = 1:size(Detectors_data_extracted,1);
        fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        Sampleno_count = subplot_number_in_a_figure;
        for File_Names_id = 1:Total_sample_number;
            samplename = fgetl(fsamplenames);
            %revision 20170723
            if File_Names_id ==1
                %Table_Concentration_in_intervals_Da = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',samplename,'.dat'));
                Table_Concentration_in_intervals_nm = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nm',samplename,'.dat'));
            end
            Sample_Names{File_Names_id,1} = samplename;
            Measurement_Time = load(strcat(WorkingPath,'FFF_Measurement_time',samplename,'.dat'));
            Measurement_Time_with_Crossflow = Measurement_Time(1,1);
            Measurement_Time_with_Crossflow = (Measurement_Time_with_Crossflow - Transition_time_in_minute)*60;
            Data_processed_dH = load(strcat(CurrentPath,'PROCESSED_FFF_Data_dH_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
            Data_processed_tR = load(strcat(CurrentPath,'PROCESSED_FFF_Data_tR_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
            %Data_processed_MW = load(strcat(CurrentPath,'PROCESSED_FFF_Data_MW_',samplename,'_',Detectors_for_file_name{detectorr},'.dat')); 
            
            Hydrodynamic_diameter = Data_processed_dH(:,1);
            Concentration_nm = Data_processed_dH(:,2);
            Retention_Time = Data_processed_tR(:,1);
            Measurement_dH_with_Crossflow =  mean(Hydrodynamic_diameter(abs(Retention_Time-Measurement_Time_with_Crossflow)<5)); 
            Sampleno_count = Sampleno_count+1;
            for sub_indi = 1:1:subplot_number_in_a_figure;
                if  abs((Sampleno_count-sub_indi)/subplot_number_in_a_figure - floor((Sampleno_count-sub_indi)/subplot_number_in_a_figure))<0.001;
                    if sub_indi == 1;
                        h_figure = figure;
                        sampleninfile = samplename;
                    end;
                    if subplot_number_in_a_figure ==6
                        hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi)...
                        Subplot_3_2_Y_SouthWest(sub_indi)...
                        Subplot_Position_Xaxis_length_32...
                        Subplot_Position_Yaxis_length_32]);
                    elseif subplot_number_in_a_figure ==4
                        hsubplot = subplot('position',[Subplot_2_2_X_SouthWest(sub_indi)...
                        Subplot_2_2_Y_SouthWest(sub_indi)...
                        Subplot_Position_Xaxis_length_22...
                        Subplot_Position_Yaxis_length_22]);
                    end
                    
                end;
            end;
            if subplot_number_in_a_figure ==6
                plot(Hydrodynamic_diameter,Concentration_nm,'color',Color_in_letter(detectorr),'linewidth',linewidth_32);  
                h_title = title(samplename,'fontsize',title_fontsize_32,'fontname','times');
                %%%%%%%%%%%%%%%%%%%%%%%%title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                set(gca,'fontsize',gca_fontsize_32,'fontname','times','xtick',[0:20:100],'xticklabel',{'0','20','40',' ','> 55',' '});%
                y_limm_01 = min(Concentration_nm)-(max(Concentration_nm)-min(Concentration_nm))/50;
                y_limm_02 = max(Concentration_nm)+(max(Concentration_nm)-min(Concentration_nm))/20;set(gca,'ylim',[y_limm_01 y_limm_02]);
                x_limm_01 = 0;x_limm_02 = max(Hydrodynamic_diameter)+(max(Hydrodynamic_diameter)-min(Hydrodynamic_diameter))/20;set(gca,'xlim',[x_limm_01 x_limm_02]);
                y_dotted_step = (y_limm_02 - y_limm_01)/100;y_dotted = y_limm_01:y_dotted_step:y_limm_02;x_dotted = Measurement_dH_with_Crossflow.*ones(size(y_dotted));hold on;
                plot(x_dotted,y_dotted,'color',Color_in_letter(detectorr),'linewidth',(linewidth_32/2),'linestyle','-.');hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_3_2_2_X_SouthWest+Subplot_Position_Xaxis_length_32*0.5)...
                        (Subplot_3_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_32*2)...
                        Subplot_Position_Xaxis_length_32-Subplot_Position_Xaxis_gap_32/2 Subplot_Position_Yaxis_gap_32/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Hydrodynamic diameter (nm)');
                    set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_32,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration (ppb-QSE)');
                    set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_32,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end;  
            elseif subplot_number_in_a_figure ==4
                plot(Hydrodynamic_diameter,Concentration_nm,'color',Color_in_letter(detectorr),'linewidth',linewidth_22);  
                h_title = title(samplename,'fontsize',title_fontsize_22,'fontname','times');
                %%%%%%%%%%%%%%%%%%%%%%%%title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                set(gca,'fontsize',gca_fontsize_22,'fontname','times','xtick',[0:20:100],'xticklabel',{'0','20','40',' ','> 55',' '});%
                y_limm_01 = min(Concentration_nm)-(max(Concentration_nm)-min(Concentration_nm))/50;
                y_limm_02 = max(Concentration_nm)+(max(Concentration_nm)-min(Concentration_nm))/20;
                set(gca,'ylim',[y_limm_01 y_limm_02]);
                x_limm_01 = 0;
                x_limm_02 = max(Hydrodynamic_diameter)+(max(Hydrodynamic_diameter)-min(Hydrodynamic_diameter))/20;
                set(gca,'xlim',[x_limm_01 x_limm_02]);
                y_dotted_step = (y_limm_02 - y_limm_01)/100;y_dotted = y_limm_01:y_dotted_step:y_limm_02;x_dotted = Measurement_dH_with_Crossflow.*ones(size(y_dotted));hold on;
                plot(x_dotted,y_dotted,'color',Color_in_letter(detectorr),'linewidth',(linewidth_22/2),'linestyle','-.');
                hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_2_2_2_X_SouthWest+Subplot_Position_Xaxis_length_22*0.5)...
                        (Subplot_2_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_22*2)...
                        Subplot_Position_Xaxis_length_22-Subplot_Position_Xaxis_gap_22/2 Subplot_Position_Yaxis_gap_22/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Hydrodynamic diameter (nm)');
                    set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_22,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration (ppb-QSE)');
                    set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_22,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Hydrodynamic diameter (nm) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end;   
            end
        end;
        fclose(fsamplenames);
    end;
end;

 %% plot fratogram Da 
 for detectorr = 1:1 %size(Detectors_data_extracted,1);
        fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        Sampleno_count = subplot_number_in_a_figure;
        for File_Names_id = 1:Total_sample_number;
            samplename = fgetl(fsamplenames);
            %revision 20170723
            if File_Names_id ==1
                Table_Concentration_in_intervals_Da = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',samplename,'.dat'));
                %Table_Concentration_in_intervals_nm = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nm',samplename,'.dat'));
            end
            Sample_Names{File_Names_id,1} = samplename;
            Measurement_Time = load(strcat(WorkingPath,'FFF_Measurement_time',samplename,'.dat'));
            Measurement_Time_with_Crossflow = Measurement_Time(1,1);
            Measurement_Time_with_Crossflow = (Measurement_Time_with_Crossflow - Transition_time_in_minute)*60;
            %Data_processed_dH = load(strcat(CurrentPath,'PROCESSED_FFF_Data_dH_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
            Data_processed_tR = load(strcat(CurrentPath,'PROCESSED_FFF_Data_tR_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'));
            Data_processed_MW = load(strcat(CurrentPath,'PROCESSED_FFF_Data_MW_',samplename,'_',Detectors_for_file_name{detectorr},'.dat')); 
            
            %Hydrodynamic_diameter = Data_processed_MW(:,1);
            Molecular_weights = Data_processed_MW(:,1);
            Concentration_Da = Data_processed_MW(:,2);
            Retention_Time = Data_processed_tR(:,1);
            Measurement_dH_with_Crossflow = mean(Molecular_weights(abs(Retention_Time-Measurement_Time_with_Crossflow)<5)); 
            Sampleno_count = Sampleno_count+1;
            for sub_indi = 1:1:subplot_number_in_a_figure;
                if  abs((Sampleno_count-sub_indi)/subplot_number_in_a_figure - floor((Sampleno_count-sub_indi)/subplot_number_in_a_figure))<0.001;
                    if sub_indi == 1;
                        h_figure = figure;
                        sampleninfile = samplename;
                    end;
%                     hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi)...
%                         Subplot_3_2_Y_SouthWest(sub_indi)...
%                         Subplot_Position_Xaxis_length_32...
%                         Subplot_Position_Yaxis_length_32]);
                    if subplot_number_in_a_figure ==6
                        hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi)...
                        Subplot_3_2_Y_SouthWest(sub_indi)...
                        Subplot_Position_Xaxis_length_32...
                        Subplot_Position_Yaxis_length_32]);
                    elseif subplot_number_in_a_figure ==4
                        hsubplot = subplot('position',[Subplot_2_2_X_SouthWest(sub_indi)...
                        Subplot_2_2_Y_SouthWest(sub_indi)...
                        Subplot_Position_Xaxis_length_22...
                        Subplot_Position_Yaxis_length_22]);
                    end
                end;
            end;
            if subplot_number_in_a_figure ==6
                plot(Molecular_weights,Concentration_Da,'color',Color_in_letter(detectorr),'linewidth',linewidth_32);  
                h_title = title(samplename,'fontsize',title_fontsize_32,'fontname','times');
                %%%%%%%%%%%%%%%%%%%%%%%%
                title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                %set(gca,'fontsize',gca_fontsize_32,'fontname','times','xtick',[0:20:100],'xticklabel',{'0','20','40',' ','> 55',' '});%
                y_limm_01 = min(Concentration_Da)-(max(Concentration_Da)-min(Concentration_Da))/50;
                y_limm_02 = max(Concentration_Da)+(max(Concentration_Da)-min(Concentration_Da))/20;
                set(gca,'ylim',[y_limm_01 y_limm_02]);
                x_limm_01 = 0;
                x_limm_02 = max(Molecular_weights)+(max(Molecular_weights)-min(Molecular_weights))/20;
                set(gca,'xlim',[x_limm_01 x_limm_02]);
                y_dotted_step = (y_limm_02 - y_limm_01)/100;
                y_dotted = y_limm_01:y_dotted_step:y_limm_02;
                x_dotted = Measurement_dH_with_Crossflow.*ones(size(y_dotted));
                hold on;
                plot(x_dotted,y_dotted,'color',Color_in_letter(detectorr),'linewidth',(linewidth_32/2),'linestyle','-.');hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_3_2_2_X_SouthWest+Subplot_Position_Xaxis_length_32*0.5)...
                        (Subplot_3_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_32*2)...
                        Subplot_Position_Xaxis_length_32-Subplot_Position_Xaxis_gap_32/2 Subplot_Position_Yaxis_gap_32/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Molecular weights(kDa)');set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_32,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration (ppb-QSE)');set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_32,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa)',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa)',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end;   
            elseif subplot_number_in_a_figure ==4
                plot(Molecular_weights,Concentration_Da,'color',Color_in_letter(detectorr),'linewidth',linewidth_22);  
                h_title = title(samplename,'fontsize',title_fontsize_22,'fontname','times');
                %%%%%%%%%%%%%%%%%%%%%%%%title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                %set(gca,'fontsize',gca_fontsize_22,'fontname','times','xtick',[0:20:100],'xticklabel',{'0','20','40',' ','> 55',' '});%
                y_limm_01 = min(Concentration_Da)-(max(Concentration_Da)-min(Concentration_Da))/50;
                y_limm_02 = max(Concentration_Da)+(max(Concentration_Da)-min(Concentration_Da))/20;
                set(gca,'ylim',[y_limm_01 y_limm_02]);
                x_limm_01 = 0;
                x_limm_02 = max(Molecular_weights)+(max(Molecular_weights)-min(Molecular_weights))/20;
                set(gca,'xlim',[x_limm_01 x_limm_02]);
                y_dotted_step = (y_limm_02 - y_limm_01)/100;
                y_dotted = y_limm_01:y_dotted_step:y_limm_02;
                x_dotted = Measurement_dH_with_Crossflow.*ones(size(y_dotted));
                hold on;
                plot(x_dotted,y_dotted,'color',Color_in_letter(detectorr),'linewidth',(linewidth_22/2),'linestyle','-.');hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_2_2_2_X_SouthWest+Subplot_Position_Xaxis_length_22*0.5)...
                        (Subplot_2_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_22*2)...
                        Subplot_Position_Xaxis_length_22-Subplot_Position_Xaxis_gap_22/2 Subplot_Position_Yaxis_gap_22/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Molecular weights(kDa)');set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_22,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration (ppb-QSE)');set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_22,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa)',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa) ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Molecular weights(kDa)',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end;   
        
            end 
               

        end;
        fclose(fsamplenames);
    end;

 
 %% Plot Da Integration chromatography 
if Plot_integration_Da == 1;
    %Table_Concentration_in_intervals = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_Da',sampleninfile,'.dat'));
    
    if subplot_number_in_a_figure == 4;
        Subplot_Position_X_SouthWest_22 = 0.08;
        Subplot_Position_Y_SouthWest_22 = 0.08;
        Subplot_Position_Xaxis_length_22 = 0.38;
        Subplot_Position_Yaxis_length_22 = 0.32;
        Subplot_Position_Xaxis_gap_22 = 0.05;
        Subplot_Position_Yaxis_gap_22 = 0.1;
        Subplot_2_2_1_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_2_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_3_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_4_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_X_SouthWest = [Subplot_2_2_1_X_SouthWest;Subplot_2_2_2_X_SouthWest;Subplot_2_2_3_X_SouthWest;Subplot_2_2_4_X_SouthWest];
        Subplot_2_2_Y_SouthWest = [Subplot_2_2_1_Y_SouthWest;Subplot_2_2_2_Y_SouthWest;Subplot_2_2_3_Y_SouthWest;Subplot_2_2_4_Y_SouthWest];
        X_FontSize_22 = 22;
        Y_FontSize_22 = 22;
        Size_Big_X_Label_22 = 20;
        Size_Big_Y_Label_22 = 20;
        Size_Big_Title_22 = 30;
        markersize_22=12; 
        gca_fontsize_22 = 12; 
        gca_fontsize_integration_rot_plot_22 = 15; 
        label_fontsize_22 = 15; 
        title_fontsize_22 = 18; 
        linewidth_22 = 2.5; 
        BarWidth_22 = 0.5;
        X_Label_Position_from_above = [-0.2 -5.8 1.0001];
        Y_Label_Position_from_above = [-1.3 -4 1.0001];
        gca_fontsize_integration_rot_plot = 10;
        BarWidth = 0.5;
    end;
    if subplot_number_in_a_figure == 6;
        Subplot_Position_X_SouthWest_32 = 0.2;      Subplot_Position_Y_SouthWest_32 = 0.08;
        Subplot_Position_Xaxis_length_32 = 0.39;      Subplot_Position_Yaxis_length_32 = 0.28;
        Subplot_Position_Xaxis_gap_32 = -0.05;       Subplot_Position_Yaxis_gap_32 = 0.02;
        Subplot_3_2_1_X_SouthWest = Subplot_Position_X_SouthWest_32;
        Subplot_3_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_2_X_SouthWest = Subplot_Position_X_SouthWest_32;     
        Subplot_3_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_3_X_SouthWest = Subplot_Position_X_SouthWest_32;    
        Subplot_3_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_4_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32; 
        Subplot_3_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_5_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_5_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_6_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_6_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_X_SouthWest = [Subplot_3_2_1_X_SouthWest;Subplot_3_2_2_X_SouthWest;...
            Subplot_3_2_3_X_SouthWest;Subplot_3_2_4_X_SouthWest;Subplot_3_2_5_X_SouthWest;Subplot_3_2_6_X_SouthWest];
        Subplot_3_2_Y_SouthWest = [Subplot_3_2_1_Y_SouthWest;Subplot_3_2_2_Y_SouthWest;...
            Subplot_3_2_3_Y_SouthWest;Subplot_3_2_4_Y_SouthWest;Subplot_3_2_5_Y_SouthWest;Subplot_3_2_6_Y_SouthWest];
        X_FontSize_32 = 22;
        Y_FontSize_32 = 22;
        Size_Big_X_Label_32 = 20;
        Size_Big_Y_Label_32 = 20;
        Size_Big_Title_32 = 30;
        markersize_32=12; gca_fontsize_32 = 12;
        gca_fontsize_integration_rot_plot_32 = 15;
        label_fontsize_32 = 15;
        title_fontsize_32 = 11;
        linewidth_32 = 2.5;
        BarWidth_32 = 0.5;
        X_Label_Position_from_above = [1 -24 1.0001];     
        Y_Label_Position_from_above = [0.1 -14 1.0001];
        gca_fontsize_integration_rot_plot = 10;
        BarWidth = 0.5;
    end
    % Plot pie charts.
    for detectorr = 1:size(Detectors_data_extracted,1);
        fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        Sampleno_count = subplot_number_in_a_figure;
        for File_Names_id = 1:Total_sample_number;
            samplename = fgetl(fsamplenames);
            Sample_Names{File_Names_id,1} = samplename;
            Sampleno_count = Sampleno_count+1;
            for sub_indi = 1:1:subplot_number_in_a_figure;
                if  abs((Sampleno_count-sub_indi)/subplot_number_in_a_figure - floor((Sampleno_count-sub_indi)/subplot_number_in_a_figure))<0.001;
                    if sub_indi == 1;h_figure = figure;sampleninfile = samplename;end;
                    if subplot_number_in_a_figure == 6
                        hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi) Subplot_3_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_32 Subplot_Position_Yaxis_length_32]);
                    elseif subplot_number_in_a_figure == 4
                        hsubplot = subplot('position',[Subplot_2_2_X_SouthWest(sub_indi) Subplot_2_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_22 Subplot_Position_Yaxis_length_22]);
                    end
                end;
            end;
                        
            Dataa = Table_Concentration_in_intervals_Da(File_Names_id,((detectorr-1)*size(Size_segment_Name_Da,1)+1):((detectorr)*size(Size_segment_Name_Da,1)));
           
            
            PortionPie= Dataa/sum(Dataa);%Portion calculation
            PercentagePie = num2str(PortionPie'*100,'%1.2f');%Pecentage calculation
            PercentagePie = [repmat(blanks(2),length(Dataa),1),PercentagePie,repmat('%',length(Dataa),1)];
            PercentagePie = cellstr(PercentagePie);
            Label=strcat(Size_segment_Name_Da,PercentagePie);
            pie(Dataa.*100,Label);
            
%             bar ((1:1:size(Size_segment_Name_Da,1)),Dataa,'FaceColor',Color_in_letter(detectorr),'BarWidth',BarWidth)
%             y_limm_01 = (max(Dataa)-min(Dataa))/50*(-1);
%             y_limm_02 = max(Dataa)+(max(Dataa)-min(Dataa))/20;
%             set(gca,'ylim',[y_limm_01 y_limm_02]);        
%             set(gca,'xLim',[0 8],'xtick',(1:1:size(Size_segment_Name_Da,1)),'XTickLabel',Size_segment_Name_Da,'fontsize',gca_fontsize_integration_rot_plot,'fontname','times');
            if subplot_number_in_a_figure == 6;
                h_title = title(samplename,'fontsize',title_fontsize_32,'fontname','times');
            else
                h_title = title(samplename,'fontsize',title_fontsize_22,'fontname','times');
            end
            %ylabel ('Concentration in size intervals (µg/L)','fontsize',label_fontsize,'fontname','times');% xlabel ('Size Intervals','fontsize',label_fontsize,'fontname','times');
            title_position = get(h_title, 'position');
            set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
%             XTickLabel=get(gca,'xTickLabel');
%             XTick = get(gca,'xTick');
%             xticklabel_rotate(XTick,rot,XTickLabel);
            hold on;
            if subplot_number_in_a_figure == 6
                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                    || (File_Names_id  == Total_sample_number)
                Position_axes = [(Subplot_3_2_2_X_SouthWest+Subplot_Position_Xaxis_length_32*0.8)...
                    (Subplot_3_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_32*2)...
                    Subplot_Position_Xaxis_length_32-Subplot_Position_Xaxis_gap_32/2 Subplot_Position_Yaxis_gap_32/2];
                axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
%                 h_xlabel = xlabel('Size Intervals');set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_32,'position',X_Label_Position_from_above);%
%                 h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_32,'position',Y_Label_Position_from_above); %
                saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
%                 saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                close all;
                end;  
            elseif subplot_number_in_a_figure == 4
                    if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                    || (File_Names_id  == Total_sample_number)
                        Position_axes = [(Subplot_2_2_2_X_SouthWest+Subplot_Position_Xaxis_length_22*0.8)...
                            (Subplot_2_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_22*2)...
                            Subplot_Position_Xaxis_length_22-Subplot_Position_Xaxis_gap_22/2 Subplot_Position_Yaxis_gap_22/2];
                        axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
%                         h_xlabel = xlabel('Size Intervals');
%                         set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_22,'position',X_Label_Position_from_above);%
%                         h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');
%                         set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_22,'position',Y_Label_Position_from_above); %
                        saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
%                         saveas (h_figure,['Multiple samples - Pie Chartss of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                        saveas (h_figure,['Multiple samples - Pie Chartss of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                        close all;
                    end;  
            end
            
 
        
        end;
        fclose(fsamplenames);
    end;
    
    %% Plot bar charts.
    for detectorr = 1:size(Detectors_data_extracted,1);
        fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        Sampleno_count = subplot_number_in_a_figure;
        for File_Names_id = 1:Total_sample_number;
            samplename = fgetl(fsamplenames);
            Sample_Names{File_Names_id,1} = samplename;
            Sampleno_count = Sampleno_count+1;
            for sub_indi = 1:1:subplot_number_in_a_figure;
                if  abs((Sampleno_count-sub_indi)/subplot_number_in_a_figure - floor((Sampleno_count-sub_indi)/subplot_number_in_a_figure))<0.001;
                    if sub_indi == 1;h_figure = figure;sampleninfile = samplename;end;
                    if subplot_number_in_a_figure == 6
                        hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi) Subplot_3_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_32 Subplot_Position_Yaxis_length_32]);
                    elseif subplot_number_in_a_figure == 4
                        hsubplot = subplot('position',[Subplot_2_2_X_SouthWest(sub_indi) Subplot_2_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_22 Subplot_Position_Yaxis_length_22]);
                    end
                end;
            end;
                        
            Dataa = Table_Concentration_in_intervals_Da(File_Names_id,((detectorr-1)*size(Size_segment_Name_Da,1)+1):((detectorr)*size(Size_segment_Name_Da,1)));
            bar ((1:1:size(Size_segment_Name_Da,1)),Dataa,'FaceColor',Color_in_letter(detectorr),'BarWidth',BarWidth)
            y_limm_01 = (max(Dataa)-min(Dataa))/50*(-1);
            y_limm_02 = max(Dataa)+(max(Dataa)-min(Dataa))/20;
            set(gca,'ylim',[y_limm_01 y_limm_02]);        
            set(gca,'xLim',[0 8],'xtick',(1:1:size(Size_segment_Name_Da,1)),'XTickLabel',Size_segment_Name_Da,'fontsize',gca_fontsize_integration_rot_plot,'fontname','times');
            if subplot_number_in_a_figure == 6;
                h_title = title(samplename,'fontsize',title_fontsize_32,'fontname','times');
            else
                h_title = title(samplename,'fontsize',title_fontsize_22,'fontname','times');
            end
            %ylabel ('Concentration in size intervals (µg/L)','fontsize',label_fontsize,'fontname','times');% xlabel ('Size Intervals','fontsize',label_fontsize,'fontname','times');
            title_position = get(h_title, 'position');
            set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
            XTickLabel=get(gca,'xTickLabel');
            XTick = get(gca,'xTick');
            xticklabel_rotate([],rot,[]);
            hold on;
            if subplot_number_in_a_figure == 6
                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                    || (File_Names_id  == Total_sample_number)
                Position_axes = [(Subplot_3_2_2_X_SouthWest+Subplot_Position_Xaxis_length_32*0.8)...
                    (Subplot_3_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_32*2)...
                    Subplot_Position_Xaxis_length_32-Subplot_Position_Xaxis_gap_32/2 Subplot_Position_Yaxis_gap_32/2];
                axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                h_xlabel = xlabel('Size Intervals');set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_32,'position',X_Label_Position_from_above);%
                h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_32,'position',Y_Label_Position_from_above); %
                saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                close all;
                end;  
            elseif subplot_number_in_a_figure == 4
                    if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                    || (File_Names_id  == Total_sample_number)
                        Position_axes = [(Subplot_2_2_2_X_SouthWest+Subplot_Position_Xaxis_length_22*0.8)...
                            (Subplot_2_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_22*2)...
                            Subplot_Position_Xaxis_length_22-Subplot_Position_Xaxis_gap_22/2 Subplot_Position_Yaxis_gap_22/2];
                        axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                        h_xlabel = xlabel('Size Intervals');
                        set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_22,'position',X_Label_Position_from_above);%
                        h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');
                        set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_22,'position',Y_Label_Position_from_above); %
                        saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                        saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                        saveas (h_figure,['Multiple samples - Integrations of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                        close all;
                    end;  
            end
            
 
        
        end;
        fclose(fsamplenames);
    end;
    
    close all;
     
end;

 %% Plot Hydrodynamic diameters integration figures
 
if Plot_integration_nm == 1;
    %Table_Concentration_in_intervals = load(strcat(SavingPath,'Multiple samples - Table_Concentration_in_intervals_nmMilwaukee River-02m-09182015-Ret','.dat'));
    subplot_number_in_a_figure = 4;
    if subplot_number_in_a_figure == 4;
        Subplot_Position_X_SouthWest_22 = 0.2;
        Subplot_Position_Y_SouthWest_22 = 0.12;
        Subplot_Position_Xaxis_length_22 = 0.38;
        Subplot_Position_Yaxis_length_22 = 0.32;
        Subplot_Position_Xaxis_gap_22 = 0.05;
        Subplot_Position_Yaxis_gap_22 = 0.1;
        Subplot_2_2_1_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_2_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*1;
        Subplot_2_2_3_X_SouthWest = Subplot_Position_X_SouthWest_22;
        Subplot_2_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_4_X_SouthWest = Subplot_Position_X_SouthWest_22 + Subplot_Position_Xaxis_length_22 + Subplot_Position_Xaxis_gap_22;
        Subplot_2_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_22 + (Subplot_Position_Yaxis_length_22 + Subplot_Position_Yaxis_gap_22)*0;
        Subplot_2_2_X_SouthWest = [Subplot_2_2_1_X_SouthWest;Subplot_2_2_2_X_SouthWest;Subplot_2_2_3_X_SouthWest;Subplot_2_2_4_X_SouthWest];
        Subplot_2_2_Y_SouthWest = [Subplot_2_2_1_Y_SouthWest;Subplot_2_2_2_Y_SouthWest;Subplot_2_2_3_Y_SouthWest;Subplot_2_2_4_Y_SouthWest];
        X_FontSize_22 = 22;
        Y_FontSize_22 = 22;
        Size_Big_X_Label_22 = 20;
        Size_Big_Y_Label_22 = 20;
        Size_Big_Title_22 = 30;
        markersize_22=12; 
        gca_fontsize_22 = 12; 
        gca_fontsize_integration_rot_plot_22 = 15; 
        label_fontsize_22 = 15; 
        title_fontsize_22 = 18; 
        linewidth_22 = 2.5; 
        BarWidth_22 = 0.5;
        X_Label_Position_from_above = [-0.2 -5.8 1.0001];
        Y_Label_Position_from_above = [-1.3 -4 1.0001];
    elseif subplot_number_in_a_figure == 6;
        Subplot_Position_X_SouthWest_32 = 0.2;      Subplot_Position_Y_SouthWest_32 = 0.08;
        Subplot_Position_Xaxis_length_32 = 0.39;      Subplot_Position_Yaxis_length_32 = 0.28;
        Subplot_Position_Xaxis_gap_32 = -0.05;       Subplot_Position_Yaxis_gap_32 = 0.02;
        Subplot_3_2_1_X_SouthWest = Subplot_Position_X_SouthWest_32;
        Subplot_3_2_1_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_2_X_SouthWest = Subplot_Position_X_SouthWest_32;     
        Subplot_3_2_2_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_3_X_SouthWest = Subplot_Position_X_SouthWest_32;    
        Subplot_3_2_3_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_4_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32; 
        Subplot_3_2_4_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*2;
        Subplot_3_2_5_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_5_Y_SouthWest = Subplot_Position_Y_SouthWest_32 + (Subplot_Position_Yaxis_length_32 + Subplot_Position_Yaxis_gap_32)*1;
        Subplot_3_2_6_X_SouthWest = Subplot_Position_X_SouthWest_32 + Subplot_Position_Xaxis_length_32 + Subplot_Position_Xaxis_gap_32;
        Subplot_3_2_6_Y_SouthWest = Subplot_Position_Y_SouthWest_32;
        Subplot_3_2_X_SouthWest = [Subplot_3_2_1_X_SouthWest;Subplot_3_2_2_X_SouthWest;...
            Subplot_3_2_3_X_SouthWest;Subplot_3_2_4_X_SouthWest;Subplot_3_2_5_X_SouthWest;Subplot_3_2_6_X_SouthWest];
        Subplot_3_2_Y_SouthWest = [Subplot_3_2_1_Y_SouthWest;Subplot_3_2_2_Y_SouthWest;...
            Subplot_3_2_3_Y_SouthWest;Subplot_3_2_4_Y_SouthWest;Subplot_3_2_5_Y_SouthWest;Subplot_3_2_6_Y_SouthWest];
        X_FontSize_32 = 22;Y_FontSize_32 = 22;
        Size_Big_X_Label_32 = 20;
        Size_Big_Y_Label_32 = 20;
        Size_Big_Title_32 = 30;
        markersize_32=12;
        gca_fontsize_32 = 12;
        gca_fontsize_integration_rot_plot_32 = 15;
        label_fontsize_32 = 15;
        title_fontsize_32 = 11;
        linewidth_32 = 2.5; BarWidth_32 = 0.5;
        X_Label_Position_from_above = [1 -24 1.0001];
        Y_Label_Position_from_above = [0.1 -14 1.0001];
        gca_fontsize_integration_rot_plot = 10;  BarWidth = 0.5;
    end
 
    for detectorr = 1:size(Detectors_data_extracted,1);
        fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        Sampleno_count = subplot_number_in_a_figure;
        for File_Names_id = 1:Total_sample_number;
            samplename = fgetl(fsamplenames);
            Sample_Names{File_Names_id,1} = samplename;
            Sampleno_count = Sampleno_count+1;
            for sub_indi = 1:1:subplot_number_in_a_figure;
                if  abs((Sampleno_count-sub_indi)/subplot_number_in_a_figure - floor((Sampleno_count-sub_indi)/subplot_number_in_a_figure))<0.001;
                    if sub_indi == 1;
                        h_figure = figure;
                        sampleninfile = samplename;
                    end;
                    if subplot_number_in_a_figure == 6;
                        hsubplot = subplot('position',[Subplot_3_2_X_SouthWest(sub_indi) Subplot_3_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_32 Subplot_Position_Yaxis_length_32]);
                    elseif subplot_number_in_a_figure == 4;
                        hsubplot = subplot('position',[Subplot_2_2_X_SouthWest(sub_indi) Subplot_2_2_Y_SouthWest(sub_indi) Subplot_Position_Xaxis_length_22 Subplot_Position_Yaxis_length_22]);
                    end;
                end
            end;
            if subplot_number_in_a_figure == 6;
                Dataa = Table_Concentration_in_intervals_nm(File_Names_id,((detectorr-1)*size(Size_segment_Name_nm,1)+1):((detectorr)*size(Size_segment_Name_nm,1)));
                bar ((1:1:size(Size_segment_Name_nm,1)),Dataa,'FaceColor',Color_in_letter(detectorr),'BarWidth',BarWidth)
                y_limm_01 = (max(Dataa)-min(Dataa))/50*(-1);y_limm_02 = max(Dataa)+(max(Dataa)-min(Dataa))/20;set(gca,'ylim',[y_limm_01 y_limm_02]);        
                set(gca,'xLim',[0 8],'xtick',(1:1:size(Size_segment_Name_nm,1)),'XTickLabel',Size_segment_Name_nm,'fontsize',gca_fontsize_integration_rot_plot,'fontname','times');

                h_title = title(samplename,'fontsize',title_fontsize_32,'fontname','times');
                %ylabel ('Concentration in size intervals (µg/L)','fontsize',label_fontsize,'fontname','times');% xlabel ('Size Intervals','fontsize',label_fontsize,'fontname','times');
                title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                XTickLabel=get(gca,'xTickLabel');
                XTick = get(gca,'xTick');
                xticklabel_rotate(XTick,rot,XTickLabel);
                hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_3_2_2_X_SouthWest+Subplot_Position_Xaxis_length_32*0.8)...
                        (Subplot_3_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_32*2)...
                        Subplot_Position_Xaxis_length_32-Subplot_Position_Xaxis_gap_32/2 Subplot_Position_Yaxis_gap_32/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Size Intervals');
                    set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_32,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');
                    set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_32,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end;   
            else if subplot_number_in_a_figure == 4;
                Dataa = Table_Concentration_in_intervals_nm(File_Names_id,((detectorr-1)*size(Size_segment_Name_nm,1)+1):((detectorr)*size(Size_segment_Name_nm,1)));
                bar ((1:1:size(Size_segment_Name_nm,1)),Dataa,'FaceColor',Color_in_letter(detectorr),'BarWidth',BarWidth)
                y_limm_01 = (max(Dataa)-min(Dataa))/50*(-1);y_limm_02 = max(Dataa)+(max(Dataa)-min(Dataa))/20;set(gca,'ylim',[y_limm_01 y_limm_02]);        
                set(gca,'xLim',[0 8],'xtick',(1:1:size(Size_segment_Name_nm,1)),'XTickLabel',Size_segment_Name_nm,'fontsize',gca_fontsize_integration_rot_plot,'fontname','times');

                h_title = title(samplename,'fontsize',title_fontsize_22,'fontname','times');
                %ylabel ('Concentration in size intervals (µg/L)','fontsize',label_fontsize,'fontname','times');% xlabel ('Size Intervals','fontsize',label_fontsize,'fontname','times');
                title_position = get(h_title, 'position');set(h_title,'position',[title_position(1) title_position(2)*0.95 title_position(3)]);
                XTickLabel=get(gca,'xTickLabel');
                XTick = get(gca,'xTick');
                xticklabel_rotate([],rot,[]);
                hold on;

                if  (abs((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure - floor((Sampleno_count-subplot_number_in_a_figure)/subplot_number_in_a_figure))<0.001)...
                        || (File_Names_id  == Total_sample_number)
                    Position_axes = [(Subplot_2_2_2_X_SouthWest+Subplot_Position_Xaxis_length_22*0.8)...
                        (Subplot_2_2_2_Y_SouthWest*2+Subplot_Position_Yaxis_length_22*2)...
                        Subplot_Position_Xaxis_length_22-Subplot_Position_Xaxis_gap_22/2 Subplot_Position_Yaxis_gap_22/2];
                    axes('Position',Position_axes);a = 1:0.1:2;b = sin(a);plot(a,b);
                    h_xlabel = xlabel('Size Intervals');
                    set(h_xlabel,'fontname','times','fontsize',Size_Big_X_Label_22,'position',X_Label_Position_from_above);%
                    h_ylabel = ylabel('Concentration in size intervals (ppb-QSE)');
                    set(h_ylabel,'fontname','times','fontsize',Size_Big_Y_Label_22,'position',Y_Label_Position_from_above); %
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
                    saveas (h_figure,['Multiple samples - Integrations of each size intervals nm ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                    close all;
                end
                end;   
                end
        end;
        fclose(fsamplenames);
    end;
    close all;
        
end;