% RSMAK   rB-型の有理スプラインの統合
%
% RSMAK(KNOTS,COEFS) は、入力によって指定された有理スプラインの
% rB-型を出力します。
%
% これは有理スプラインの B-型ととして認識されること、すなわち、分母が
% スプラインの最後の要素によって示され、分子が残りの要素によって示される
% ことを除き、厳密に SPMAK(KNOTS,COEFS) の出力となります。それに対応して、
% そのターゲットの次元は、SPMAK(KNOTS,COEFS) の出力の次元よりも 1 つ
% 小さくなります。
%
% 特に、入力の係数は、ある d>0 に対して(d+1)要素のベクトル値でなければ
% ならず、N次元の配列値としてはいけません。
%
% 例えば、spmak([-5 -5 -5 5 5 5],[26 -24 26]) は、区間 [-5 .. 5] で
% 多項式 t |-> t^2+1 のB-型を与えますが、spmak([-5 -5 -5 5 5 5], [1 1 1]) 
% は、定数関数 1 の B-型を与えます。したがって、コマンド
%
%      runge = rsmak([-5 -5 -5 5 5 5],[1 1 1; 26 -24 26]);
%
% は、等間隔の位置での多項式補間に関する Runge の例で有名な有理関数
% t |-> 1/(t^2+1) に対する区間 [-5 .. 5] での rB-型を与えます。
%
% RSMAK(KNOTS,COEFS,SIZEC) は、COEFS が後に続く要素数1の次元をもつときに
% 使用されます。この場合、SIZEC が COEFS の意図される大きさを与えるベク
% トルでなければなりません。特に SIZEC(1) は、実際の COEFS の最初の次元で
% なければなりません。したがって、SIZEC(1)-1 は、ターゲットの次元です。
%   
% c(:,i) を NURBS における制御点、または w(i) を対応するおもみとして 
% rB-型の典型的な係数の形式が [w(i)*c(:,i);w(i)] であるという意味で
% rB-型 は NURBS と同じといえます。
%
% RSMAK(OBJECT, ... ) は、文字列 OBJECT で指定された特定の幾何学的な形状を
% 出力します。例えば、
%
% RSMAK('circle',RADIUS,CENTER) は、半径 RADIUS (デフォルト値 1) と中心 
% CENTER (デフォルト値 (0,0)) から成る円を記述する 2 次の有理スプラインを
% 与えます。
%
% RSMAK('arc',RADIUS,CENTER,[ALPHA BETA]) は、半径 RADIUS (デフォルト値 1) 
% と中心 CENTER (デフォルト値 (0,0)) をもつ円の弧、ALPHA から BETA 
% (デフォルト値 -pi/2 から pi/2) から成る 2 次の有理スプラインを与えます。
%
% RSMAK('cone',RADIUS,HEIGHT) は、先端が (0,0,0) で z-座標上に中心軸を
% もつ半径 RADIUS (デフォルト値 1) と半分の高さ HEIGHT (デフォルト値 1) の
% 対称な円錐から成る 2 次の有理スプラインを与えます。
%
% RSMAK('cylinder',RADIUS,HEIGHT) は、z-座標上に中心軸をもつ半径 RADIUS 
% (デフォルト値 1) と高さ HEIGHT (デフォルト値 1) の円柱から成る 2 次の
% 有理スプラインを与えます。
%
% RSMAK('torus',RADIUS,RATIO) は、中心が (0,0,0) で、(x,y) 平面内に主要円を
% もつ、外側の半径 RADIUS (デフォルト値 1) と内側の半径 RADIUS*RATIO 
% (デフォルト値 : RATIO = 1/3) の円環面から成る 2 次の有理スプラインを
% 与えます。
%
% RSMAK('southcap',RADIUS,CENTER) は、半径 RADIUS (デフォルト値 1) と
% 中心 CENTER (デフォルト値 (0,0,0)) をもつ球の南側の 6 分の 1 を与えます。
%
% fncmb(rs,transf) を用いると RSMAK の結果得られる幾何学的オブジェクトに
% 対し transf で指定されたアフィン変換を行なうことができます。
% 以下の例では、'southcap' 自身、その回転のうちの 2 つ、およびその鏡映に
% よって与えられる球の 2/3 のプロットを生成します。
%
%      southcap = rsmak('southcap');
%      xpcap = fncmb(southcap,[0 0 -1;0 1 0;1 0 0]);
%      ypcap = fncmb(xpcap,[0 -1 0; 1 0 0; 0 0 1]);
%      northcap = fncmb(southcap,-1);
%      fnplt(southcap), hold on, fnplt(xpcap), fnplt(ypcap), fnplt(northcap)
%      axis equal, shading interp, view(-115,10), axis off, hold off
%
% 参考 RSBRK, RPMAK, PPMAK, SPMAK, FNBRK.


%   Copyright 1999-2008 The MathWorks, Inc.
