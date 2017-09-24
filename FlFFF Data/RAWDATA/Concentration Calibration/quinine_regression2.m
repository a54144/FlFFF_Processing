clear;
clc;
close all;
Data_50ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/50ug/Area_Selected_Detectors.dat');
Data_100ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/100ug/Area_Selected_Detectors.dat');
Data_250ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/250ug/Area_Selected_Detectors.dat');
Data_500ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/500ug/Area_Selected_Detectors.dat');
Data_1000ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/1000ug/Area_Selected_Detectors.dat');
concentration = [50;100;250;500;1000];
Data_all = [Data_50ug;Data_100ug;Data_250ug;Data_500ug;Data_1000ug];

Data = [concentration Data_all];
% % % % % [3 4;
% % % % % 2 5;
% % % % % 1 5;
% % % % % 1 5]