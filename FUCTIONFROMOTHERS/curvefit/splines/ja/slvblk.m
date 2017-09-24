%SLVBLK  ブロック対角線形システムの解法
%
%   SLVBLK(BLOKMAT,B) は、ほぼブロック対角な型のスプラインで (たとえば、
%   SPCOL で生成されるような) BLOKMAT に格納された行列 A を持つ線形システム 
%   A*X=B の解を (もしあれば) 返します。
%
%   システムが過決定 (すなわち方程式の数が未知数よりも多い) の場合、
%   最小二乗解が返されます。
%
%   SLVBLK(BLOKMAT,B,W) は、重み付き l_2 の和を最小化するベクトル X を返します。
%
%      sum_j W(j)*( (A*X-B)(j) )^2 .
%
%   これは、システムが過決定の場合、有効です。W に対するデフォルトは、
%   列 [1,1,1,...] です。
%
%   例:
%   以下のステートメントでは、あるノイズの入ったデータを生成します。
%   それから、2 つの等間隔に並んだ節点を持つ 3 次スプラインによるデータに対して、
%   SLVBLK を用いて複合台形則の重みによって重み付けられた最小 2 乗近似を決定し、
%   結果をプロットします。
%
%      x = [0,sort(rand(1,31)),1]*(2*pi);
%      y = sin(x)+(rand(1,33)-.5)/10;
%      k = 4; knots = augknt(linspace(x(1),x(end),3),k);
%      dx = diff(x); w = ([dx 0] + [0 dx])/2;
%      sp = spmak(knots,slvblk(spcol(knots,k,x,'slvblk','noderiv'),y.',w).');
%      fnplt(sp,2); hold on, plot(x,y,'ok'), hold off
%
%   参考 SPCOL, SPAPS, SPAPI, SPAP2.

%   Copyright 1987-2008 The MathWorks, Inc.
