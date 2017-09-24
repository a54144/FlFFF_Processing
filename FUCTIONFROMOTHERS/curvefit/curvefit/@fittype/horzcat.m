function c = horzcat(varargin)
%HORZCAT Horizontal concatenation of FITTYPE objects (disallowed)

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.5 $  $Date: 2012/08/20 23:55:09 $

error(message('curvefit:fittype:horzcat:catNotPermitted', class( varargin{ 1 } )));
