%FITOPTIONS  Fit options オブジェクトの作成/修正
%
%   F = FITOPTIONS(LIBNAME) は、ライブラリモデル LIBNAME に対して、デフォルト値を
%   オプションパラメータとして使って、fitoptions オブジェクト F を作成します。
%   LIBNAME の詳細情報は、CFLIBHELP を参照してください。
%
%   F = FITOPTIONS(LIBNAME,'PARAM1',VALUE1,'PARAM2',VALUE2,...) は、指定した
%   パラメータで変更された値を使ってライブラリモデル LIBNAME に対する
%   デフォルトの fitoptions オブジェクトを作成します。
%
%   F = FITOPTIONS('METHOD',VALUE) は、VALUE で指定した方法を使って、
%   デフォルトの fitoptions オブジェクトを作成します。VALUE で選択可能な値は、
%   以下のとおりです。
%
%      NearestInterpolant     - 最近傍補間
%      LinearInterpolant      - 線形補間
%      PchipInterpolant       - 区分的 3 次エルミート補間
%      CubicSplineInterpolant - 3 次スプライン補間
%      BiharmonicInterpolant  - 重調和曲面補間
%      SmoothingSpline        - 平滑化スプライン
%      LowessFit              - Lowess (局所回帰平滑化) 近似
%      LinearLeastSquares     - 線形最小二乗
%      NonlinearLeastSquares  - 非線形最小二乗
%
%   VALUE への入力は、すべての文字を入力する必要はなく、固有に識別できる
%   文字数で十分です。また、大文字、小文字の区別はありません。
%
%   F = FITOPTIONS('METHOD',VALUE1,'PARAM2',VALUE2,...) は、指定した値で
%   変更した名前付きパラメータを使って VALUE1 で指定したメソッドに対する
%   デフォルトの fitoptions オブジェクトを作成します。
%
%   F = FITOPTIONS(OLDF,NEWF) は、既存の fitoptions オブジェクト OLDF と
%   新しい fitoptions オブジェクト NEWF を組み合わせます。OLDF と NEWF が
%   同じ 'Method' の場合、空でない値を持つ NEWF 内のいくつかのパラメータは、
%   OLDF 内の対応する古いパラメータを書き換えます。OLDF と NEWF が異なる 
%   'Method' を持つ場合、F は、OLDF と同じ Method を持ち、NEWF の 'Normalize', 
%   'Exclude', 'Weights' フィールドを OLDF のものと代えて使用します。
%
%   F = FITOPTIONS(OLDF,'PARAM1',VALUE1,'PARAM2',VALUE2,...) は、fitoptions 
%   オブジェクト OLDF に対して、指定したパラメータと値で書き換えたもので、
%   新しい fitoptions オブジェクトを作成します。
%
%   F = FITOPTIONS は、すべてのフィールドがデフォルト値に設定され、Method 
%   パラメータが、'None' である fitoptions オブジェクト F を作成します。
%
%   すべての FITOPTIONS オブジェクトには、以下のパラメータがあります。
%
%      Normalize - データの中心を移動したり、スケーリングするか否かを設定
%                   [{'off'} | 'on']
%      Exclude   - データと同じ長さの排除ベクトル
%                  [{[]} | 排除した要素部を 1 に設定した論理ベクトル]
%      Weights   - データと同じ長さの重みベクトル
%                  [{[]} | 正の要素を持つベクトル]
%      Method    - FIT で使用するメソッド
%
%   Method 値によっては、fitoptions オブジェクトは他のパラメータを持つことも
%   できます。
%
%   Method が、NearestInterpolant, LinearInterpolant, PchipInterpolant, 
%   CubicSplineInterpolant, BiharmonicInterpolant のいずれかの場合、
%   追加パラメータはありません。
%
%   Method が SmoothingSpline の場合、以下の追加パラメータがあります。
%      SmoothingParam - 平滑化パラメータ [{NaN} | [0,1] の間の値]
%                       NaN は、FIT の間、計算されることを意味します。
%
%   Method が LowessFit の場合、以下の追加パラメータがあります。
%      Span      - 局所回帰で使用するためのデータ点の割合
%                  [[0,1] | {0.25} のスカラ]
%
%   Method が LinearLeastSquares の場合、以下の追加パラメータがあります。
%
%      Robust    - ロバストな最小二乗近似手法を指定
%                  [{'off'} | 'on' | 'LAR' | 'Bisquare']
%      Lower     - 近似する係数に適用する下限用のベクトル
%                  [{[]} | 係数の数を長さとするベクトル]
%      Upper     - 近似する係数に適用する上限用のベクトル
%                  [{[]} | 係数の数を長さとするベクトル]
%
%  Method が NonlinearLeastSquares の場合、以下の追加パラメータがあります。
%
%     Robust        - ロバストな非線形最小二乗近似手法を指定 
%                     [{'off'} | 'on' | 'LAR' | 'Bisquare']
%     Lower         - 近似する係数に適用する下限用のベクトル
%                     [{[]} | 係数の数を長さとするベクトル]
%     Upper         - 近似する係数に適用する魚右舷用のベクトル
%                     [{[]} | 係数の数を長さとするベクトル]
%     StartPoint    - FIT 内の開始点を要素とするベクトル
%                     [{[]} | 係数の数を長さとするベクトル]
%     Algorithm     - FIT に使用するアルゴリズム
%                     [{'Levenberg-Marquardt'} | 'Gauss-Newton' | 'Trust-Region']
%     DiffMaxChange - 有限差分の勾配に対する係数の最大変化量 
%                     [正のスカラ | {1e-1}]
%     DiffMinChange - 有限差分の勾配に対する係数の最小変化量 
%                     [正のスカラ | {1e-8}]
%     Display       - 表示レベル ['off' | 'iter' | {'notify'} | 'final']
%     MaxFunEvals   - 関数 (モデル) 評価の最大許容回数
%                     [正の整数]
%     MaxIter       - 可能な最大繰り返し回数 [ 正の整数 ]
%     TolFun        - 関数 (モデル) 値の終了許容誤差
%                     [ 正のスカラ  | {1e-6} ]
%     TolX          - 係数の終了許容誤差
%                     [ 正のスカラ  | {1e-6} ]
%
%  パラメータを固有に識別する頭文字と入力するだけで設定することができます。
%  パラメータ名の大文字と小文字の区別は無視されます。
%
%  参考 FITTYPE, CFLIBHELP.


%   Copyright 2001-2009 The MathWorks, Inc.
