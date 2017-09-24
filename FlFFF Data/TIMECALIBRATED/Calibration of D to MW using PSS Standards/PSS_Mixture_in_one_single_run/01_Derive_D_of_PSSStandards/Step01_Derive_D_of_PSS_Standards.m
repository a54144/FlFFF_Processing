clear;
close all;
addpath('C:\Matlab Processing\FUNCTIONZHOU');
addpath('C:\Matlab Processing\FlFFF Data\RAWDATA\Basic Info\300Da_fall2014'); 
Transition_time_in_minute = load('C:\Matlab Processing\FlFFF Data\RAWDATA\Basic Info\300Da_fall2014\Transition_time_in_minute.dat');
Detectors_want_to_plot = {'UV_1';'UV_2';'FLD1';'FLD2'};
Detectors_want_to_plot_modified_names = {'UV_2_5_4';'UV_2_8_0';'FLD_3_5_0_/_4_5_0';'FLD_2_7_5_/_3_4_0'};Color_in_letter = 'kgrb';
General_Path = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of tR to D and dH using Protein Standards\';
tube_time_Path = 'Tube time/Average/';
WorkingPath = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\Calibration of D to MW using PSS Standards\PSS_Mixture_in_one_single_run\01_Derive_D_of_PSSStandards\';

Protein_Standard_Fitting_data = load(strcat(General_Path,'D_reciprocal_tR_Fitting_results.dat'));
t0_and_tR_protein_standards = load(strcat(General_Path,'tR_Tubetime_corrected_Transition_time_compensated_Unit_second.dat'));
Tube_Time_minute = load(strcat(General_Path,tube_time_Path,'Tube_Time_Selected_Detectors_average.dat'));


If_some_specific_sample_needs_signal_manipulation = 1;


T0corrected = t0_and_tR_protein_standards(1,:);
Pure_Tube_Time = Tube_Time_minute.*60;


slope = Protein_Standard_Fitting_data(1,:);
intercept = Protein_Standard_Fitting_data(2,:);
Planks_Cons = 1.38*10^(-23); %d = k*T/(3*pi*Viscosity*D)
Viscosity = 0.001003;%unit: m-1 s-1
Room_Temp = 20;%unit Degree Celsius; T = 273.15+room temp.

fnames = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW.txt'),'r');
counter_names = 0;while 1;line = fgetl(fnames);eof = feof(fnames);counter_names = counter_names + 1;if eof ==1;break;end;end;fclose(fnames);
Total_sample_number = counter_names; Sample_Names = cell(Total_sample_number,1);
fnames = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW.txt'),'r');
fsamplenames = fopen(strcat(WorkingPath,'FileNames_PSS_Standards_for_Calibration_of_D_to_MW_abbreviated.txt'),'r');

x_y_fontsize = 18;
gca_fontsize = 16;
legend_fontsize = 18;
linewidth = 2;
for File_Names_id = 1:Total_sample_number;
    filename = fgetl(fnames);
    samplename = fgetl(fsamplenames);Sample_Names{File_Names_id,1} = samplename;%filename(1:(length(filename)-4));



    Selected_Data = ZZ_FFF_Guo2013_UWM_Read_Selected_Detectors_UV_1_UV_2_FLD1_FLD2(filename);

    Sensitivity_Calculated = ZZ_FFF_Guo2013_UWM_Sensivity_Calculator_UV_1_UV_2_FLD1_FLD2(filename);
    fid_sen = fopen(strcat(WorkingPath,'Detectors_Sensitivity_UV1UV2FLD1FLD2',samplename,'.dat'),'wt');
    for row_sen = 1:size(Sensitivity_Calculated,1);
        fprintf(fid_sen,'%10.6f \t',Sensitivity_Calculated(row_sen,:));
        fprintf(fid_sen,'\n');
    end;
    fclose(fid_sen);
    

    FFF_Measurement_time = ZZ_FFF_UWM_Measurement_time_finder(filename);
    fid_mtime = fopen(strcat(WorkingPath,'FFF_Measurement_time',samplename,'.dat'),'wt');
    for row_mtime = 1:size(FFF_Measurement_time,1);
        fprintf(fid_mtime,'%10.6f \t',FFF_Measurement_time(row_mtime,:));
        fprintf(fid_mtime,'\n');
    end;
    fclose(fid_mtime);
    
    
    
    
    
    
    
    
