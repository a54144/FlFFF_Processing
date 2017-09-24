clear;
clc;
close all;
Data_50ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/50ug/Area_Selected_Detectors.dat');
Data_100ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/100ug/Area_Selected_Detectors.dat');
Data_250ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/250ug/Area_Selected_Detectors.dat');
Data_500ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/500ug/Area_Selected_Detectors.dat');
Data_1000ug = load('/Users/zhengzhenzhouyeah/study/GUO/FFF/PROCESSED/UWM/10kDa/Concentration Calibration/1000ug/Area_Selected_Detectors.dat');

Data_all = [Data_50ug;Data_100ug;Data_250ug;Data_500ug;Data_1000ug];