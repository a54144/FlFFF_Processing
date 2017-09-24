%SPTERMS  Spline の用語の説明
%
%   EXPL = SPTERMS(TERM) は、文字列 TERM で指定される用語の説明を含む文字列、
%   あるいは、文字列のセル配列を返しします。
%   以下の文字列の指定が可能です。
%    'B-form',  'basic interval'
%    'B-spline','breaks'
%    'cubic spline interpolation', 'endconditions'
%    'not-a-knot', 'clamped', 'second', 'periodic', 'variational', 'Lagrange'
%    'cubic smoothing spline', 'quintic smoothing spline'
%    'error'
%    'knots',  'end knots', 'interior knots'
%    'least squares'
%    'NURBS', 'rational spline', 'rBform', 'rpform'
%    'roughness measure'
%    'thin-plate spline', 'centers', 'stform', 'basis function'
%    'spline'
%    'spline interpolation', 'Schoenberg-Whitney conditions'
%    'order'
%    'ppform'
%    'sites_etc'
%    'weight in roughness measure'
%
%   用語の始めの部分の文字 (少なくとも 2 つ、しかし通常は 2 つで十分) だけ
%   与える必要があります。オプションの 2 番目の出力引数は完全な用語を提示します。
%
%   出力引数のない SPTERMS(TERM) は何も返しませんが、タイトル内のすべての
%   用語を理解できるような説明をメッセージボックスに表示します。


%   Copyright 1987-2010 The MathWorks, Inc.
