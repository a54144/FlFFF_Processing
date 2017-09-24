function Wavelength_Absorbance_Matrix = ZZcsvreadUVvisspectrophotometerGuo2010(filename)
LineInWholeSheet = 911;
wavelength = (190:1:1100)';
if 0
wavelength = ones(LineInWholeSheet,1);
wavelengthmatrix = ones(LineInWholeSheet,5);
end
absorbance = zeros(LineInWholeSheet,1);
minusarray = ones(LineInWholeSheet,1);
absorbanceintegermatrix = zeros(LineInWholeSheet,1);
SingleSampleWholeSheet = fopen(filename,'r');
% get rid of the first line, which is just data information, i.e., first
% column is wavelength, second is UV-vis absorbance, third is stdev.
OneRawLineInSampleSheet= fgetl(SingleSampleWholeSheet);
for i = 1:LineInWholeSheet
    % after some trial, I realized that this data file has useful data line
    % every other line, that's why I used the fgetl command twice, to make
    % sure that I don't get blank data
    OneRawLineInSampleSheet = fgetl(SingleSampleWholeSheet);
    OneRawLineInSampleSheet = fgetl(SingleSampleWholeSheet);
    % get rid of spaces in this read line.
    OneRawLineInSampleSheet = OneRawLineInSampleSheet(OneRawLineInSampleSheet~=' ');
    % find the commas
    commaLocs = findstr(',',OneRawLineInSampleSheet);
    dotLocs = findstr('.',OneRawLineInSampleSheet);
    
    % define a string variable that hold up the data array
    fieldData = cell(1,(length(commaLocs)+1));
    if 0 
    fieldData{1} = OneRawLineInSampleSheet(1:commaLocs(1)-1);
    if i == 630||755; fieldData{1} = OneRawLineInSampleSheet(1:dotLocs(1)-1);end;
    if i<811 
        if i ~=630 && i~=755
            wavelengthmatrix(i,1:4) = str2num(fieldData{1});
            wavelength(i,1) = wavelengthmatrix(i,1)*100+wavelengthmatrix(i,2)*10+wavelengthmatrix(i,3);
        end
        if i == 630|| i ==755;
            wavelengthmatrix(i,1:3) = str2num(fieldData{1});
            wavelength(i,1) = wavelengthmatrix(i,1)*100+wavelengthmatrix(i,2)*10+wavelengthmatrix(i,3);
        end
    end
    if i>=811
        wavelengthmatrix(i,1:5) = str2num(fieldData{1});
        wavelength(i,1) = wavelengthmatrix(i,1)*1000+wavelengthmatrix(i,2)*100+wavelengthmatrix(i,3)*10+wavelengthmatrix(i,4);
    end
    end
    fieldData2minus = OneRawLineInSampleSheet(commaLocs(1)+1:dotLocs(1)-1);
    minusLocs = findstr('-',fieldData2minus);
    if minusLocs~= 0
        minusarray(i,1) = -1;
    end
    fieldData2integer = str2num(OneRawLineInSampleSheet(commaLocs(1)+1:commaLocs(1)+2));
    if fieldData2integer~=0
        absorbanceintegermatrix(i,1) = fieldData2integer;
    end
    fieldData{2} = OneRawLineInSampleSheet(dotLocs(1)+1:commaLocs(2)-1);
    absorbanceraw = str2num(fieldData{2});
    for j = 1:length(absorbanceraw)
        absorbance(i,1) = (0.1^j)*absorbanceraw(j)+absorbance(i,1);
    end
    absorbance(i,1) = minusarray(i,1)*(absorbance(i,1)+(absorbanceintegermatrix(i,1)));
    fieldData{3} = OneRawLineInSampleSheet(commaLocs(2)+1:end);

%     start = 1;
%     for colIdx = 1:length(commaLocs)
%         fieldData{colIdx} = OneRawLineInSampleSheet(start:commaLocs(colIdx)-1);
%         start = commaLocs(colIdx)+1;
%     end
%     fieldData{colIdx+1} = OneRawLineInSampleSheet(start:end);

end


Wavelength_Absorbance_Matrix = [wavelength absorbance];
%     b = str2num(fieldData{2})
%     c = str2num(fieldData{3})
%      FormattedSingleSampleData(i,:) = 
%      sscanf(OneRawLineInSampleSheet,'%d')
%     wavelength(i,1) = str2num(OneRawLineInSampleSheet(1:3))
%      fprintf(TransitionDataSheet,OneRawLineInSampleSheet);
% M = mfcsvread('LP-13-12092010-TIMESERIES11_3b.csv',2,1)