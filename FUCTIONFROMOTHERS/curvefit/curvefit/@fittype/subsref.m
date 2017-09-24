function FITTYPE_OUT_ = subsref(FITTYPE_OBJ_, FITTYPE_SUBS_)
%SUBSREF Evaluate FITTYPE object.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.5.2.5 $  $Date: 2012/08/20 23:55:13 $

if (FITTYPE_OBJ_.isEmpty)
    error(message('curvefit:fittype:subsref:fcnEmpty'));
end

switch FITTYPE_SUBS_.type
case '()'
    FITTYPE_INPUTS_ = FITTYPE_SUBS_.subs;
    FITTYPE_OUT_ = feval(FITTYPE_OBJ_,FITTYPE_INPUTS_{:});
otherwise % case '{}', case '.'
    error(message('curvefit:fittype:subsref:noFieldAccess'))
end