%     save FFF_Measurement_time.dat FFF_Measurement_time -ascii -tabs;
    Measurement_Time_with_Crossflow = FFF_Measurement_time(1,1);%save Measurement_Time_with_Crossflow.dat Measurement_Time_with_Crossflow -ascii -tabs;
    Measurement_Time_without_Crossflow = FFF_Measurement_time(2,1) + FFF_Measurement_time(3,1);
    Total_Measurement_Time = Measurement_Time_with_Crossflow + Measurement_Time_without_Crossflow;

    time_in_minutes = Selected_Data(:,1);
    time_in_seconds = time_in_minutes.*60;

    Data_with_Retention_Time = 999999.*ones(size(Selected_Data,1),8);
    Data_with_Hydrodynamic_Diameter = 999999.*ones(size(Selected_Data,1),8);
    Data_with_Molecular_weight = 999999.*ones(size(Selected_Data,1),8);
    Data_with_Diffusion_Coefficient = 999999.*ones(size(Selected_Data,1),8);
    
    for detectorr = 1: size(Detectors_want_to_plot,1);

        time_measurement = time_in_seconds(time_in_seconds>(Transition_time_in_minute*60) & time_in_seconds <= ((Total_Measurement_Time+Transition_time_in_minute)*60));
        Data = Selected_Data(:,(1+detectorr));
        Data_measurement = Data(time_in_seconds>(Transition_time_in_minute*60) & time_in_seconds <= ((Total_Measurement_Time+Transition_time_in_minute)*60));% 1 minute is the transition time. The beginnning point of data collection was after focusing. 
        Time_tube_time_corrected = time_measurement - Pure_Tube_Time(1,detectorr) - (Transition_time_in_minute*60);% Transition_time_in_minute is the transition time.
        Time_tube_time_corrected = Time_tube_time_corrected(Time_tube_time_corrected>=0);
        Data_tube_time_corrected = Data_measurement (Time_tube_time_corrected>=0);
        guess = zeros(size(Time_tube_time_corrected ,1),100);
        for i_guess = 1:size(Time_tube_time_corrected ,1)
            guess(i_guess,1) = ((Time_tube_time_corrected(i_guess,1) - intercept(1,detectorr))/slope(1,detectorr))^(-1);
            for j_guess = 2:100;i = i_guess;j = j_guess;
                guess(i,j) = guess(i,(j-1))-((((Time_tube_time_corrected(i,1))*(coth(3*slope(1,detectorr)/(T0corrected(1,detectorr)*guess(i,(j-1))))))-(Time_tube_time_corrected(i,1)*T0corrected(1,detectorr)*guess(i,(j-1))/(3*slope(1,detectorr)))-(slope(1,detectorr)/guess(i,(j-1))))/((Time_tube_time_corrected(i,1)*(1-(coth(3*slope(1,detectorr)/(T0corrected(1,detectorr)*guess(i,(j-1)))))^2)*((-3)*slope(1,detectorr)/(T0corrected(1,detectorr)*(guess(i,(j-1)))^2)))-(T0corrected(1,detectorr)*Time_tube_time_corrected(i,1)/(3*slope(1,detectorr)))+(slope(1,detectorr)/((guess(i,(j-1)))^2))));
            end;
        end;
        Diff_Coe = guess (:,100);
        D_H = (Planks_Cons *(Room_Temp+273.15)*(10^9)/(3*pi*Viscosity))./Diff_Coe;
        k = 1000;while k>1;if(abs(D_H(k))>0.01);k = k-1;else number_1 = k+1;break;end;end;
        k = 1000;while k>1;if(abs(guess(k,70)-guess(k,69))<0.000000001);k = k-1;else number_2 = k+1;break;end;end;
        if number_1>=number_2;number_Selected_Detector = number_1;else number_Selected_Detector = number_2;end;

        Real_Retention_Time = Time_tube_time_corrected(number_Selected_Detector:size(Time_tube_time_corrected,1));
        Real_Diff_Coe = guess(number_Selected_Detector:size(Time_tube_time_corrected,1),100);
        Real_D_H = (Planks_Cons *(Room_Temp+273.15)*(10^9)/(3*pi*Viscosity))./Real_Diff_Coe;
        Real_W_M = 999999.*ones(size(Real_Diff_Coe));
        for i = 1:size(Real_D_H,1);
            Real_W_M(i) = 10^((log10(Real_Diff_Coe(i)^(-1))-8.363275506)/0.376487071);%10^((log10(Real_Diff_Coe(i)^(-1))-7.964594797)/0.525643121)
        end;
        Real_Data = Data_tube_time_corrected(number_Selected_Detector:size(Data_tube_time_corrected,1));

        if detectorr<=2;
            Real_Data = Real_Data.*Sensitivity_Calculated(detectorr,1);
        else
            Real_Data = Real_Data./Sensitivity_Calculated(detectorr,1);
        end;



        Data_with_Retention_Time(1:size(Real_Retention_Time,1),(detectorr*2-1):(detectorr*2)) = [Real_Retention_Time Real_Data];
        Data_with_Hydrodynamic_Diameter(1:size(Real_D_H,1),(detectorr*2-1):(detectorr*2)) = [Real_D_H Real_Data];
        Data_with_Molecular_weight(1:size(Real_W_M,1),(detectorr*2-1):(detectorr*2)) = [Real_W_M Real_Data];
        Data_with_Diffusion_Coefficient(1:size(Real_Diff_Coe,1),(detectorr*2-1):(detectorr*2)) = [Real_Diff_Coe Real_Data];
        
    end;
    
    
    
    save Data_with_Retention_Time.dat Data_with_Retention_Time -ascii -tabs;
    fid_datatime = fopen(strcat(WorkingPath,'Data_with_Retention_Time',samplename,'.dat'),'wt');
    fiddata = fopen('Data_with_Retention_Time.dat','r');
    for row_daratime = 1:size(Data_with_Retention_Time,1);
        line = fgetl(fiddata);
        fprintf(fid_datatime,line);
        fprintf(fid_datatime,'\n');
    end;
    fclose(fid_datatime);
    fclose(fiddata);
    
    if File_Names_id ==1;fid = fopen(strcat(WorkingPath,'Data_with_Retention_Time',samplename,'.xls'),'wt');for detectorr = 1: size(Detectors_want_to_plot,1);fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Retention Time (s)');fprintf (fid,'\t');fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Signal (V)');fprintf (fid,'\t');end;fprintf (fid,'\n');fiddata = fopen(strcat(WorkingPath,'Data_with_Retention_Time',samplename,'.dat'),'r');for i = 1: size(Data_with_Retention_Time,1);line = fgetl(fiddata);fprintf (fid,line);fprintf (fid,'\n');end;fclose(fid);fclose(fiddata);end;

    
    save Data_with_Hydrodynamic_Diameter.dat Data_with_Hydrodynamic_Diameter -ascii -tabs;
    fid_datahD = fopen(strcat(WorkingPath,'Data_with_Hydrodynamic_Diameter',samplename,'.dat'),'wt');
    fiddata = fopen('Data_with_Hydrodynamic_Diameter.dat','r');
    for row_datahD = 1:size(Data_with_Hydrodynamic_Diameter,1);
        line = fgetl(fiddata);
        fprintf(fid_datahD,line);
        fprintf(fid_datahD,'\n');
    end;
    fclose(fid_datahD);
    fclose(fiddata);
    if File_Names_id ==1;fid = fopen(strcat(WorkingPath,'Data_with_Hydrodynamic_Diameter',samplename,'.xls'),'wt');for detectorr = 1: size(Detectors_want_to_plot,1);fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Hydrodynamic Diameter (nm)');fprintf (fid,'\t');fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Signal (V)');fprintf (fid,'\t');end;fprintf (fid,'\n');fiddata = fopen(strcat(WorkingPath,'Data_with_Hydrodynamic_Diameter',samplename,'.dat'),'r'); for i = 1: size(Data_with_Hydrodynamic_Diameter,1);line = fgetl(fiddata);fprintf (fid,line);fprintf (fid,'\n');end;fclose(fid);fclose(fiddata);end;
     
    
    
    
    save Data_with_Molecular_weight.dat Data_with_Molecular_weight -ascii -tabs;
    fid_dataMW = fopen(strcat(WorkingPath,'Data_with_Molecular_weight',samplename,'.dat'),'wt');
    fiddata = fopen('Data_with_Molecular_weight.dat','r');
    for row_dataMW = 1:size(Data_with_Molecular_weight,1);
        line = fgetl(fiddata);
        fprintf(fid_dataMW,line);
        fprintf(fid_dataMW,'\n');
    end;
    fclose(fid_dataMW);
    fclose(fiddata);
    if File_Names_id ==1;fid = fopen(strcat(WorkingPath,'Data_with_Molecular_weight',samplename,'.xls'),'wt');for detectorr = 1: size(Detectors_want_to_plot,1);fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Molecular weight (Da)');fprintf (fid,'\t');fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Signal (V)');fprintf (fid,'\t');end;fprintf (fid,'\n');fiddata = fopen(strcat(WorkingPath,'Data_with_Molecular_weight',samplename,'.dat'),'r');for i = 1: size(Data_with_Molecular_weight,1);line = fgetl(fiddata);fprintf (fid,line);fprintf (fid,'\n');end;fclose(fid);fclose(fiddata);end;

    
    
    save Data_with_Diffusion_Coefficient.dat Data_with_Diffusion_Coefficient -ascii -tabs;
    fid_dataDC = fopen(strcat(WorkingPath,'Data_with_Diffusion_Coefficient',samplename,'.dat'),'wt');
    fiddata = fopen('Data_with_Diffusion_Coefficient.dat','r');
    for row_dataDC = 1:size(Data_with_Diffusion_Coefficient,1);
        line = fgetl(fiddata);
        fprintf(fid_dataDC,line);
        fprintf(fid_dataDC,'\n');
    end;
    fclose(fid_dataDC);
    fclose(fiddata);
    if File_Names_id ==1;fid = fopen(strcat(WorkingPath,'Data_with_Diffusion_Coefficient',samplename,'.xls'),'wt');for detectorr = 1: size(Detectors_want_to_plot,1);fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Diffusion Coefficient (m2/s)');fprintf (fid,'\t');fprintf (fid,Detectors_want_to_plot_modified_names{detectorr});fprintf (fid,' Signal (V)');fprintf (fid,'\t');end;fprintf (fid,'\n');fiddata = fopen(strcat(WorkingPath,'Data_with_Diffusion_Coefficient',samplename,'.dat'),'r');for i = 1: size(Data_with_Diffusion_Coefficient,1);line = fgetl(fiddata);fprintf (fid,line);fprintf (fid,'\n');end;fclose(fid);fclose(fiddata);end;
 
    
    
    

    
    
    
    h_figure = figure;
    for detectorr = 1: size(Detectors_want_to_plot,1);
        Data_pair = Data_with_Retention_Time(:,(detectorr*2-1):(detectorr*2));
        original_data = Data_pair;wherenan= abs(Data_pair-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        x = target_data(:,1);y = target_data(:,2);
        plot(x,y,'color',Color_in_letter(detectorr),'linewidth',linewidth);hold on;
    end;
    xlabel('Retention Time (s)','fontname','times','fontsize',x_y_fontsize);ylabel('Voltage','fontname','times','fontsize',x_y_fontsize);title(samplename,'fontname','times','fontsize',x_y_fontsize);
    legend(Detectors_want_to_plot_modified_names,'fontname','times','fontsize',legend_fontsize);
    set(gca,'fontname','times','fontsize',gca_fontsize);
    saveas (h_figure,[samplename,' with retention time'], 'pdf');
    close all;

    h_figure = figure;
    for detectorr = 1: size(Detectors_want_to_plot,1);
        Data_pair = Data_with_Hydrodynamic_Diameter(:,(detectorr*2-1):(detectorr*2));
        original_data = Data_pair;wherenan= abs(Data_pair-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        x = target_data(:,1);y = target_data(:,2);
        plot(x,y,'color',Color_in_letter(detectorr),'linewidth',linewidth);hold on;
    end;
    xlabel('Hydrodynamic Diameter (nm)','fontname','times','fontsize',x_y_fontsize);ylabel('Voltage','fontname','times','fontsize',x_y_fontsize);title(samplename,'fontname','times','fontsize',x_y_fontsize);
    legend(Detectors_want_to_plot_modified_names,'fontname','times','fontsize',legend_fontsize);
    set(gca,'fontname','times','fontsize',gca_fontsize);
    saveas (h_figure,[samplename,' with hydrodynamic diameter'], 'pdf');
    close all;

    h_figure = figure;
    for detectorr = 1: size(Detectors_want_to_plot,1);
        Data_pair = Data_with_Molecular_weight(:,(detectorr*2-1):(detectorr*2));
        original_data = Data_pair;wherenan= abs(Data_pair-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        x = target_data(:,1);y = target_data(:,2);
        plot(x,y,'color',Color_in_letter(detectorr),'linewidth',linewidth);hold on;
    end;
    xlabel('Molecular Weight (Da)','fontname','times','fontsize',x_y_fontsize);ylabel('Voltage','fontname','times','fontsize',x_y_fontsize);title(samplename,'fontname','times','fontsize',x_y_fontsize);
    legend(Detectors_want_to_plot_modified_names,'fontname','times','fontsize',legend_fontsize);
    set(gca,'fontname','times','fontsize',gca_fontsize);
    saveas (h_figure,[samplename,' with molecular weight'], 'pdf');
    close all;
    
    h_figure = figure;
    for detectorr = 1: size(Detectors_want_to_plot,1);
        Data_pair = Data_with_Diffusion_Coefficient(:,(detectorr*2-1):(detectorr*2));
        original_data = Data_pair;wherenan= abs(Data_pair-999999)<0.0001;wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);whereno = which_row;target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));row_original = 0;row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;for loop = 1:100;if find(row_original == whereno)>0;row_original = row_original+1;end;end;target_data(row_target,:) = original_data(row_original,:);end;
        x = target_data(:,1);y = target_data(:,2);
        plot(x,y,'color',Color_in_letter(detectorr),'linewidth',linewidth);hold on;
    end;
    xlabel('Diffusion_Coefficient(m^2/s)','fontname','times','fontsize',x_y_fontsize);ylabel('Voltage','fontname','times','fontsize',x_y_fontsize);title(samplename,'fontname','times','fontsize',x_y_fontsize);
    legend(Detectors_want_to_plot_modified_names,'fontname','times','fontsize',legend_fontsize);
    set(gca,'fontname','times','fontsize',gca_fontsize);
    saveas (h_figure,[samplename,' with diffusion coefficient'], 'pdf');
    close all;


end;
fclose(fnames);
fclose(fsamplenames);
close all;
