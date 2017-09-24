%TPAPS  薄板曲面 (Thin-plate) 平滑化スプライン
%
%   F = TPAPS(X,Y) は、与えられたデータサイト X(:,j) とそれに対応するデータ値 
%   Y(:,j) に対する薄板曲面平滑化スプライン f の st-型です。データ値は、スカラ、
%   ベクトル、行列、または N 次元配列です。X(:,j) は、平面内の異なる点であり、
%   データサイトと厳密に同じ数のデータ値がなければなりません。
%   薄板曲面平滑化スプライン f は、以下の重み付き和のただ 1 つのミニマイザです。
%
%                     P*E(f) + (1-P)*R(f) ,
%
%   ここで、E(f) は誤差基準です。
%
%       E(f) :=  sum_j { | Y(:,j) - f(X(:,j)) |^2 : j=1,...,n }
%
%   さらに、R(f) は、以下の粗さ (roughness) 基準です。
%
%       R(f) := integral  (D_1 D_1 f)^2 + 2(D_1 D_2 f)^2 + (D_2 D_2 f)^2.
%
%   ここで、積分は、2 つの空間全体に渡って行われます。D_i は i 番目の引数に
%   関する微分を示します。そのため、積分は f の 2 次微分を必要とします。
%   平滑化パラメータ P は、サイト X に依存する個別の方法で選択されます。
%
%   TPAPS(X,Y,P) は、0 と 1 の間の数である平滑化パラメータ P を与えます。
%   P が 0 から 1 まで変化するとき、データに対する平滑化スプラインは、P が 
%   0 のときの線形多項式による最小二乗近似から、P が 1 のときの薄板曲面
%   スプライン補間まで変化します。
%
%   [F,P] = TPAPS(...) は、使用された平滑化パラメータも返します。
%
%   警告: 平滑化スプラインの決定には、存在するデータ点と同じ数の未知数を持つ
%   線形システムの解が必要です。この線形システムの行列は非スパースのため、
%   それを解くには 728 以上のデータ点が存在し、繰り返しのスキームが使用される
%   ここでの場合でさえ長い時間がかかります。この繰り返しの収束の速さは P に
%   よって強く影響を受け、P が大きいほど緩やかになります。したがって、
%   大規模な問題に対しては、時間的余裕がある場合のみ、(P を 1 とする) 補間を
%   使用してください。
%
%   例:
%
%      nxy = 31;
%      xy = 2*(rand(2,nxy)-.5); vals = sum(xy.^2);
%      noisyvals = vals + (rand(size(vals))-.5)/5;
%      st = tpaps(xy,noisyvals); fnplt(st), hold on
%      avals = fnval(st,xy);
%      plot3(xy(1,:),xy(2,:),vals,'wo','markerfacecolor','k')
%      quiver3(xy(1,:),xy(2,:),avals,zeros(1,nxy),zeros(1,nxy), ...
%               noisyvals-avals,'r'), hold off
%   は、31 のランダムなサイトで、非常に滑らかな関数の値を生成して、ある
%   ノイズを加え、そして、これらのノイズのあるデータに対して、平滑化
%   スプラインを作成します。再現しようとしている元のデータの厳密な値 
%   (黒丸) と、平滑化スプラインで平滑化された値からノイズのある値に
%   達する矢印をプロットします。
%
%      n = 64; t = linspace(0,2*pi,n+1); t(end) = [];
%      values = [cos(t); sin(t)];
%      centers = values./repmat(max(abs(values)),2,1);
%      st = tpaps(centers, values, 1);
%      fnplt(st), axis equal
%   は、生成された図に示されるように、単位正方形 {x in R^2: |x(j)|<=1, j=1:2} 
%   の点を単位円板 {x in R^2: norm(x)<=1} 上にかなり一致するように移す、
%   平面から平面への写像を作図します。
%
%   参考 CSAPS, SPAPS.

%   Copyright 1987-2008 The MathWorks, Inc.
