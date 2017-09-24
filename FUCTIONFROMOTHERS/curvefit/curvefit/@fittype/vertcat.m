function c = vertcat(varargin)
%VERTCAT Vertical concatenation of FITTYPE objects (disallowed)

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.5 $  $Date: 2012/08/20 23:55:14 $

error(message('curvefit:fittype:vertcat:catNotAllowed', class( varargin{ 1 } )));