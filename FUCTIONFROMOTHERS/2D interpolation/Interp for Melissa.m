%Read in existing file
EEM = xlsread('G:\Sapelo Aug\blank\16203.xls');%copy in full path for each file.
ExEEM = 240:5.12194824218801:450;
EmEEM = 300:2:550;
[X,Y] = meshgrid(ExEEM,EmEEM);

%interpolate existing file
ExInt = 240:5:450;
EmInt = 300:2:550;
EEMtrim = EEM(2:127,2:43);
[XI,YI] = meshgrid(ExInt,EmInt);
EEMInt = Interp2(X,Y,EEMtrim,XI,YI);
EEMInt(:,43) = EEM(2:127,43);

%Compare the two files visually
subplot(2,1,1),
%contourf(X,Y,Z)
contourf(EmEEM,ExEEM,EEMtrim', 500), axis tight, colorbar
xlabel('Emission (nm)')
ylabel('Excitation (nm)')

subplot(2,1,2),
%contourf(X,Y,Z)
contourf(EmInt,ExInt,EEMInt', 500), axis tight, colorbar
xlabel('Emission (nm)')
ylabel('Excitation (nm)')

%Save the new EEM
%EEMIntwaves(2:127,2:44) = EEMInt; %If we need to add the wavelengths back
%in uncomment these three lines
%EEMIntwaves(2:127,1) = EmInt;
%EEMIntwaves(1,2:44) = ExInt;
xlswrite('G:\Sapelo Aug\blank\16203Int.xls',EEMInt);
%With wavelengths
%xlswrite('C:\Users\kaelin\16050Int.xls',EEMIntwaves);