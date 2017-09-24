%FIT  曲線または曲面のデータ近似
%
%   FO = FIT(X, Y, FT) は、データ X, Y への近似タイプ FT で指定された
%   近似モデルの結果をカプセル化する fit オブジェクトです。
%
%   -- X は、1 列 (曲線近似) または 2 列 (曲面近似) の行列です。曲面近似の
%   場合、列内のすべてのデータを以下のように指定することができます。
%
%       fo = fit( [x, y], z, ft )
%
%   -- Y は X と同じ行数を持つ列ベクトルです。
%
%   -- FT は、近似するモデルを指定する文字列、または FITTYPE オブジェクトです。
%
%   FT が文字列の場合、以下のようになります。
%
%                FITTYPE                詳細
%   Splines: (曲線のみ)
%                'smoothingspline'      平滑化スプライン
%                'cubicspline'          3 次 (補間) スプライン
%   補間:
%                'linearinterp'         線形補間
%                'nearestinterp'        最近傍補間
%                'splineinterp'         3 次スプライン補間
%                'pchipinterp'          型を保存した (pchip) 補間 (曲線のみ)
%                'biharmonicinterp'     重調和 (MATLAB 4 の griddata) 補間 (曲面のみ)
%   局所回帰平滑化 (曲面のみ)
%                'lowess'               Lowess (線形近似) モデル
%                'loess'                Loess (2 次近似) モデル
%
%   または、CFLIBHELP に記述されるライブラリモデルの名前を設定できます 
%   (ライブラリモデルの名前や詳細については、CFLIBHELP と入力してください)。
%
%   FO = FIT(X, Y, FT) は、FT が FITTYPE オブジェクトで、FT 内の情報に従って
%   データ X と Y を近似する場合、近似したモデル F0 を返します。
%   カスタムモデルは、FITTYPE 関数を使って作成されます。
%
%   FO = FIT(X, Y, FT,...,PROP1,VAL1,PROP2,VAL2,...) は、プロパティ名と値、
%   PROP1, VAL1 等で指定した問題とアルゴリズムのオプションを使って、データ X と 
%   Y を近似し、近似したモデル FO を返します。
%   FITOPTIONS プロパティとデフォルト値については、FITOPTIONS(FITTYPE) と
%   入力してください。
%   たとえば、
%
%      fitoptions( 'cubicspline' )
%      fitoptions( 'exp2' )
%
%   FO = FIT(X, Y, FT, ..., 'Weight', W) は、重み付けした近似を重み W で行う
%   ことを示しています。W は Y と同じサイズのベクトルでなければなりません。
%
%   FO = FIT(X, Y, FT, OPTIONS) は、FITOPTIONS オブジェクト OPTIONS に指定
%   された問題とアルゴリズムのオプションを使ってデータ X と Y を近似します。
%   これは、プロパティの名前と値を組で設定する別の表示方法です。
%   OPTIONS オブジェクトの作成に関するヘルプは、FITOPTIONS を参照してください。
%
%   FO = FIT(X, Y, FT, ..., 'problem', VALUES) は、VALUES を problem に依存した
%   定数に代入します。VALUES は、problem に依存した定数に付き一つの要素を持つ
%   セル配列です。problem に依存した定数に関する情報は、FITTYPE を参照してください。
%
%   [FO, G] = FIT(X, Y, ...) は、与えられた入力に対する適切な適合度を構造体 
%   G に返します。G は以下のフィールドを含みます。
%       -- SSE         誤差による二乗和
%       -- R2          決定係数または R^2
%       -- adjustedR2  自由度調整決定係数
%       -- stdError    近似標準誤差または二乗平均平方根誤差
%
%   [FO, G, O] = FIT(X, Y, ...) は、与えられた入力に対して適切な出力値を持つ
%   構造体 O を返します。たとえば、非線形近似問題に対して、繰り返し回数、
%   モデルの計算回数、収束を示す exitflag 、残差、ヤコビアンを O に返します。
%
%   例:
%      [curve, goodness] = fit( x, y, 'pchipinterp' );
%   は、x と y に 3 次補間スプラインで近似します。
%
%      curve = fit( x, y, 'exp1', 'Startpoint', p0 );
%   は、開始点を p0 とする指数モデル (単一項の指数) の 曲線近似ライブラリ内
%   の 1 番目の方程式を用いて近似します。
%
%      sf = fit( [x, y], z, 'poly23', 'Robust', 'LAR' );
%   は、最小絶対残差のロバスト (LAR) 法を使って、x に次数 2、y に次数 3 の
%   多項式曲面を近似します。
%
%   備考:
%   有理数のワイブルモデル、および、すべてのカスタムな非線形モデルでは、
%   係数に対するデフォルトの初期値は、区間 (0,1) から一様にランダムな値が
%   選択されます。結果として、同じデータとモデルを使った複数の近似は、
%   異なる近似係数になる可能性があります。係数に対する初期値を FITOPTIONS 
%   構造体、または、StartPoint プロパティに対するベクトルを使って指定する
%   ことでこの可能性を回避することができます。
%
%   参考 CFLIBHELP, FITTYPE, FITOPTIONS.


%   Copyright 1999-2009 The MathWorks, Inc.
