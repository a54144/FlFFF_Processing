function theException = exception( id, varargin )
%EXCEPTION Create an MException
%
%   theException = exception(id, varargin) creates an MException using ID
%   and optional VARARGIN message arguments
%
%   Examples:
%
%   theException = curvefit.exception('curvefit:sfit:invalidCall');
%
%   theException = curvefit.exception ...
%   ('curvefit:managecustom:NewEquationNameExists', 'myfit');

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:54:04 $

theMessage = message( id, varargin{:} );
theException = MException( id, getString( theMessage ) );
end