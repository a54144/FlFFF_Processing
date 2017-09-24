%PREDINT  近似結果オブジェクトまたは新規観測点に対する予測区間
%
%   CI = PREDINT(FITRESULT,[X,Y],LEVEL) は、指定した X, Y の値で、新しい Z の
%   値に対する予測区間を返します。LEVEL は、信頼度で、デフォルト値は 0.95 です。
%
%   CI = PREDINT(FITRESULT,[X,Y],LEVEL,'INTOPT','SIMOPT') は、計算する区間の
%   タイプを指定します。'INTOPT' は、新しい観測に対する範囲を計算する場合は 
%   'observation' (デフォルト)、X, Y で計算された曲面に対する範囲を計算する
%   場合は 'functional' のいずれかを設定することができます。
%   'SIMOPT' は、'on' の場合は同時の信頼区間を計算し、'off' の場合は
%   非同時区間を計算します
%
%   'INTOPT' が 'functional' の場合、その範囲は曲線の推定において不確かさを
%   測定します。また、'INTOPT' が 'observation' の場合、その範囲は新しい 
%   Z 値 (曲線＋ランダムノイズ) の予測における不確かさを表わすためにより
%   広くなります。
%
%   信頼度が 95% で、'INTOPT' を 'functional' と仮定します。'SIMOPT' が 
%   'off' (デフォルト) の場合、真の曲面が信頼区間の間に入り 95% の信頼度を持つ 
%   1 つのあらかじめ定義された X, Y 値が与えられます。'SIMOPT' が 'on' の場合、
%   曲面全体が (すべての X, Y 値で) 範囲内にある 95% の信頼区間を持ちます。
%
%   [CI, YI] = PREDINT( ... ) は、さらに予測 YI も返します。
%
%   参考: SFIT, SFIT/FEVAL.

%   Copyright 2001-2009 The MathWorks, Inc.
