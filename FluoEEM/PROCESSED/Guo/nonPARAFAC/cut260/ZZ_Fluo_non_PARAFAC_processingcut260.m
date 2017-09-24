clear;
clc;
close all;
addpath('C:\Matlab Processing\FUNCTIONZHOU');
 
% *****************------------------------****************
% 1. Get an inventory of files: Prepare to locate each sample file and 
% its corresponding water blank to do further calculation
Sample_Inventory_directory = 'C:\Matlab Processing\FluoEEM\INVENTORY\Guo\';
ff = fopen(strcat(Sample_Inventory_directory,'FileNames(.dat)_in_first_order_subfolders.dat'),'r');counter = 0;while 1;l = fgetl(ff);eof = feof(ff);counter = counter + 1;if eof ==1;break;end;end;fclose(ff);
Number_line_General_file_names = counter;clear eof ff l counter ans;
Cell_General_file_names = cell(Number_line_General_file_names,1);
ff = fopen(strcat(Sample_Inventory_directory,'FileNames(.dat)_in_first_order_subfolders.dat'),'r');for i = 1:Number_line_General_file_names;l = fgetl(ff);Cell_General_file_names{i,1} = l;if i ==2; Number_sub_Folder = str2num(l);end;end;fclose(ff);
Sub_Folder_Indicator = 0;clear ff l ans;
File_position_in_General_file = zeros(Number_sub_Folder,2);
Directory_subfolders = cell(Number_sub_Folder,1);
for i_General_file_names = 1:Number_line_General_file_names;
    line = Cell_General_file_names{i_General_file_names};
    if length(line)>=19 && strcmp(line(1:19),'Start of Sub Folder')==1
        Sub_Folder_Indicator = Sub_Folder_Indicator+1;
        Directory_subfolders{Sub_Folder_Indicator,1} = Cell_General_file_names{i_General_file_names+1};
        File_position_in_General_file(Sub_Folder_Indicator,1) = i_General_file_names + 2;        
    end
    if length(line)>=11 && strcmp(line(1:11),'Water_blank')==1
        File_position_in_General_file(Sub_Folder_Indicator,3) = i_General_file_names;        
    end
    if length(line)>=17 && strcmp(line(1:17),'End of Sub Folder')==1
        File_position_in_General_file(Sub_Folder_Indicator,2) = i_General_file_names - 1;        
    end
end;
Array_Number_of_files_in_subfolders = zeros(Number_sub_Folder,2);
for i = 1:Number_sub_Folder
    Array_Number_of_files_in_subfolders(i,1) = ...
        File_position_in_General_file(i,2) - ...
        File_position_in_General_file(i,1) +1 ;
    Array_Number_of_files_in_subfolders(i,2) = ...
        File_position_in_General_file(i,2) - ...
        File_position_in_General_file(i,1) ;
end;
Sum_Array_Number_of_files_in_subfolders = sum(Array_Number_of_files_in_subfolders);
Total_Sample_number_including_water_blank = Sum_Array_Number_of_files_in_subfolders(1,1);
Total_Sample_number_excluding_water_blank = Sum_Array_Number_of_files_in_subfolders(1,2);
 
sampleno = Total_Sample_number_excluding_water_blank;
Cell_sample_names_excluding_water_blank = cell(Total_Sample_number_excluding_water_blank,1);
% *********************************************************
 
