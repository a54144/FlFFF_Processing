function c = subsasgn(FITTYPE_OBJ_, varargin)
%SUBSASGN    subsasgn of fittype objects.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.5 $  $Date: 2012/08/20 23:55:12 $

error(message('curvefit:fittype:subsasgn:subsasgnNotAllowed', class( FITTYPE_OBJ_ )));