clear;
clc;
a = 1:0.1:2;
for n = 1:size(a,2)
     eval(['a' num2str(n) ' = sin(a(n))+a(n)'])
end

for n = 1:size(a,2)
     eval(['a(' num2str(n) ') = sin(a(n))+a(n)'])
end





path = '/Users/zhengzhenzhouyeah/Desktop/';
filename = 'samplea';
data = rand(5);
save([path,filename,'.mat'],'data') ;
%this also works                     save(strcat(path,filename,'.mat'),'data') ;
% but .dat would not work
c=load('samplea.mat');
% this also works        c = load(strcat(path,filename,'.mat'));      
% this also works        c = load([path,filename,'.mat']);
data_load = c.data;

% put adare stamp
save(strcat(path,filename,'(',datestr(floor(now)),').mat'),'data') ;