% *****************------------------------****************
% 2. Load in data. Data at Ex 220-260nm Em260-290 were excluded because
% they are not corrected
% all Ex/Em wavelength interval from raw data:
% 220:5:480
% 260:2:600
Ex_where_to_cut_left = 260;
Em_where_to_cut_left = 290;
Ex = (Ex_where_to_cut_left:5:480)';
Em = (Em_where_to_cut_left:2:600)';
exinterval = 5; eminterval= 2;
nEm = (max(Em)-min(Em))/eminterval+1; nEx = (max(Ex)-min(Ex))/exinterval+1;
X = zeros(sampleno, nEm,nEx);
% Load all the sample data into the big X matrix
X_n_Indicator = 0;
fid_samplename = fopen('SampleNames.dat','wt');
for i_sub_folder = 1:Number_sub_Folder;
    Directory_this_subfolder = Directory_subfolders{i_sub_folder};
    Water_blank_file_with_directory = strcat(Directory_this_subfolder,Cell_General_file_names{File_position_in_General_file(i_sub_folder,3),1});
    [Water_blank_fluoeem,ExAx,EmAx] = ZZfluoEEMreadHoribaGuo2012(Water_blank_file_with_directory);
    for i_file_name = File_position_in_General_file(i_sub_folder,1):File_position_in_General_file(i_sub_folder,2)
        if i_file_name ~= File_position_in_General_file(i_sub_folder,3)
            filename = Cell_General_file_names{i_file_name,1};
            Sample_file_with_directory = strcat(Directory_this_subfolder,filename);    
            X_n_Indicator = X_n_Indicator + 1;
            [Sample_fluoeem,ExAx,EmAx] = ZZfluoEEMreadHoribaGuo2012(Sample_file_with_directory);       
            Cell_sample_names_excluding_water_blank{X_n_Indicator,1} = filename;
            fprintf(fid_samplename,'%s \n',filename);
            %           Correct for water blank
            fluoeem = Sample_fluoeem - Water_blank_fluoeem;
            Excitation_starting_wavelength_original = min(ExAx);
            Emission_starting_wavelength_original = min(EmAx);
            
            Ex = (Ex_where_to_cut_left:5:480)';
            Em = (Em_where_to_cut_left:2:600)';
            
            ExAx = (Ex_where_to_cut_left:5:480)';
            EmAx = (Em_where_to_cut_left:2:600)';
            
            
            exs = min(ExAx);ems = min(EmAx); exinterval = range(ExAx)/(size(ExAx,1)-1);eminterval = range(EmAx)/(size(EmAx,1)-1);
            ndm = range(EmAx)/eminterval+1;ldm = range(ExAx)/exinterval+1;
            OneSample = fluoeem;
            
            OneSample = OneSample(:,((Ex_where_to_cut_left-Excitation_starting_wavelength_original)/exinterval+1):size(OneSample,2));
            OneSample = OneSample(((Em_where_to_cut_left-Emission_starting_wavelength_original)/eminterval+1):size(OneSample,1),:);
            
            OneSample = OneSample/3584.22;
% % % % % % % % Convolution with a filter? (Seems it give ok results for finding peak positions for fluoEEM)
% % % % %             C = conv2(OneSample,fspecial('gaussian'));%hsize (default [3 3]); sigma (default 0.5)
% % % % %             OneSample = C;
% % % % % % % % Convolution with a filter? (Seems it give ok results for finding peak positions for fluoEEM)
                for i = 1:nEm
                    for j = 1:nEx
                            X(X_n_Indicator,i,j) = OneSample(i,j);
                    end
                end       
        end
    end;
end;
fclose(fid_samplename);
 
FirstOrderCut = [-40 15];
SecondOrderCut = [-40 15];
InsertedData = [NaN 0];
for i = 1:2
    if FirstOrderCut(i) ~= NaN
        for j = 1: length(Ex)
            k = find (Em<Ex(j)-FirstOrderCut(i));
            X(:,k,j) = InsertedData(i);
        end
    end
    if SecondOrderCut (i) ~= NaN
        for j = 1:length(Ex)
            k = find (Em>Ex(j)*2.05+SecondOrderCut(i));
            X(:,k,j) = InsertedData(i);
        end
    end
