function [x0,y0]=rela_posi(x,y)

a=get(gca);
x1=a.XLim;%????????
y1=a.YLim;%????????
% k=[0.5 0.3];%??text????
x0=x1(1)+x*(x1(2)-x1(1));%??text???
y0=y1(1)+y*(y1(2)-y1(1));%??text???