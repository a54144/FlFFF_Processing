step = 2;


if step ==1;
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
    % 2. Load in data. Data at Ex 220-240nm Em240-290 were excluded because
    % they are not corrected
    % all Ex/Em wavelength interval from raw data:
    % 220:5:480
    % 240:2:600
    Ex_where_to_cut_left = 240;%Gao's data start at 220. 220:5:400
    Em_where_to_cut_left = 290;%Gao's data start at 240. 240:2:600
    
    Ex = (Ex_where_to_cut_left:5:400)';%Ex = (Ex_where_to_cut_left:5:480)';
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

                Ex = (Ex_where_to_cut_left:5:400)';%Ex = (Ex_where_to_cut_left:5:480)';
                Em = (Em_where_to_cut_left:2:600)';

                ExAx = (Ex_where_to_cut_left:5:400)';%ExAx = (Ex_where_to_cut_left:5:480)';
                EmAx = (Em_where_to_cut_left:2:600)';


                exs = min(ExAx);ems = min(EmAx); exinterval = range(ExAx)/(size(ExAx,1)-1);eminterval = range(EmAx)/(size(EmAx,1)-1);
                ndm = range(EmAx)/eminterval+1;ldm = range(ExAx)/exinterval+1;
                OneSample = fluoeem;

                OneSample = OneSample(:,((Ex_where_to_cut_left-Excitation_starting_wavelength_original)/exinterval+1):size(OneSample,2));
                OneSample = OneSample(((Em_where_to_cut_left-Emission_starting_wavelength_original)/eminterval+1):size(OneSample,1),:);

                OneSample = OneSample/3584.22;

%               !!!
%               !!!            
                %OneSample = OneSample./mathematical_dilution(X_n_Indicator,1);           
%               !!!   
%               !!!   

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
    NaN_Yes_No = squeeze (isnan(X(10,:,:)));
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
    % 3. Define things, preparing to do PARAFAC
    if 0; PlotEEMby4(1, CutData, 'ppb-QSE');end;
    Max_No_of_component = 7;
    RandInitAnalModelNumber = 10;
    CutData_OutlierRemoved01 = CutData;
    % THIS IS NECESSARY, BECAUSE THE FORMER OUTLIERTEST HAS OMITTED EMISSION
    % WAVELENGTH, YOU CAN'T USE THAT DIRECTLY TO DO FURTHER ANALYSIS
    [CutData_OutlierRemoved01] = OutlierTest(CutData_OutlierRemoved01, 1, 1,Max_No_of_component,'Yes','No');
    % Plot OutlierTest Result
    close all;
    for i = 2:Max_No_of_component
        PlotLL(CutData_OutlierRemoved01, i);
        saveas (figure(i-1),sprintf('After 1st First Outlier Removal Outlier Test None Negativity %d Components',i), 'pdf');
    end
    close all;
    [CutData_OutlierRemoved] = CutData_OutlierRemoved01;
    CutData_OutlierRemoved.nSample = size(CutData_OutlierRemoved01.X,1);
    CutData_OutlierRemoved.nEx = size(CutData_OutlierRemoved01.Ex,1);
    CutData_OutlierRemoved.nEm = size(CutData_OutlierRemoved01.Em,1);
    Outlier_Sample_No = NaN;
    if 0; EvalModelSurf(CutData_OutlierRemoved, 4); end;
    %       There are different visualized format, you can pick
    %       EvalModel(Test_OutlierRemoved02_Neg_OK, 4);
    %       EvalModelSurf(Test_OutlierRemoved02_Neg_OK, 4);
    if 0; Compare2ModelsSurf(CutData_OutlierRemoved, 3,4); end;
    close all;
    if 0; Compare2ModelsSurf(CutData_OutlierRemoved, 4,5); end;
    close all;
    % *********************************************************

    
    
    
    
    
    
    
    
    
    
    % *****************------------------------****************
    % 4. Compare model with different component numbers
    DecidedComponent_AfterOutlierTest = 3;
    % VISUALIZE THE LOADING PLOTS FOR COMPONENTS WITH DIFFERENT NUMBER OF
    %   TARGET COMPONENTS
    for i = DecidedComponent_AfterOutlierTest:Max_No_of_component  % i = 4:7
        PlotLoadings(CutData_OutlierRemoved, i);
        saveas(figure(i-DecidedComponent_AfterOutlierTest+1),sprintf('Plotted loadings for %d Component Model After Outlier Removal',i),'pdf');
    end
    % SPECTRAL SUM OF SQUARED ERROR TEST FOR DIFFERENT NUMBER OF COMPONENTS
    %   COMPARISON BETWEEN 3 NUMBER OF COMPONENTS AT A TIME
    close all;
    CompareSpecSSE(CutData_OutlierRemoved,3,4,5);
    saveas (figure(1),'Comparison of spectral sum of squared error for 3 4 5 Components','pdf');
    close all;
    CompareSpecSSE(CutData_OutlierRemoved,4,5,6);
    saveas (figure(1),'Comparison of spectral sum of squared error for 4 5 6 Components','pdf');
    close all;
    CompareSpecSSE(CutData_OutlierRemoved,5,6,7);
    saveas (figure(1),'Comparison of spectral sum of squared error for 5 6 7 Components','pdf');
    close all;

    
    
    
    
    
    
    
    
    
    
    
    
    % *****************------------------------****************
    % 5. Preparing to do SPLIT HALF ANALYSIS AND VALIDATION
    % DECIDE THE POSSIBLE UP LIMIT OF NUMBER OF COMPONETS
    DecidedComponent_UPLIMIT = 6;
    [AnalysisData] = SplitData(CutData_OutlierRemoved);
    [AnalysisData] = SplitHalfAnalysis (AnalysisData,((DecidedComponent_AfterOutlierTest-1):(DecidedComponent_UPLIMIT+1)),'SplitHalfAnalysis.mat');
    for i = (DecidedComponent_AfterOutlierTest-1):(DecidedComponent_UPLIMIT+1);
        close all;
        SplitHalfValidation(AnalysisData,'1-2',i);
        saveas (figure(1),sprintf('Split Half Validation 1-2 First two halves for %d components',i),'pdf');
    end
    close all;
    close all;
    for i = (DecidedComponent_AfterOutlierTest-1):(DecidedComponent_UPLIMIT+1)
        close all;
        SplitHalfValidation(AnalysisData,'3-4',i);
        saveas (figure(1),sprintf('Split Half Validation 3-4 Last two halves for %d components',i),'pdf');
    end
    close all;
    close all;
    %   ***********************************************************************
    step = 1;
