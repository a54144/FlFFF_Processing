% Pie charts compose
% Contributor: Hui Lin

%Basic parameters and variables
WorkingPath ='C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\';
SavingPath = 'C:\Matlab Processing\FlFFF Data\PROCESSED\';
subplot_number_in_a_figure = 4;
Size_segment_Name_Da = {...
'<1 kDa';
'0.3-5 kDa';
'5-100 kDa';
'100 kDa-0.7¦Ìm'};
Detectors_for_file_name = {'UV1';'UV2';'FLD1';'FLD2'};

%First Count how many files to calculate
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
        Size_Big_X_Label_22 = 28;
        Size_Big_Y_Label_22 = 24;
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
        Size_Big_X_Label_32 = 28;
        Size_Big_Y_Label_32 = 24;
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
for detectorr = 1:4
    fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
    Sampleno_count = subplot_number_in_a_figure;
    for File_Names_id = 1:Total_sample_number;         
        samplename = fgetl(fsamplenames);
        Sample_Names{File_Names_id,1} = samplename;
        Sampleno_count = Sampleno_count+1;
        if File_Names_id ==1
            Table_Concentration_in_intervals_Da = load(strcat(SavingPath,'Multiple samples - Table_Concentration_Combined_with_LMW_in_intervals_Da',samplename,'.dat'));
        end
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
                saveas (h_figure,['Multiple samples - Pie Charts of each size intervals _Combined_with_LMW_Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
%                 saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                saveas (h_figure,['Multiple samples - Pie Charts of each size intervals _Combined_with_LMW_Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
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
                        saveas (h_figure,['Multiple samples - Pie Charts of each size intervals Da _Combined_with_LMW',Detectors_for_file_name{detectorr},' ',sampleninfile,'.fig']);
%                         saveas (h_figure,['Multiple samples - Pie Chartss of each size intervals Da ',Detectors_for_file_name{detectorr},' ',sampleninfile,'.pdf']);
                        saveas (h_figure,['Multiple samples - Pie Chartss of each size intervals Da _Combined_with_LMW',Detectors_for_file_name{detectorr},' ',sampleninfile,'.jpg']);
                        close all;
                    end;  
            end
    end;
end;
