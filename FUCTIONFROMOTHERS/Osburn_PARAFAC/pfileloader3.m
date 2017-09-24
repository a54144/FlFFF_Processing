%pfileloader3.m; CLO 09 JUL 09; This file loads into a the structure
%'MyData', all of the information in the correct order, required for use
%with Stedmon's DOMFluor toolbox.  In this case, 'MyData' is equivalent to
%Stedmon's 'OriginalData'.

a = ls('*p_*.csv'); %list all files in directory.
Ex=input('Ex wl range? ');
Em=input('Em wl range? ');
MyData.Ex = Ex';
MyData.Em = Em';

if input('Divide data by total fluorescence (y/n)? ','s') == 'y',
    for i=1:length(a(:,1)),
    X(i,:,:) = load(a(i,:));
    MyData.Xtot(i) = nansum(nansum(X(i,:,:))); %Total fluor intensity
    MyData.X(i,:,:) = X(i,:,:)./MyData.Xtot(i); %Total averaged data
    end
    
MyData.nEx = length(Ex);
MyData.nEm = length(Em);
MyData.nSample = length(MyData.X(:,1,1));
MyData.XBackup = MyData.X;
MyData.Names=a;
clear a X

elseif input('Divide data by maximum fluorescence (y/n)? ','s') == 'y',
    for i=1:length(a(:,1)),
    X(i,:,:) = load(a(i,:));
    MyData.Xmax(i) = nanmax(nanmax(X(i,:,:))); %Max fluor intensity
    MyData.X(i,:,:) = X(i,:,:)./MyData.Xmax(i); %Max fluor averaged data
    end
    
MyData.nEx = length(Ex);
MyData.nEm = length(Em);
MyData.nSample = length(MyData.X(:,1,1));
MyData.XBackup = MyData.X;
MyData.Names=a;
clear a X
    
else
   for i=1:length(a(:,1)),
    MyData.X(i,:,:) = load(a(i,:));
   end 

MyData.nEx = length(Ex);
MyData.nEm = length(Em);
MyData.nSample = length(MyData.X(:,1,1));
MyData.XBackup = MyData.X;
MyData.Names=a;
clear a 
end