end

if step == 2;
    % *****************------------------------****************
    % 6. Application of chosen model
    % DECIDE NUMBER OF COMPONENTS BASED ON THE SPLIT HALF RESULT
    DecidedComponent_AfterSplitHalf = 3;
    [AnalysisData] = RandInitAnal(AnalysisData, DecidedComponent_AfterSplitHalf, RandInitAnalModelNumber);
    close all;
    data = AnalysisData;f = DecidedComponent_AfterSplitHalf;
    eval(['Model=','data.Model',int2str(f)]);
    M =nmodel(Model);   
    E=data.X-M;
    [A,B,C]=fac2let(Model);
    Comp=[];
    for i=(1:f),
        Comp=reshape((krb(C(:,i),B(:,i))'),[1 data.nEm data.nEx]); 
        Comp=flucut(Comp,data.Em,data.Ex,[0 NaN],[NaN NaN]); 
        figure;
        contourf(data.Ex,data.Em,(squeeze(Comp(1,:,:)))),     
        title(['Component ' num2str(i) ''],'Fontname','times','Fontsize',22);
        xlabel('Excitation wavelength (nm)','Fontname','times','Fontsize',22);
        ylabel('Emission wavelength (nm)','Fontname','times','Fontsize',22);
        set(gca,'Fontname','times','Fontsize',22,'Linewidth',1.5,...
                'Position',[0.15 0.15 0.7 0.6],'Xtick',[220:40:400]);
            box on;
    end
    for i = 1:DecidedComponent_AfterSplitHalf
        saveas (figure(i),[sprintf('Fluorescence EEM Plot of component %d out of ',i),num2str(DecidedComponent_AfterSplitHalf)],'pdf');
    end
    close all;
    save AnalysisData_2components.mat AnalysisData
    if 0; ComponentSurf(AnalysisData,DecidedComponent_AfterSplitHalf);for i = 1:DecidedComponent_AfterSplitHalf    saveas (figure(i),sprintf('Surface Plot of component %d',i),'pdf');end;end;
    [FMax, B, C] = ModelOut(AnalysisData, DecidedComponent_AfterSplitHalf ,'PARAFACResult.csv');
    %  Calculate the relative ratio of components based on their fluorescence intensity, single/sum
    Relative_Ratio_of_Components = zeros(AnalysisData.nSample,DecidedComponent_AfterSplitHalf);
    for i = 1: AnalysisData.nSample
        for j = 1:DecidedComponent_AfterSplitHalf
            Relative_Ratio_of_Components(i,j) = FMax(i,(j))*100/sum(FMax(i,:));
        end
    end
    FMax_All_data = FMax;
    B_All_data = B;
    C_All_data = C;
    Relative_Ratio_of_Components_All_data = Relative_Ratio_of_Components;
    % Draw out the relative percentage of components plots
    close all;
    legendarray = cell(DecidedComponent_AfterSplitHalf,1);
    for i = 1:DecidedComponent_AfterSplitHalf
        legendarray(i) = {sprintf('component %d',i)};
    end
    h=figure;
    cmap= colormap(jet(DecidedComponent_AfterSplitHalf));
    for i = 1:DecidedComponent_AfterSplitHalf
        plot([1:1:AnalysisData.nSample], Relative_Ratio_of_Components(1:AnalysisData.nSample,i),'color',cmap(i,:));
        hold on
    end
    legend(legendarray);
    title('Relative ratio of each component in samples','Fontname','Helvetica','Fontsize',22);
    xlabel('Sample Number','Fontname','Helvetica','Fontsize',22);
    ylabel('Percentage (%)','Fontname','Helvetica','Fontsize',22);
    saveas (h,'Relative ratio of each component in samples','pdf');
    % EXPORT ALL THE QUANTIFIED DATA
    save Fluo_Intensity_each_component_each_sample.dat FMax_All_data -ascii -tabs;
    save Emission_Mode_Loading_Data.dat B_All_data -ascii -tabs;
    save Excitation_Mode_Loading_Data.dat C_All_data -ascii -tabs;
    save Relative_Ratio_of_Components.dat Relative_Ratio_of_Components_All_data -ascii -tabs;
    %**********************************************************************
end;
