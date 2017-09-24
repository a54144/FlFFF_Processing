%DIFFERENTIATE  Fit result オブジェクトを微分
%
%   DERIV1 = DIFFERENTIATE(FITOBJ,X) は、X で指定した点でモデル FITOBJ を
%   微分し、結果を DERIV1 に返します。FITOBJ は、FIT または CFIT 関数で
%   作成される FIT オブジェクトです。X は、ベクトルです。DERIV1 は、X と
%   同じサイズのベクトルです。数学的に表現すると、次のようになります。
%   DERIV1 = D(FITOBJ)/D(X)
%
%   [DERIV1,DERIV2] = DIFFERENTIATE(FITOBJ, X) は、モデル FITOBJ の 1 階
%   微分 DERIV1 と 2 階微分 DERIV2 を返します。
%
%   参考 CFIT/INTEGRATE, FIT, CFIT.


%   Copyright 1999-2008 The MathWorks, Inc.
