% Curve Fitting Toolbox -- Spline Functions 
%
%
% GUI
%   splinetool - 複数のスプライン近似法 (GUI)
%   bspligui   - 節点の関数としての B-スプライン (GUI)
%
% スプラインの作成
%                         
%   csape    - 端条件をもつ 3 次スプライン補間
%   csapi    - 3 次スプライン補間
%   csaps    - 3 次平滑化スプライン
%   cscvn    - 'natural' または 'periodic' 3 次スプライン曲線
%   getcurve - 3 次スプライン曲線の対話的な作成
%   ppmak    - pp-型スプラインの統合
%
%   spap2    - 最小二乗スプライン近似
%   spapi    - スプライン補間
%   spaps    - 平滑化スプライン
%   spcrv    - 均等分割スプライン曲線
%   spmak    - B-型スプラインの統合
%
%   rpmak    - rp-型有理スプラインの統合
%   rscvn    - rB-型区分円弧曲線の補間
%   rsmak    - rB-型有理スプラインの統合
%
%   stmak    - st-型スプラインの統合
%   tpaps    - 薄板平滑化スプライン
%
% スプラインの操作 (B-型, pp-型, rB-型, st-型, ...の任意の型、
%                          1 変数または多変数)
%   fnbrk    - 型の名前と構成要素
%   fnchg    - 型の構成要素の変更
%   fncmb    - 関数の算術
%   fnder    - 関数の微分
%   fndir    - 関数の方向微分
%   fnint    - 関数の積分
%   fnjmp    - 関数の飛び、すなわち、f(x+) - f(x-) 
%   fnmin    - 与えられた区間での関数の最小値
%   fnplt    - 関数のプロット
%   fnrfn    - 追加点を型の区間に挿入
%   fntlr    - テイラー係数、あるいは、多項式
%   fnval    - 関数の評価
%   fnxtr    - 関数の外挿
%   fnzeros  - 与えられた区間での関数の零点
%   fn2fm    - 設定された型への変換
%
% 節点、ブレークポイント、サイトの手配
%   aptknt   - 適切な節点列
%   augknt   - 節点列の追加
%   aveknt   - 節点の平均
%   brk2knt  - 多重度をもつブレークポイントを節点に変換
%   chbpnt   - 適切なデータ位置、Chebyshev-Demko 点
%   knt2brk  - 節点列をブレークポイントと多重度に変換
%   knt2mlt  - 節点の多重度
%   newknt   - 新しいブレークポイントの分布
%   optknt   - 補間に対する "最適な" 節点の分布
%   sorted   - メッシュサイトに対するサイトの位置付け
%
% スプライン作成ツール
%   spcol    - B-スプライン選点行列
%   stcol    - 点在する変換選点行列
%   slvblk   - ほぼブロック対角な線形システムの解
%   bkbrk    - ほぼブロック対角な行列の一部
%
% スプライン変換ツール
%   splpp    - 局所的な B-係数から左のテイラー係数への変換
%   sprpp    - 局所的な B-係数から右のテイラー係数への変換
%
% 関数とデータ
%   franke   - Franke の 2 変数テスト関数
%   subplus  - 正部分
%   titanium - (チタンに関する) テストデータ
%
% スプラインとツールボックスの情報
%   bspline  - B-スプラインとその多項式の構成要素をプロット
%   spterms  - Spline の用語の説明

%   Copyright 1987-2013 The MathWorks, Inc.
%   Generated from Contents.m_template revision 1.1.6.4  $Date: 2012/08/20 23:59:29 $
