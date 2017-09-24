clc
clear all
close all

time=2:(1/24):2+(718-1)/24;
output_path='figure_output_001_002\';
output_name1='ts_skill_run1_vs_run2_with_color';
output_name2='v_skill_run1_vs_run2_with_color';
a=load('forecast001.dat');
b=load('forecast002.dat');

t_fcst1_vs_buoy=a(1:length(time),9);
s_fcst1_vs_buoy=a(1:length(time),10);
v_fcst1_vs_buoy=a(1:length(time),11);
t_fcst2_vs_buoy=b(1:length(time),9);
s_fcst2_vs_buoy=b(1:length(time),10);
v_fcst2_vs_buoy=b(1:length(time),11);

max_t=max(max(t_fcst1_vs_buoy),max(t_fcst2_vs_buoy));
max_s=max(max(s_fcst1_vs_buoy),max(s_fcst2_vs_buoy));
max_v=max(max(v_fcst1_vs_buoy),max(v_fcst2_vs_buoy));

t_fcst1_vs_buoy=t_fcst1_vs_buoy/max_t;
s_fcst1_vs_buoy=s_fcst1_vs_buoy/max_s;
v_fcst1_vs_buoy=v_fcst1_vs_buoy/max_v;
t_fcst2_vs_buoy=t_fcst2_vs_buoy/max_t;
s_fcst2_vs_buoy=s_fcst2_vs_buoy/max_s;
v_fcst2_vs_buoy=v_fcst2_vs_buoy/max_v;

mean_t_fcst1_vs_buoy=mean(t_fcst1_vs_buoy(2:end-1))
mean_s_fcst1_vs_buoy=mean(s_fcst1_vs_buoy(2:end-1))
mean_v_fcst1_vs_buoy=mean(v_fcst1_vs_buoy(2:end-1))

mean_t_fcst2_vs_buoy=mean(t_fcst2_vs_buoy(2:end-1))
mean_s_fcst2_vs_buoy=mean(s_fcst2_vs_buoy(2:end-1))
mean_v_fcst2_vs_buoy=mean(v_fcst2_vs_buoy(2:end-1))


hf1=figure('Position',[600,100,560,370], 'color','w');
h11=axes('position',[0.09 0.59 0.84 0.39],'box','on');
	hold on
	plot(time,t_fcst1_vs_buoy,'color',[0 0 1],'linewidth',2)
	plot(time,t_fcst2_vs_buoy,'color',[0 176/256 80/256],'linewidth',2)
	hlegend=legend('Run 4: traditional q_T','Run 6: hybrid q_T','location',[0.20 0.85 0.1 0.1]);
        set(hlegend,'fontsize',10,'fontname','Times New Roman','box','on')
	ylabel('Temperature Error','fontsize',12,'fontname','Times New Roman') 
    set(gca,'fontsize',12,'xlim',[2 32],'ylim',[0 1])
    [x0,y0]=rela_posi(-0.1,1.02);
        text(x0,y0,'(a)','fontsize',12,'fontname','times new roman')
h12=axes('position',[0.09 0.59 0.84 0.135],'color','none');
    num_mode=b(1:length(time),22);
    percent_mode=b(1:length(time),23);
    hbar=bar(time,num_mode);
        set(hbar,'FaceColor',[1 51/256 153/256],'EdgeColor',[1 51/256 153/256])
    set(h12,'yaxislocation','right','color','none','fontsize',12,'xlim',[2 32]) %,'ylim',[min(num_mode),max(num_mode)+5])
    set(h12,'xtick',[],'ylim',[0 2],'box','off')
    ylabel('Number of modes m','fontsize',12,'fontname','Times New Roman') 
    
h21=axes('position',[0.09 0.13 0.84 0.4],'box','on');
	hold on
	plot(time,s_fcst1_vs_buoy,'color',[0 0 1],'linewidth',2)
	plot(time,s_fcst2_vs_buoy,'color',[0 176/256 80/256],'linewidth',2)
    hlegend=legend('Run 4: traditional q_S','Run 6: hybrid q_S','location',[0.70 0.40 0.1 0.1]);
        set(hlegend,'fontsize',10,'fontname','Times New Roman','box','on')
	ylabel('Salinity Error','fontsize',12,'fontname','Times New Roman')
    xlabel('August, 2003','fontsize',12,'fontname','Times New Roman')
    set(h21,'fontsize',12,'xlim',[2 32],'ylim',[0 1])
    [x0,y0]=rela_posi(-0.1,1.02);
        text(x0,y0,'(b)','fontsize',12,'fontname','times new roman')
h22=axes('position',[0.09 0.13 0.84 0.135],'color','none');
    num_mode=b(1:length(time),22);
    percent_mode=b(1:length(time),23);
    hbar=bar(time,num_mode);
        set(hbar,'FaceColor',[1 51/256 153/256],'EdgeColor',[1 51/256 153/256])
    set(h22,'yaxislocation','right','color','none','fontsize',12,'xlim',[2 32]) %,'ylim',[min(num_mode),max(num_mode)+5])
    set(h22,'xtick',[],'ylim',[0 2],'box','off')
    ylabel('Number of modes m','fontsize',12,'fontname','Times New Roman') 
    
hf2=figure;
set(gcf,'Position',[600,100,550,250], 'color','w')
h3=axes('position',[0.11 0.18 0.86 0.80]','xlim',[2 32],'ylim',[0.1 1],'box','on');
	hold on
	plot(time,v_fcst1_vs_buoy,'color',[0 0 1],'linewidth',2)
	plot(time,v_fcst2_vs_buoy,'color',[0 176/256 80/256],'linewidth',2)
	hlegend=legend('Run 4: traditional q_V','Run 6: hybrid q_V','location',[0.72 0.78 0.1 0.1]);
        set(hlegend,'fontsize',10,'fontname','Times New Roman','box','on')
    set(gca,'fontsize',12)
	ylabel('Velocity Error','fontsize',12,'fontname','Times New Roman')
    xlabel('August, 2003','fontsize',12,'fontname','Times New Roman')
saveas(hf1,[output_path,output_name1,'.emf'])
saveas(hf2,[output_path,output_name2,'.emf'])
% close all

% title(['mean temperature error decrease: ',num2str(mean_t_fcst1_vs_buoy),' ----> ',num2str(mean_t_fcst2_vs_buoy)],'fontsize',14)
% title(['mean salinity error decrease: ',num2str(s_fcst1_vs_buoy(end)),' ----> ',num2str(s_fcst2_vs_buoy(end))],'fontsize',14)
% title(['mean velocity error decrease: ',num2str(v_fcst1_vs_buoy(end)),' ----> ',num2str(v_fcst2_vs_buoy(end))],'fontsize',14)
