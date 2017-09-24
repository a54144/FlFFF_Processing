function FFF_Time_in_minutes_and_Data_Selected_Detectors = ZZ_FFF_Guo2013_UWM_Read_Selected_Detector_UV254_UV355_FLD1_FLD2(filename)

Detectors_want_to_plot = {'UV254';'UV355';'FLD1';'FLD2'};

Row_Detector_Number = zeros(size(Detectors_want_to_plot,1),1);
Detector_Number = zeros(size(Detectors_want_to_plot,1),1);
Detector_Column = zeros(size(Detectors_want_to_plot,1),1);

time_in_minutes_col_id = 1;

fid_datafile = fopen(filename,'r');
fid_pure_data_raw = fopen('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU/Pure_FFF_data_raw.dat','wt');
counter_Lines_in_File = 0;
Line_beginning_data = 999999;
while 1
    line = fgetl(fid_datafile);
    eof = feof(fid_datafile);
    counter_Lines_in_File = counter_Lines_in_File + 1;
    if length(line)>=7 && strcmp(line (1:7),'DataAnz')==1
%             disp('Beginning of data from next line');
        Line_beginning_data = counter_Lines_in_File+1;
    end;
    if (counter_Lines_in_File >= Line_beginning_data) && (strcmp(line (2:8),'End Run')~=1)
        fprintf(fid_pure_data_raw, line);
        fprintf(fid_pure_data_raw, '\n');
    end;
    if eof ==1
        break
    end
end
fclose(fid_pure_data_raw);
fclose(fid_datafile);

fid_datafile = fopen(filename,'r');
for i = 1:counter_Lines_in_File;
    line = fgetl(fid_datafile);
    for detectorr = 1: size(Detectors_want_to_plot,1)
        Detector_id = Detectors_want_to_plot{detectorr};
        if length(line)==length(Detector_id) && strcmp(line (1:length(Detector_id)),Detector_id)==1;
            Row_Detector_Number(detectorr,1) = i-1;
        end;
    end
end;
fclose(fid_datafile);
    
fid_datafile = fopen(filename,'r');
for i = 1:counter_Lines_in_File;
    line = fgetl(fid_datafile);
    for detectorr = 1: size(Detectors_want_to_plot,1)
        if i == Row_Detector_Number(detectorr,1)
            Detector_Number(detectorr,1) = str2num(line(10:length(line)));
            Detector_Column(detectorr,1) = Detector_Number(detectorr,1) + 1;
        end
    end
end;
fclose(fid_datafile);
    
    

Pure_Data = load('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU/Pure_FFF_data_raw.dat');
time_in_minutes = Pure_Data(:,time_in_minutes_col_id);
Selected_Data = zeros(size(Pure_Data,1), (1+size(Detectors_want_to_plot,1)));
Selected_Data(:,1) = time_in_minutes;

for detectorr = 1: size(Detectors_want_to_plot,1);
    Selected_Data(:,(1+detectorr)) = Pure_Data(:,Detector_Column(detectorr,1));

end;

FFF_Time_in_minutes_and_Data_Selected_Detectors = Selected_Data;