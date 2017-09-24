function FFF_Calculated_Sensitivity_Selected_Detectors = ZZ_FFF_Guo2013_UWM_Sensivity_Calculator_UV_1_UV_2_FLD1_FLD2(filename)

Sensitivity_Read_In = 999999.*ones(4,4);
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
    if i >= Line_beginning_Description_of_sample &&  i <= (Line_beginning_Description_of_sample +12);      
        if length(line)>=3 && strcmp(line (1:3),'UV1')==1
%             Aux_Range = str2num(line((strfind(line,'aux range')+length('aux range')+1):length(line)))
            Aux_Range = str2num(line((strfind(line,'aux range')+length('aux range')):length(line)));
            Sensitivity_Read_In (1,1) = Aux_Range;
        end;
        if length(line)>=3 && strcmp(line (1:3),'UV2')==1
%             Range = str2num(line((strfind(line,'range')+length('range')+1):length(line)))
            Range = str2num(line((strfind(line,'range')+length('range')):length(line)));
            Sensitivity_Read_In (2,1) = Range;
        end;
        if length(line)>=14 && strcmp(line (1:14),'Fluorescence 1')==1
%             disp(line);
            line = fgetl(fid_datafile);
%             disp(line);
            Sensitivity_Read_In (3,1) = str2num(line((strfind(line,'sensitivity')+length('sensitivity')):(strfind(line,'gain')-1)));
            Sensitivity_Read_In (3,2) = str2num(line((strfind(line,'gain')+length('gain')):(strfind(line,'mode')-1)));
            Sensitivity_Read_In (3,3) = str2num(line((strfind(line,'mode')+length('mode')):(strfind(line,'range')-1)));
            Sensitivity_Read_In (3,4) = str2num(line((strfind(line,'range')+length('range')):length(line)));
        end;
        if length(line)>=14 && strcmp(line (1:14),'Fluorescence 2')==1
%             disp(line);
            line = fgetl(fid_datafile);
%             disp(line);
            Sensitivity_Read_In (4,1) = str2num(line((strfind(line,'sensitivity')+length('sensitivity')):(strfind(line,'gain')-1)));
            Sensitivity_Read_In (4,2) = str2num(line((strfind(line,'gain')+length('gain')):(strfind(line,'mode')-1)));
            Sensitivity_Read_In (4,3) = str2num(line((strfind(line,'mode')+length('mode')):(strfind(line,'range')-1)));
            Sensitivity_Read_In (4,4) = str2num(line((strfind(line,'range')+length('range')):length(line)));
        end;
    end;

end;
fclose(fid_datafile);
%save \C:\Matlab Processing\FUNCTIONZHOU/Sensitivity_Read_In.dat Sensitivity_Read_In -ascii -tabs;
save Sensitivity_Read_In -ascii -tabs;
Sensitivity_Rules = [...
    1 1024;
    2 32;
    3 1];

Gain_Rules = [...
    1 1;
    2 4;
    3 16];

AnalogMode_Rules = [...
    0 2;
    1 1];

AnaRecRange_Rules = [...
    1 1;
    2 0.5;
    3 0.25;
    4 0.125;
    5 0.0625;
    6 0.03125;
    7 0.015625;
    8 0.0078125;
    9 0.00390625];

AuxRangeToRange_Rules = [...
    1 0.005;
    2 0.01;
    3 0.02;
    4 0.04;
    5 0.0125;
    6 0.025];
    
Raw_Sensitivity = load('Sensitivity_Read_In.dat');

Sensitivity_Calculated = zeros(4,1);
UV1AuxRange_chosen = Raw_Sensitivity(1,1);
Sensitivity_Calculated(1,1) = AuxRangeToRange_Rules((AuxRangeToRange_Rules(:,1) == UV1AuxRange_chosen),2);
Sensitivity_Calculated(2,1) = Raw_Sensitivity(2,1);
for fluoii = 3:4
    Sensitivity_chosen = Raw_Sensitivity(fluoii,1);
    Gain_chosen = Raw_Sensitivity(fluoii,2);
    AnalogMode_chosen = Raw_Sensitivity(fluoii,3);
    AnaRecRange_chosen = Raw_Sensitivity(fluoii,4);
    Sensitivity_Contribution = Sensitivity_Rules((Sensitivity_Rules(:,1) == Sensitivity_chosen),2);
    Gain_Contribution = Gain_Rules((Gain_Rules(:,1) == Gain_chosen),2);
    AnalogMode_Contribution = AnalogMode_Rules((AnalogMode_Rules(:,1) == AnalogMode_chosen),2);
    AnaRecRange_Contribution = AnaRecRange_Rules((AnaRecRange_Rules(:,1) == AnaRecRange_chosen),2);
    if AnalogMode_Contribution == 2;AnaRecRange_Contribution = 1;end;
    Sensitivity_Calculated(fluoii,1) = Sensitivity_Contribution * Gain_Contribution * AnalogMode_Contribution * AnaRecRange_Contribution;
end;
% save Sensitivity_Calculated.dat Sensitivity_Calculated -ascii -tabs;
FFF_Calculated_Sensitivity_Selected_Detectors = Sensitivity_Calculated;