end
NaN_Yes_No = squeeze (isnan(X(1,:,:)));
i = find(sum(NaN_Yes_No)<size(X,2));
j = find(sum(NaN_Yes_No')<size(X,3));
CutData.X = X(:, j, i);
CutData.Em = Em(j);
CutData.Ex = Ex(i);
CutData.nSample = size(CutData.X,1);
CutData.nEx = size(CutData.Ex,1);
CutData.nEm = size(CutData.Em,1);
% *********************************************************
 
% *****************------------------------****************
% 3. Further Calculation: non PARAFAC processing and plots
 
% FOR THIS CONTOUR-PRODUCTION-INDICATOR, 0 MEANS DO NOT PROCEDUCE FLUOEEM
% PLOTS; 1 MEANS PRODUCE FLUOEEM CONTOURS IN SINGLE PLOTS, 
% 2 MEANS TO PRODUCE FLUOEEM CONTOUR IN SUBPLOTS.
ContourProductionIndicator =1; 
ContourResolution = 500;
ex_lamda_FIX_1 = 370;em_lamda_FIX_1 = 450; ex_lamda_FIX_2 = 370;em_lamda_FIX_2 = 500;
FIX_row_in_matrix_1 = (em_lamda_FIX_1-ems)/eminterval+1; FIX_column_in_matrix_1 = (ex_lamda_FIX_1-exs)/exinterval+1; 
FIX_row_in_matrix_2 = (em_lamda_FIX_2-ems)/eminterval+1; FIX_column_in_matrix_2 = (ex_lamda_FIX_2-exs)/exinterval+1; 
ex_lamda_BIX_1 = 310;em_lamda_BIX_1 = 380; ex_lamda_BIX_2 = 310;em_lamda_BIX_2 = 430;
BIX_row_in_matrix_1 = (em_lamda_BIX_1-ems)/eminterval+1; BIX_column_in_matrix_1 = (ex_lamda_BIX_1-exs)/exinterval+1; 
BIX_row_in_matrix_2 = (em_lamda_BIX_2-ems)/eminterval+1; BIX_column_in_matrix_2 = (ex_lamda_BIX_2-exs)/exinterval+1; 
ex_lamda_HIX_1 = 254;em_lamda_HIX_1_start = 435; em_lamda_HIX_1_end = 480;ex_lamda_HIX_2 = 254;em_lamda_HIX_2_start = 300;em_lamda_HIX_2_end = 345; 
HIX_row_in_matrix_1_start = ceil((em_lamda_HIX_1_start-ems)/eminterval+1); HIX_row_in_matrix_1_end = floor((em_lamda_HIX_1_end-ems)/eminterval+1); HIX_column_in_matrix_1 = ceil((ex_lamda_HIX_1-exs)/exinterval+1); 
HIX_row_in_matrix_2_start = ceil((em_lamda_HIX_2_start-ems)/eminterval+1); HIX_row_in_matrix_2_end = floor((em_lamda_HIX_2_end-ems)/eminterval+1); HIX_column_in_matrix_2 = ceil((ex_lamda_HIX_2-exs)/exinterval+1); 
FIsps = zeros(sampleno,1);BIXsps = zeros(sampleno,1);HIXsps = zeros(sampleno,1);
 
T_and_B_Ex_start_point = 260;
 
em_lamda_A_Lower_Boundary = 420;em_lamda_A_Upper_Boundary = 510;
ex_lamda_A_Lower_Boundary = 260;ex_lamda_A_Upper_Boundary = 270;
A_Lower_Boundary_row_in_matrix = (em_lamda_A_Lower_Boundary-ems)/eminterval+1;A_Upper_Boundary_row_in_matrix = (em_lamda_A_Upper_Boundary-ems)/eminterval+1;A_Lower_Boundary_column_in_matrix = (ex_lamda_A_Lower_Boundary-exs)/exinterval+1;A_Upper_Boundary_column_in_matrix = (ex_lamda_A_Upper_Boundary-exs)/exinterval+1;
 
em_lamda_C_Lower_Boundary = 420;em_lamda_C_Upper_Boundary = 510;
ex_lamda_C_Lower_Boundary = 320;ex_lamda_C_Upper_Boundary = 390;
C_Lower_Boundary_row_in_matrix = (em_lamda_C_Lower_Boundary-ems)/eminterval+1;C_Upper_Boundary_row_in_matrix = (em_lamda_C_Upper_Boundary-ems)/eminterval+1;C_Lower_Boundary_column_in_matrix = (ex_lamda_C_Lower_Boundary-exs)/exinterval+1;C_Upper_Boundary_column_in_matrix = (ex_lamda_C_Upper_Boundary-exs)/exinterval+1;
 
em_lamda_T_Lower_Boundary = 330;em_lamda_T_Upper_Boundary = 360;
ex_lamda_T_Lower_Boundary = T_and_B_Ex_start_point;ex_lamda_T_Upper_Boundary = 290;
T_Lower_Boundary_row_in_matrix = (em_lamda_T_Lower_Boundary-ems)/eminterval+1;T_Upper_Boundary_row_in_matrix = (em_lamda_T_Upper_Boundary-ems)/eminterval+1;T_Lower_Boundary_column_in_matrix = (ex_lamda_T_Lower_Boundary-exs)/exinterval+1;T_Upper_Boundary_column_in_matrix = (ex_lamda_T_Upper_Boundary-exs)/exinterval+1;
 
em_lamda_B_Lower_Boundary = 295;em_lamda_B_Upper_Boundary = 330;
ex_lamda_B_Lower_Boundary = T_and_B_Ex_start_point;ex_lamda_B_Upper_Boundary = 290;
B_Lower_Boundary_row_in_matrix = (em_lamda_B_Lower_Boundary-ems)/eminterval+1;B_Upper_Boundary_row_in_matrix = (em_lamda_B_Upper_Boundary-ems)/eminterval+1;B_Lower_Boundary_column_in_matrix = (ex_lamda_B_Lower_Boundary-exs)/exinterval+1;B_Upper_Boundary_column_in_matrix = (ex_lamda_B_Upper_Boundary-exs)/exinterval+1;
 
 
em_lamda_T_and_B_Lower_Boundary = 295;em_lamda_T_and_B_Upper_Boundary = 360;
ex_lamda_T_and_B_Lower_Boundary = T_and_B_Ex_start_point;ex_lamda_T_and_B_Upper_Boundary = 290;
T_and_B_Lower_Boundary_row_in_matrix = (em_lamda_T_and_B_Lower_Boundary-ems)/eminterval+1;T_and_B_Upper_Boundary_row_in_matrix = (em_lamda_T_and_B_Upper_Boundary-ems)/eminterval+1;T_and_B_Lower_Boundary_column_in_matrix = (ex_lamda_T_and_B_Lower_Boundary-exs)/exinterval+1;T_and_B_Upper_Boundary_column_in_matrix = (ex_lamda_T_and_B_Upper_Boundary-exs)/exinterval+1;
 
 
Fluo_Ex_Max = zeros(sampleno,1);Fluo_Em_Max = zeros(sampleno,1);Fluo_Max_Intensity = zeros(sampleno,1);
Fluo_A_Ex_Max = zeros(sampleno,1);Fluo_A_Em_Max = zeros(sampleno,1);Fluo_A_Max_Intensity = zeros(sampleno,1);
Fluo_C_Ex_Max = zeros(sampleno,1);Fluo_C_Em_Max = zeros(sampleno,1);Fluo_C_Max_Intensity = zeros(sampleno,1);
Fluo_T_Ex_Max = zeros(sampleno,1);Fluo_T_Em_Max = zeros(sampleno,1);Fluo_T_Max_Intensity = zeros(sampleno,1);
Fluo_B_Ex_Max = zeros(sampleno,1);Fluo_B_Em_Max = zeros(sampleno,1);Fluo_B_Max_Intensity = zeros(sampleno,1);
Fluo_T_and_B_Ex_Max = zeros(sampleno,1);Fluo_T_and_B_Em_Max = zeros(sampleno,1);Fluo_T_and_B_Max_Intensity = zeros(sampleno,1);
 
parameter_base={'Excitation wavelength (nm)';'Emission wavelength (nm)';'Fluorescence Intensity (ppbQSE)'};
parameter_component = {'All';'A';'C';'T';'B';'T and B'};
 
fid_samplename = fopen('SampleNames.dat','r');
if ContourProductionIndicator == 2;q = 1;figureindex = figure(q); hold on;tuma = 1;savingname=('123456789abcdefghijklmnopqrstuvwxyz');end;
for n = 1: sampleno
    filen = fgetl(fid_samplename);
    filen = filen(1:(length(filen)-6));
    data = squeeze(CutData.X(n,:,:));
    FI = data (FIX_row_in_matrix_1,FIX_column_in_matrix_1)/data(FIX_row_in_matrix_2,FIX_column_in_matrix_2);
    FIsps(n) = FI;
    BIX = data(BIX_row_in_matrix_1,BIX_column_in_matrix_1)/data(BIX_row_in_matrix_2,BIX_column_in_matrix_2);
    BIXsps(n) = BIX;
    HIX =0;% mean(data(HIX_row_in_matrix_1_start:HIX_row_in_matrix_1_end,HIX_column_in_matrix_1))./mean(data(HIX_row_in_matrix_2_start :HIX_row_in_matrix_2_end,HIX_column_in_matrix_2));
    HIXsps(n) = HIX; 
    
    max_fluo = max(max(data));data_trans = data';row = sum(data_trans == max_fluo);row_in_matrix = find(row,1);col = sum(data==max_fluo);col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_Ex_Max(n,1) = ex_lamda;Fluo_Max_Intensity(n,1) = max_fluo;
 
    data_A = data(A_Lower_Boundary_row_in_matrix:A_Upper_Boundary_row_in_matrix,A_Lower_Boundary_column_in_matrix:A_Upper_Boundary_column_in_matrix);
    max_fluo = max(max(data_A));data_trans = data';row = sum(data_trans == max_fluo);row_in_matrix = find(row,1);col = sum(data==max_fluo);col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_A_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_A_Ex_Max(n,1) = ex_lamda;Fluo_A_Max_Intensity(n,1) = max_fluo;
    
    data_C = data(C_Lower_Boundary_row_in_matrix:C_Upper_Boundary_row_in_matrix,C_Lower_Boundary_column_in_matrix:C_Upper_Boundary_column_in_matrix);
    max_fluo = max(max(data_C));data_trans = data';row = sum(data_trans == max_fluo);row_in_matrix = find(row,1);col = sum(data==max_fluo);col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_C_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_C_Ex_Max(n,1) = ex_lamda;Fluo_C_Max_Intensity(n,1) = max_fluo;
    
    data_T = data(T_Lower_Boundary_row_in_matrix:T_Upper_Boundary_row_in_matrix,T_Lower_Boundary_column_in_matrix:T_Upper_Boundary_column_in_matrix);
    max_fluo = max(max(data_T));data_trans = data';row = sum(data_trans == max_fluo);
    row_in_matrix = find(row,1);col = sum(data==max_fluo);
    col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_T_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_T_Ex_Max(n,1) = ex_lamda;Fluo_T_Max_Intensity(n,1) = max_fluo;
    
    data_B = data(B_Lower_Boundary_row_in_matrix:B_Upper_Boundary_row_in_matrix,B_Lower_Boundary_column_in_matrix:B_Upper_Boundary_column_in_matrix);
    max_fluo = max(max(data_B));data_trans = data';row = sum(data_trans == max_fluo);row_in_matrix = find(row,1);col = sum(data==max_fluo);
    col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_B_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_B_Ex_Max(n,1) = ex_lamda;Fluo_B_Max_Intensity(n,1) = max_fluo;
    
    data_T_and_B = data(T_and_B_Lower_Boundary_row_in_matrix:T_and_B_Upper_Boundary_row_in_matrix,T_and_B_Lower_Boundary_column_in_matrix:T_and_B_Upper_Boundary_column_in_matrix);
    max_fluo = max(max(data_T_and_B));data_trans = data';row = sum(data_trans == max_fluo);row_in_matrix = find(row,1);col = sum(data==max_fluo);col_in_matrix = find(col,1);
    em_lamda = (row_in_matrix - 1)* eminterval + ems;Fluo_T_and_B_Em_Max(n,1) = em_lamda;ex_lamda = (col_in_matrix - 1)* exinterval + exs;Fluo_T_and_B_Ex_Max(n,1) = ex_lamda;Fluo_T_and_B_Max_Intensity(n,1) = max_fluo;
    
 
    if ContourProductionIndicator == 1;
        h = figure;
        contourf(CutData.Ex,CutData.Em,(squeeze(CutData.X(n,:,:))),ContourResolution,'Linestyle','none'),colorbar;
        m= colorbar;
        set(m,'Fontname','times','Fontsize',22);
        pos = get (m, 'Position');
        set (m, 'Position', [0.92 pos(2) pos(3)/3 pos(4)]);
        title(filen,'Fontname','times','Fontsize',22);
        xlabel('Excitation wavelength (nm)','Fontname','times','Fontsize',22);
        ylabel('Emission wavelength (nm)','Fontname','times','Fontsize',22);
        set(gca,'fontsize',18,'Fontname','times','Xtick',(220:40:480));
        box on;
        saveas (h,filen, 'pdf');
        close all;
    end;
    if ContourProductionIndicator == 2;
        h(i) = subplot(3,2, (tuma - ((ceil(tuma/6))-1)*6) ); hold on;
        contourf(CutData.Ex,CutData.Em,(squeeze(CutData.X(n,:,:))),ContourResolution,'Linestyle','none'),colorbar;
        title(filen,'Fontname','times','Fontsize',10);
        m= colorbar;set(m,'Fontname','times','Fontsize',10);pos = get (m, 'Position');
        if tuma ==1 || tuma ==3 || tuma ==5;set (m, 'Position', [0.475 pos(2) pos(3)/3 pos(4)]);end;
        if tuma ==3;ylabel('Emission wavelength (nm)','Fontname','times','Fontsize',22);end;
        if tuma ==2 || tuma ==4 || tuma ==6;set (m, 'Position', [0.92 pos(2) pos(3)/3 pos(4)]);end;
        if tuma ==5;p = xlabel('Excitation wavelength (nm)','Fontname','times','Fontsize',22);
        posxlabel = get(p, 'Position'); set (p, 'Position', [posxlabel(1)*1.5 posxlabel(2) posxlabel(3)]);end;
        set(gca,'Fontname','times','Xtick',(220:40:480));
        box on;
        tuma = tuma +1;       
        if (tuma >6 && (floor((tuma-1)/6)==(tuma-1)/6)) ;
            saveas (figureindex, savingname(q), 'pdf');
            tuma = 1;
            q = q+1; figureindex = figure(q);
        end
        if n == sampleno
            saveas (figureindex, savingname(q), 'pdf');
        end
    end;
 
end
 
close all;
data_table = [FIsps BIXsps HIXsps];
% save NumericDataFluo.dat data_table -ascii -tabs;
Fluo_Max_Postion_Intensity = [Fluo_Ex_Max Fluo_Em_Max Fluo_Max_Intensity Fluo_A_Ex_Max Fluo_A_Em_Max Fluo_A_Max_Intensity Fluo_C_Ex_Max Fluo_C_Em_Max Fluo_C_Max_Intensity Fluo_T_Ex_Max Fluo_T_Em_Max Fluo_T_Max_Intensity Fluo_B_Ex_Max Fluo_B_Em_Max Fluo_B_Max_Intensity Fluo_T_and_B_Ex_Max Fluo_T_and_B_Em_Max Fluo_T_and_B_Max_Intensity];
% save Fluo_Max_Postion_Intensity.dat Fluo_Max_Postion_Intensity -ascii -tabs;
NumericDataFluo_with_Peaks = [data_table Fluo_Max_Postion_Intensity];
save NumericDataFluo_with_Peaks.dat NumericDataFluo_with_Peaks -ascii -tabs;
 
fid_samplename_name = fopen('SampleNames.dat','r');
fid = fopen('NumericDataFluo_with_Peaks.xls','wt');
fprintf(fid,'Sample Names');fprintf(fid,'\t');fprintf(fid,'FIX');fprintf(fid,'\t');fprintf(fid,'BIX');fprintf(fid,'\t');fprintf(fid,'HIX');fprintf(fid,'\t');
for i = 1: size(parameter_component,1);
    for j = 1: size(parameter_base,1)
        fprintf(fid,'Peak of ');
        fprintf(fid,parameter_component{i});
        fprintf(fid,' ');
        fprintf(fid, parameter_base{j});
        fprintf(fid,'\t');
    end;
end;
fprintf(fid,'\n');
fiddata = fopen('NumericDataFluo_with_Peaks.dat','r');
for i = 1: sampleno;
    name = fgetl(fid_samplename_name);
    line = fgetl(fiddata);
    fprintf(fid,name);
    fprintf(fid,'\t');
    fprintf(fid,line);
    fprintf(fid,'\n');
end;
fclose(fid);
fclose(fiddata);
fclose(fid_samplename_name);
% *********************************************************
 
 
 


