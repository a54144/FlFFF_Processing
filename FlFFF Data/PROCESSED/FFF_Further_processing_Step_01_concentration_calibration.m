%%% FFF_Further_processing_Step_01_concentration_calibration converts time
%%% into hydrodynamic diameters and molecular weights. In addition, in this
%%% step, molar weights (including peak molecular weights (Mp), number-averaged
%%% molecular weights (Mn),and weight-averaged molecular weights (Mw) are
%%% calculated and exported as Microsoft Excel files.

clear;
close all;

% Basic information loading
Volume_sample_loop_in_ml = load('C:\Matlab Processing\FlFFF Data\RAWDATA\Basic Info\Volume_sample_loop_in_ml.dat');
Volume_external_injection_loop_in_ml = load('C:\Matlab Processing\FlFFF Data\RAWDATA\Basic Info\Volume_external_injection_loop_in_ml.dat');
Concentration_calibration_read_in = load('C:\Matlab Processing\FlFFF Data\RAWDATA\Concentration Calibration\Slope_ppbQSE_Area_SENSITIVITY_COMPENSATED.dat');
Concentration_calibration_x_area_y_ug = (Concentration_calibration_read_in*Volume_external_injection_loop_in_ml)/1000;%divide 1000 is because there is 1000 ml in evety L
Color_in_letter = 'kgrb';
Tip_flow_rate_ml_per_min = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info\300Da_fall2014\Tip_flow_rate_ml_per_min.dat');
Transition_time_in_minute = load('C:\Matlab Processing\FlFFF Data\RAWDATA/Basic Info\300Da_fall2014\Transition_time_in_minute.dat');
Intervalintepolation = 0.005;%0.0005
Intervalintepolation_time = 0.005;
Detectors_data_extracted = {'UV_1';'UV_2';'FLD1';'FLD2'};
Detectors_for_file_name = {'UV1';'UV2';'FLD1';'FLD2'};
Detectors_for_plot = {'UV_2_5_4';'UV_3_5_5';'Fluo_3_5_0_/_4_5_0';'Fluo_2_7_5_/_3_4_0'}; 
CurrentPath = 'C:\Matlab Processing\FlFFF Data\PROCESSED\FinalData\';
WorkingPath = 'C:\Matlab Processing\FlFFF Data\TIMECALIBRATED\';
fnames = fopen(strcat(WorkingPath,'fns.txt'),'r');

% Get sample numbers
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
fsamplenames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
fconcentrationfactor = fopen(strcat(WorkingPath,'fns_concentrationfactor.txt'),'r');
MWp = zeros(Total_sample_number,size(Detectors_data_extracted,1));
Mn = zeros(Total_sample_number,size(Detectors_data_extracted,1));
Mw = zeros(Total_sample_number,size(Detectors_data_extracted,1));

for File_Names_id = 1:Total_sample_number;
    samplename = fgetl(fsamplenames);
    sampleconcentrationfactor = fgetl(fconcentrationfactor);
    Sample_Names{File_Names_id,1} = samplename;%filename(1:(length(filename)-4));
    Sample_CF(File_Names_id,1) = str2double(sampleconcentrationfactor);
    
    % Loading calibrated time.
    Data_with_Retention_Time = load(strcat(WorkingPath,'Data_with_Retention_Time',samplename,'.dat'));
    Data_with_Molecular_weight = load(strcat(WorkingPath,'Data_with_Molecular_weight',samplename,'.dat'));
    Data_with_Hydrodynamic_Diameter = load(strcat(WorkingPath,'Data_with_Hydrodynamic_Diameter',samplename,'.dat'));
    Measurement_Time = load(strcat(WorkingPath,'FFF_Measurement_time',samplename,'.dat'));
    Measurement_Time_with_Crossflow = Measurement_Time(1,1);
 
    for detectorr = 1:size(Detectors_data_extracted,1);
        RT_and_data_Selected_Detectors = Data_with_Retention_Time(:,(detectorr*2-1):(detectorr*2));
        % Column_of_time_HD_MW_and_data_Detectors = [1 2;3 4;5 6;7 8];%first two UV1, second UV2, third FLD1, fourth FLD2
        original_data = RT_and_data_Selected_Detectors;
        wherenan= abs(RT_and_data_Selected_Detectors-999999)<0.0001;
        wherenan_row = sum(wherenan')';
        which_row = find(wherenan_row>0);
        whereno = which_row;
        target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));
        row_original = 0;
        row_target = 0;
        for row = 1:size (target_data,1);
            row_target = row_target+1;row_original = row_original+1;
            for loop = 1:100;
                if find(row_original == whereno)>0;
                    row_original = row_original+1;
                end;
            end;
            target_data(row_target,:) = original_data(row_original,:);
        end;
        RT_and_data_Selected_Detectors = target_data;
        Retention_Time = RT_and_data_Selected_Detectors(:,1);
        Signal1 = RT_and_data_Selected_Detectors(:,2);
 
        HD_and_data_Selected_Detectors = Data_with_Hydrodynamic_Diameter(:,(detectorr*2-1):(detectorr*2));
        original_data = HD_and_data_Selected_Detectors;wherenan= abs(HD_and_data_Selected_Detectors-999999)<0.0001;
        wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);
        whereno = which_row;
        target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));
        row_original = 0;
        row_target = 0;for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;
            for loop = 1:100;
                if find(row_original == whereno)>0;
                    row_original = row_original+1;
                end;
            end;
            target_data(row_target,:) = original_data(row_original,:);
        end;
        HD_and_data_Selected_Detectors = target_data;
        Hydrodynamic_diameter = HD_and_data_Selected_Detectors(:,1);
        Signal2 = HD_and_data_Selected_Detectors(:,2);
 
        MW_and_data_Selected_Detectors = Data_with_Molecular_weight(:,(detectorr*2-1):(detectorr*2));
        original_data = MW_and_data_Selected_Detectors;wherenan= abs(MW_and_data_Selected_Detectors-999999)<0.0001;
        wherenan_row = sum(wherenan')';which_row = find(wherenan_row>0);
        whereno = which_row;
        target_data = zeros((size(original_data,1)-size(whereno,1)),size(original_data,2));
        row_original = 0;
        row_target = 0;
        for row = 1:size (target_data,1);row_target = row_target+1;row_original = row_original+1;
            for loop = 1:100;
                if find(row_original == whereno)>0;row_original = row_original+1;
                end;
            end;target_data(row_target,:) = original_data(row_original,:);
        end;
        MW_and_data_Selected_Detectors = target_data;
        Molecular_Weight = MW_and_data_Selected_Detectors(:,1);
        Signal3 = MW_and_data_Selected_Detectors(:,2);
        
        Signaldiff1 = Signal1-Signal2;
        Signaldiff2 = Signal1-Signal3;
        
        if sum(Signaldiff1) + sum(Signaldiff2)>0;
            disp('!!!Signal data in Data_with_Retention_Time.dat, Data_with_Molecular_weight.dat and Data_with_Hydrodynamic_Diameter.dat files do not match!!!');
            break;
        end;
      
        % Concentration Factor Corrected
        Signal = Signal1./Sample_CF(File_Names_id,1);     
        
        if (detectorr ==2);%(detectorr==1) 
            Baseline_Signal_point1 = min(Signal);
            Baseline_Retention_Time_point1 = Retention_Time(Signal==Baseline_Signal_point1);
            Baseline_Retention_Time_point1 = mean(Baseline_Retention_Time_point1);
            Baseline_Retention_Time_point2 = Measurement_Time_with_Crossflow*60; 
            Baseline_Signal_point2 = mean(Signal((Retention_Time > ((Measurement_Time_with_Crossflow-0.1)*60)) & (Retention_Time < ((Measurement_Time_with_Crossflow-0.05)*60))));
    %         Baseline_Signal_points = [Baseline_Signal_point1;Baseline_Signal_point2];
    %         Baseline_Retention_Time_points = [Baseline_Retention_Time_point1; Baseline_Retention_Time_point2];
    %         Baseline_interpolated = interp1(Baseline_Retention_Time_points, Baseline_Signal_points, Retention_Time);
    %         Baseline = Baseline_interpolated;
            baseline_slope=(Baseline_Signal_point2-Baseline_Signal_point1)/(Baseline_Retention_Time_point2-Baseline_Retention_Time_point1);
            baseline_intercept = Baseline_Signal_point1 - baseline_slope*Baseline_Retention_Time_point1;
              Baseline = Retention_Time .* baseline_slope + baseline_intercept;
        else
            Baseline = mean(Signal((Retention_Time > ((Measurement_Time_with_Crossflow-5)*60)) & (Retention_Time < ((Measurement_Time_with_Crossflow-0.1)*60))));
            % 20170723 revision: stretch retention time from 0.5 min to 5
            % mins
            %Baseline = mean(Signal((Retention_Time > ((Measurement_Time_with_Crossflow-0.5)*60)) & (Retention_Time < ((Measurement_Time_with_Crossflow-0.1)*60))));
        end;
        Signal = Signal - Baseline;
        % 20170723 revision: minus data removal
        Signal(Signal<0) = 0;
        
        %find Molecular weights peak point
        
        [Mwrow,Mwcol] = find(Signal == max(Signal));
        MWp(File_Names_id,detectorr) = MW_and_data_Selected_Detectors(Mwrow(1,1),1);
        
        %Calculate the Mn and Mw
        Molecular_Weight_less_than_10kDa = Molecular_Weight;
        Molecular_Weight_less_than_10kDa(Molecular_Weight_less_than_10kDa>10000)=0;
        Mn(File_Names_id,detectorr) = (Molecular_Weight_less_than_10kDa'*Signal)/sum(Signal);         
        Mw(File_Names_id,detectorr) = (Molecular_Weight_less_than_10kDa.*Molecular_Weight_less_than_10kDa)'*Signal/(Molecular_Weight_less_than_10kDa'*Signal);
        intercept = 0;
        slope = Concentration_calibration_x_area_y_ug(detectorr,1);
    %       Amount of quinine sulfate in small fragment of fractogram (ug): interval * signal * slope(interval*signal is area, for small interval, it's considered a square)
    %       from this amount, what would be the concentration?: amount of sample (in ug)/ volume within that interval (in ml)
    %     Retention_Time_interpolated = min(Retention_Time):Intervalintepolation_time:max(Retention_Time);
    %     Signal_interpolated = interp1(Retention_Time, Signal,Retention_Time_interpolated);
    %     Volume_within_Intervalintepolation_L = ((Intervalintepolation_time/60)*Tip_flow_rate_ml_per_min)/1000;
    %     Concentration  = (Intervalintepolation_time * Signal_interpolated * slope)/Volume_within_Intervalintepolation_L;
    %     Concentration  = (1 * Signal_interpolated * slope)/(( ( 1 / 60) * Tip_flow_rate_ml_per_min) / 1000);
    %     plot(Retention_Time_interpolated,Concentration,'color',Color_in_letter(detectorr),'linewidth',linewidth);
        Concentration  = (1 * Signal * slope)/(( ( 1 / 60) * Tip_flow_rate_ml_per_min) / 1000);
        
        Data_processed_tR = [Retention_Time Concentration];
        
        save Data_processed_tR.dat Data_processed_tR -ascii -tabs;
        fid_datatable = fopen(strcat(CurrentPath,'PROCESSED_FFF_Data_tR_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'),'wt');
        fiddata = fopen('Data_processed_tR.dat','r');
        for raw_datatable = 1:size(Data_processed_tR,1);
            line = fgetl(fiddata);
            fprintf(fid_datatable,line);
            fprintf(fid_datatable,'\n');
        end;
        fclose(fid_datatable);
        fclose(fiddata);
        
        
        Data_processed_dH = [Hydrodynamic_diameter Concentration];        
        save Data_processed_dH.dat Data_processed_dH -ascii -tabs;
        fid_datatable = fopen(strcat(CurrentPath,'PROCESSED_FFF_Data_dH_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'),'wt');
        fiddata = fopen('Data_processed_dH.dat','r');
        for raw_datatable = 1:size(Data_processed_dH,1);
            line = fgetl(fiddata);
            fprintf(fid_datatable,line);
            fprintf(fid_datatable,'\n');
        end;
        fclose(fid_datatable);
        fclose(fiddata);        
        
        Data_processed_MW = [Molecular_Weight Concentration];
        save Data_processed_MW.dat Data_processed_MW -ascii -tabs;
        fid_datatable = fopen(strcat(CurrentPath,'PROCESSED_FFF_Data_MW_',samplename,'_',Detectors_for_file_name{detectorr},'.dat'),'wt');
        fiddata = fopen('Data_processed_MW.dat','r');
        for raw_datatable = 1:size(Data_processed_MW,1);
            line = fgetl(fiddata);
            fprintf(fid_datatable,line);
            fprintf(fid_datatable,'\n');
        end;
        fclose(fid_datatable);
        fclose(fiddata); 
    end;
end;

% Calculate and write molecular weights peak information into xls
% files.

fid = fopen('MolecularWeightsPeak.xls','wt');
        fprintf(fid,'\t');
        for i = 1:size(Detectors_for_file_name,1);
            fprintf(fid,'%s',Detectors_for_file_name{i,1});fprintf(fid,'\t');
        end;
        fprintf(fid,'\n');
        fnames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        
        for i = 1:Total_sample_number
            samplename = fgetl(fnames);
            fprintf(fid,'%s',samplename);
             fprintf(fid,'\t');
            for k = 1: size(MWp,2)
                fprintf(fid,'%4.0f',MWp(i,k));
                fprintf(fid,'\t');
            end
            fprintf(fid,'\n');
        end;
        
        fclose(fid);
        fclose(fnames);    
        
        fid = fopen('MolecularWeightsWeightAveraged.xls','wt');
        fprintf(fid,'\t');
        for i = 1:size(Detectors_for_file_name,1);
            fprintf(fid,'%s',Detectors_for_file_name{i,1});fprintf(fid,'\t');
        end;
        fprintf(fid,'\n');
        fnames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        
        for i = 1:Total_sample_number
            samplename = fgetl(fnames);
            fprintf(fid,'%s',samplename);
             fprintf(fid,'\t');
            for k = 1: size(Mw,2)
                fprintf(fid,'%4.0f',Mw(i,k));
                fprintf(fid,'\t');
            end
            fprintf(fid,'\n');
        end;
        
        fclose(fid);
        fclose(fnames);    
        
        fid = fopen('MolecularWeightsNumberAveraged.xls','wt');
        fprintf(fid,'\t');
        for i = 1:size(Detectors_for_file_name,1);
            fprintf(fid,'%s',Detectors_for_file_name{i,1});fprintf(fid,'\t');
        end;
        fprintf(fid,'\n');
        fnames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        
        for i = 1:Total_sample_number
            samplename = fgetl(fnames);
            fprintf(fid,'%s',samplename);
             fprintf(fid,'\t');
            for k = 1: size(Mn,2)
                fprintf(fid,'%4.0f',Mn(i,k));
                fprintf(fid,'\t');
            end
            fprintf(fid,'\n');
        end;
        
        fclose(fid);
        fclose(fnames);    
%%       
PDI = Mw./Mn;
        fid = fopen('PDI.xls','wt');
        fprintf(fid,'\t');
        for i = 1:size(Detectors_for_file_name,1);
            fprintf(fid,'%s',Detectors_for_file_name{i,1});fprintf(fid,'\t');
        end;
        fprintf(fid,'\n');
        fnames = fopen(strcat(WorkingPath,'fns_Sample_Names.txt'),'r');
        
        for i = 1:Total_sample_number
            samplename = fgetl(fnames);
            fprintf(fid,'%s',samplename);
             fprintf(fid,'\t');
            for k = 1: size(PDI,2)
                fprintf(fid,'%4.2f',PDI(i,k));
                fprintf(fid,'\t');
            end
            fprintf(fid,'\n');
        end;
        
        fclose(fid);
        fclose(fnames);    