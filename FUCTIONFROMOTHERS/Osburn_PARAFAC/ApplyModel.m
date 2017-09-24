%ApplyModel.m -- Applying a PARAFAC model using the FittingYY code from
%Yamashita (Jaffe''s lab).
% Applying or forcing a PARAFAC model.
% Updated 08 Nov 12 by CLO.

%Step 1: Load in your PARAFAC model and delete all variables except the
%Analysis Data structure.
disp('Load in your PARAFAC model and delete all variables except the Analysis Data structure.')
input('Press ENTER to continue. ')

%Step 2: Run pfileloader2.m and normalize as appropriate.
disp('Running pfileloader3...')
pfileloader3;

% Step 3: Create the FittingData structure.
FittingData = struct('Ex',Ex,'Em',Em,'X',MyData.X,'nEx',MyData.nEx,'nEm',MyData.nEm,'nSample',MyData.nSample)

% Step 4: Cut data to match your PARAFAC model.
[CutFittingData]=EEMCut(FittingData,20,20,NaN,NaN,'')

% Check that EEMCut is similar to that in AnalysisData
PlotEEMby4(1,CutFittingData,'QSU')

goon = input('Cutting ok? (y/n) ','s');
if goon == 'n'
    disp('Fix your error')
else
    ModNum = input('Type in number of components in your model:  ')
end

[A,B,C]=fac2let(eval(['AnalysisData.Model',int2str(ModNum)])); % fixed to choose ModNum in command (11/07/12; clo) 
A = rand(MyData.nSample,ModNum);
Oldload={A;B;C};
Oldload=Oldload'
clear A B C;

[Model,Iter,Err]=FittingbyYY(CutFittingData.X,ModNum,[1e-6],[2 2 2],Oldload,[0 1 1])
eval(['CutFittingData.Model',int2str(ModNum),'=Model',])
eval(['CutFittingData.Err',int2str(ModNum),'=Err',])
eval(['CutFittingData.Iter',int2str(ModNum),'=Iter',])

EvalModel(CutFittingData,ModNum)

CutFittingData.Em=CutFittingData.Em';
CutFittingData.Ex=CutFittingData.Ex';

modName = input('Name this model: ','s');

[FMax,B,C]=ModelOut(CutFittingData,ModNum,[cd '\',modName, '(', (int2str(ModNum)),'comp).xls']); % FIX OutPut

eval(['Model=','CutFittingData.Model',int2str(ModNum)])
M =nmodel(Model);
E=CutFittingData.X-M; %***E (the residual matrix) was made by subtracting: POM – Model (Model = predicting POM based on DOM 7 components). MPM
save([cd '\ResidEEMs(',datestr(floor(now)),').mat'],'E') 

 
% end ApplyModel.m 