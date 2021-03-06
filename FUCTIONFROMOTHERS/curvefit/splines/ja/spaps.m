% SPAPS   平滑化スプライン
%
% [SP,VALUES] = SPAPS(X,Y,TOL)は、データ X, Y への 3 次平滑化
% スプライン f のB-型と、必要であれば、X での値を出力します。
% 平滑化スプラインは、j=1:length(X) として、与えられたデータ値 Y(:,j) 
% をデータ位置 X(j) で近似します。データ値は、スカラ、ベクトル、行列、
% またはN次元配列です。
%
% 平滑化スプライン f は、誤差基準
%
%       E(f) :=  sum_j { W(j)*|Y(:,j) - f(X(j))|^2 : j=1,...,length(X) }
%
% が TOL より大きくないすべての関数 f 上で、粗さ基準
%
%       F(D^M f) := integral |D^M f(t)|^2 dt  on  min(X) < t < max(X)
%
% を最小化します。
%
% ここで、X と Y は、同じ位置のすべてのデータ点を、対応する重みの和を
% 重みとした重み付け平均により置き換えられます。これにより、TOL も小さく
% なります。
% D^M f は、f の M 階微分を意味します。
% 重み W は、E(f) が F(y-f) に対する複合台形則の近似になるように選択されます。
% 通常整数 M は、2 が選択されます。したがって、D^M f は、f の 2 階微分です。
% この M の選択により、f は 3 次平滑化スプラインになります。
% これは、f が E(f) と TOL が等しくなるよう選択された平滑化パラメータ 
% RHO を用いて以下の式を最小化するように構成されるためです。
%
%                     rho*E(f) + F(D^2 f) ,
%
% ゆえに、FN2FM(SP,'pp') は、CPAPS(X,Y,RHO/(1+RHO)) からの出力と (丸めると)
% 同じになる必要があります。
%
% 結果として得られる平滑化スプライン sp を、基本区間の外側で評価する場合、
% M 階微分がその基本区間の外側で 0 になることを保証するために fnxtr(sp,M) 
% で置き換える必要があります。
%
% [SP,VALUES,RHO] = SPAPS(X,Y,...) は、RHO も出力します。
%
% TOL が 0 のとき、'variational' 3 次スプライン補間が得られます。
% TOL が負である場合、-TOL が、使用される RHO としてみなされます。
%
% データ値 Y(:,j) が、スカラではなく、大きさ d であるとき、各 t に対して、
% f(t) と D^M f(t) もまた大きさ d です。したがって、全体で prod(d) 個の
% 要素をもち、式 |Y(:,j) - f(X(j))|^2 と |D^M f(t)|^2 が、これらの 
% prod(d) 個の要素の 2 乗和を示すことになります。
%
% 多変数関数については、データ位置は、以下で説明するように、グリッド化
% されていなければなりません。散在したデータについては、TPAPS を試して
% ください。
%
% 例:
%
%      x = linspace(0,2*pi,21); y = sin(x) + (rand(1,21)-.5)*.2;
%      sp = spaps(x,y, (.05)^2*(x(end)-x(1)) );
%
% は、内在しているノイズのないデータにかなり近いことが予想される、ノイズ
% 付きデータへの近似を行います。これは、ノイズのないデータがゆるやかに
% 変化する関数から生成され、使用されている TOL がノイズの大きさに対し
% 適切であるためです。
%
%   SPAPS(X,Y,TOL,W)
%   SPAPS(X,Y,TOL,M)
%   SPAPS(X,Y,TOL,W,M)
%   SPAPS(X,Y,TOL,M,W)
% これらを用いる場合はすべて、W および/または M を明示的に与えなければ
% なりません。ここで、M は (デフォルトの M = 2 に加え) 現在 M = 1 (線形)
% および M = 3 (5次) に制限されています。
%
% TOL をスカラではなくデータ系列とすることにより、滑らかさを変えることも
% 可能です。その場合、粗さ基準は、lambda を使ってつぎのように与えられます。
%
%                    integral lambda(t) (D^M f(t))^2 dt ,
%
% ここで、lambda は、ブレークポイント X で接続されている区分的に一定な
% 関数であり、その関数値は全ての i に対して区間 (X(i-1) .. X(i)) において
% TOL(1) となります。TOL(1) は、依然として許容誤差として用いられます。
%
% 例:
%
%    sp1 = spaps(x,y, [(.025)^2*(x(end)-x(1)),ones(1,10),repmat(.1,1,10)] );
%
% は、前の例と同じデータと許容誤差を使用しますが、粗さの重みを区間の
% 右半分で 0.1 にすることで、荒いがより適切な近似を行なうことができます。
% 比較のために両方の例を示すプロットは、つぎにより得られます。
%
%    fnplt(sp); hold on, fnplt(sp1,'r'), plot(x,y,'ok'), hold off
%    title('Two cubic smoothing splines')
%    xlabel('the red one has reduced smoothness requirement in right half.')
%
% SPAPS({X1,...,Xr},Y,...) は、r個のベクトル X1, ..., Xr によって指定される
% r 次元長方形のグリッド上のデータ値 Y に対する平滑化スプラインを与えます。
% この r 個のベクトルの長さは異なっていても構いません。Y は、データ値の
% 長さ d として、[d,length(X1), ..., length(Xr)] の大きさをもちます。
% Y が、r次元の配列であるが、[length(X1), ..., length(Xr)] の大きさの
% 場合、d は、[1] であると解釈されます。すなわち、関数は、スカラ値です。
% グリッドデータの場合、オプションの引数 M は、1 つの整数であるか、あるいは、
% (集合{1,2,3}からの) 整数のr要素のベクトルです。また、オプションの引数 
% W は、長さ r のセル配列であることが要求されます。ここで W{i} は 
% (デフォルトの選択を得るため) に空か、あるいは、i=1:r の X{i} と同じ
% 長さのベクトルのいずれかです。
% また、この場合、もし TOL がセル配列でなければ、TOL は、r 個の必要な
% 許容誤差を指定する r 個の要素のベクトルでなければなりません。一方セル配列
% であれば、最初の要素が r 個の変数それぞれにおいて要求される許容誤差
% として使用されます。
%
% 例:
%      x = -2:.2:2; y=-1:.25:1; [xx,yy] = ndgrid(x,y); 
%      z = exp(-(xx.^2+yy.^2)) + (rand(size(xx))-.5)/30; 
%      sp = spaps({x,y},z,8/(60^2));  fnplt(sp)
%
% は、2変数関数からのノイズ付きデータを滑らかに近似した図を生成します。
% ここで NDGRID ではなく、MESHGRID を使用すると、エラーになります。
%
% 参考 SPAPI, SPAP2, CSAPS, TPAPS.


%   Copyright 1987-2008 The MathWorks, Inc.
