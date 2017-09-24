function [EEM_data_This_sample,Excitation_wavelength_range_This_sample,Emission_wavelength_range_This_sample] = ZZfluoEEMreadShimadzuGuo2010(File_Name_This_sample)
fid_This_sample = fopen(File_Name_This_sample);
counter_line = 0;
while 1;line = fgetl(fid_This_sample);eof = feof(fid_This_sample);counter_line = counter_line + 1;if eof ==1;break;end;end;
fclose(fid_This_sample);
fid_This_sample = fopen(File_Name_This_sample);
fid_output_This_sample = fopen('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU/puredata_for_ZZfluoEEMreadShimadzuGuo2010_from_last_run.dat','wt');
for i = 1:counter_line
    line = fgetl(fid_This_sample);
%     if i<2;
%         line = line(12:length(line));
%         fprintf(fid_output_This_sample,'%d',0);
%         fprintf(fid_output_This_sample,'\t');
%         fprintf(fid_output_This_sample,line);
%         fprintf(fid_output_This_sample,'\n');
%     end;
    if i ==1
        fprintf(fid_output_This_sample,'%d',(220:2:400));
    end
    if i>1
        fprintf(fid_output_This_sample,line);
        fprintf(fid_output_This_sample,'\n');
    end
end;
fclose(fid_output_This_sample);
fclose(fid_This_sample);
number_part_of_data = load('/Users/zhengzhenzhouyeah/study/MATLAB/FUNCTIONZHOU/puredata_for_ZZfluoEEMreadShimadzuGuo2010_from_last_run.dat','r');
EEM_data_This_sample = number_part_of_data(1:size(number_part_of_data,1),2:size(number_part_of_data,2));
Excitation_wavelength_range_This_sample = 220:2:400;%number_part_of_data(1,2:size(number_part_of_data,2));
Emission_wavelength_range_This_sample = number_part_of_data(2:size(number_part_of_data,1),1);


