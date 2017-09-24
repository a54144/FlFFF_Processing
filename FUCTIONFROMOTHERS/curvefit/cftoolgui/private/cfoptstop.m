function cfoptstop(state)
%CFOPTSTOP Stop fitting iterations for Curve Fitting GUI.

%   Copyright 2001-2009 The MathWorks, Inc.
%   $Revision: 1.3.2.3 $  $Date: 2012/08/20 23:53:26 $

cfInterrupt( 'set', state );
