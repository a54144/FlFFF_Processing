clear;
clc;
close all;
 
Current_working_dir_path = ...
'C:\Matlab Processing\FluoEEM\RAWDATA\Guo\';
fid_dat_file_name = fopen('FileNames(.dat)_in_first_order_subfolders.dat','wt');
% *****************------------------------****************
% *****************------------------------****************
% 1. FOLDER NAME: Get the names of the subfolders, and store them in the file:
% Sub_FolderNames.dat. 
% Not only names of the subfolders, but also their directories were
% in the file: Another file Sub_Folder_Names_with_Directory.dat
Dirs=dir(Current_working_dir_path);
Sub_Folder_Names = fopen('Sub_Folder_Names.dat','wt');
Sub_Folder_Names_with_Directory = fopen('Sub_Folder_Names_with_Directory.dat','wt');
Counter_folder = 0;
for i = 1:length(Dirs);
    if (Dirs(i).isdir ==1) && (strcmp (Dirs(i).name,'.')== 0) && (strcmp (Dirs(i).name,'..')== 0);
        Counter_folder = Counter_folder+1;
    end;
end;
Total_Number_Of_Sub_Folder = Counter_folder;
Counter_folder_indicator = 0;
for i = 1:length(Dirs);
    if (Dirs(i).isdir ==1) && (strcmp (Dirs(i).name,'.')== 0) && (strcmp (Dirs(i).name,'..')== 0);
        Counter_folder_indicator = Counter_folder_indicator+1;
        fprintf(Sub_Folder_Names,'%s',Dirs(i).name);
        Sub_dir_path = strcat(Current_working_dir_path,Dirs(i).name,'/');
        fprintf(Sub_Folder_Names_with_Directory,'%s',Sub_dir_path);
        if Counter_folder_indicator ~= Total_Number_Of_Sub_Folder
            fprintf(Sub_Folder_Names,'\n');
            fprintf(Sub_Folder_Names_with_Directory,'\n');
        end;        
    end;
end;
fclose(Sub_Folder_Names);
fclose(Sub_Folder_Names_with_Directory);
% *********************************************************
% *********************************************************
fprintf(fid_dat_file_name,'%s \n','Total number of sub folders');
fprintf(fid_dat_file_name,'%d \n',Total_Number_Of_Sub_Folder);
% *****************------------------------****************
% *****************------------------------****************
% 2. FILE NAME: Get the names of the .dat files in the subfolders, and 
% save them in the "FileNames(.dat)_in_first_order_subfolders.dat" file
Sub_Folder_Names_with_Directory = fopen('Sub_Folder_Names_with_Directory.dat','r');
Sub_Folder_Names = fopen('Sub_Folder_Names.dat','r');
 
Samplenames_with_Sub_Folder_Directory = fopen('Sample_Names_with_Sub_Folder_Directory.dat','wt');
Samplenames_ONLY = fopen('Sample_Names_ONLY.dat','wt');
for i_contourfolder = 1:Total_Number_Of_Sub_Folder
%   Each loop is One Sub Folder
    sub_folder_name_with_directory = fgetl(Sub_Folder_Names_with_Directory);
    sub_folder_name = fgetl(Sub_Folder_Names);
    fprintf(fid_dat_file_name,'%s \n',strcat('Start of Sub Folder: ',sub_folder_name));
    fprintf(fid_dat_file_name,'%s \n',sub_folder_name_with_directory);
    filelist=dir(strcat(sub_folder_name_with_directory,'*.dat'));
    for i = 1:length(filelist)
%       Each loop is one *.dat file in this sub folder
%       filelist(i).name             is file name of the one *.dat file
        fprintf(fid_dat_file_name,'%s \n',filelist(i).name);
 
        fns_y_n = strfind(filelist(i).name,'fns.dat');
        quinine_y_n = strfind(filelist(i).name,'quinine');
        waterblank_y_n = strfind(filelist(i).name,'Water_blank');
        if (size(fns_y_n,1)==0) && (size(quinine_y_n,1)==0) && (size(waterblank_y_n,1)==0); 
            fprintf(Samplenames_with_Sub_Folder_Directory,'%s \n',strcat(sub_folder_name,'/',filelist(i).name));
            
            pure_filename = filelist(i).name;
            pure_filename = pure_filename(1:(length(pure_filename)-4));
 
            fprintf(Samplenames_ONLY,'%s \n',pure_filename);
        end;
         
        if i == length(filelist) 
            fprintf(fid_dat_file_name,'%s',strcat('End of Sub Folder: ',sub_folder_name));
            if i_contourfolder~=Total_Number_Of_Sub_Folder;
                fprintf(fid_dat_file_name,'\n');
            end;
        end;
    end
end;
% *********************************************************
% *********************************************************
fclose(fid_dat_file_name );
fclose(Samplenames_with_Sub_Folder_Directory);
fclose(Samplenames_ONLY);
clear;
% clc;
close all;

