function FFF_Time_in_minutes_and_Data_All_Detectors = ZZ_FFF_Guo2013_UWM_Read_All_Detectors(filename)
fid_datafile = fopen(filename,'r');
    fid_pure_data_raw = fopen('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU/Pure_data_raw.dat','wt');
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
    Pure_Data = load('Pure_data_raw.dat');
fclose(fid_datafile);
FFF_Time_in_minutes_and_Data_All_Detectors = Pure_Data;
