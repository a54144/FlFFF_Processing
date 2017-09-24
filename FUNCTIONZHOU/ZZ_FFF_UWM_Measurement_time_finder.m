function FFF_Measurement_time = ZZ_FFF_UWM_Measurement_time_finder(filename)

Measurement_time_Read_In = 999999.*ones(3,1);
fid_datafile = fopen(filename,'r');
counter_Lines_in_File = 0;
Line_beginning_Description_of_sample = 999999;
while 1
    line = fgetl(fid_datafile);
    eof = feof(fid_datafile);
    counter_Lines_in_File = counter_Lines_in_File + 1;
    if length(line)>=12 && strcmp(line (1:12),'Description:')==1
%         disp('Beginning of sample description');
        Line_beginning_Description_of_sample = counter_Lines_in_File+1;
    end;    
    if eof ==1;break;end;
end
fclose(fid_datafile);
fid_datafile = fopen(filename,'r');
for i = 1:counter_Lines_in_File
    line = fgetl(fid_datafile);
    if i >= Line_beginning_Description_of_sample &&  i <= (Line_beginning_Description_of_sample +20);      
        if length(line)>=32 && strcmp(line (1:32),'Measurement time with cross flow')==1
            Measurement_time_with_cross_flow = str2num(line((strfind(line,'Measurement time with cross flow')+length('Measurement time with cross flow')):(strfind(line,'min')-1)));
            Measurement_time_Read_In (1,1) = Measurement_time_with_cross_flow;
        end;
        if length(line)>=41 && strcmp(line (1:41),'Measurement time with decaying cross flow')==1
            Measurement_time_with_decaying_cross_flow = str2num(line((strfind(line,'Measurement time with decaying cross flow')+length('Measurement time with decaying cross flow')):(strfind(line,'min')-1)));
            Measurement_time_Read_In (2,1) = Measurement_time_with_decaying_cross_flow;
        end;
        if length(line)>=35 && strcmp(line (1:35),'Measurement time with no cross flow')==1
            Measurement_time_with_no_cross_flow = str2num(line((strfind(line,'Measurement time with no cross flow')+length('Measurement time with no cross flow')):(strfind(line,'min')-1)));
            Measurement_time_Read_In (3,1) = Measurement_time_with_no_cross_flow;
        end;
    end;
end;
fclose(fid_datafile);
FFF_Measurement_time = Measurement_time_Read_In;