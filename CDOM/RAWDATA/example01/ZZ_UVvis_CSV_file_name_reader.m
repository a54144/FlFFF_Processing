% clear;
% clc;
ffilename = fopen('fns.dat','wt');
filelist = dir('*.CSV');
% filelist = dir('pathway/*.filetype');

for i = 1:length(filelist)
    fprintf(ffilename,filelist(i).name);
    if i~=length(filelist);
    fprintf(ffilename,'\n');
    end;
end
fclose(ffilename);
samplenofile = fopen('sampleno.dat','wt');
fprintf(samplenofile,'%f',length(filelist)/3-1);
fclose(samplenofile);
