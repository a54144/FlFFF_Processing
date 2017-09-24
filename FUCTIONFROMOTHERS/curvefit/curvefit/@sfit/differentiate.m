function [fx, fy, fxx, fxy, fyy] = differentiate( fo, x, y )
%DIFFERENTIATE  Differentiate a surface fit object.
%   [FX, FY] = DIFFERENTIATE(FO, X, Y) differentiates the surface FO at the
%   points specified by X and Y and returns the result in FX and FY.
%
%   FO is a surface fit (SFIT) object generated by the FIT function.
%   X and Y must be double precision arrays and the same size and shape.
%   All return arguments are the same size and shape as X and Y.
%
%   If FO represents the surface z = f(x, y), then FX contains the derivatives
%   with respect to x, i.e., df/dx, and FY contains the derivatives with respect
%   to y, i.e., df/dy.
%
%   [FX, FY] = DIFFERENTIATE(FO, [X, Y]), where X and Y are column vectors,
%   allows the evaluation points to be specified as a single argument.
%
%   [FX, FY, FXX, FXY, FYY] = DIFFERENTIATE(FO, ...) computes the first and
%   second derivatives of the surface fit object FO.
%
%   FXX contains the second derivatives with respect to x, i.e., d^2f/dx^2.
%   FXY contains the mixed second derivatives, i.e., d^2f/dxdy.
%   FYY contains the second derivatives with respect to y, i.e., d^2f/dy^2.
%
%   Examples
%   --------
%   You can use the DIFFERENTIATE method to compute the gradients of a fit and
%   then use the QUIVER function to plot these gradients as arrows. The
%   following example plots the gradients over the top of a contour plot.
%
%   x = [0.64;0.95;0.21;0.71;0.24;0.12;0.61;0.45;0.46;0.66;0.77;0.35;0.66];
%   y = [0.42;0.84;0.83;0.26;0.61;0.58;0.54;0.87;0.26;0.32;0.12;0.94;0.65];
%   z = [0.49;0.051;0.27;0.59;0.35;0.41;0.3;0.084;0.6;0.58;0.37;0.19;0.19];
%   fo = fit( [x, y], z, 'poly32', 'normalize', 'on' );
%   [xx, yy] = meshgrid( 0:0.04:1, 0:0.05:1 );
%
%   [fx, fy] = differentiate( fo, xx, yy );
%
%   plot( fo, 'Style', 'Contour' );
%   hold on
%   h = quiver( xx, yy, fx, fy, 'r', 'LineWidth', 2 );
%   hold off
%   colormap( copper )
%
%   See also: FIT, SFIT.

%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:55:21 $

% Parse input arguments
error( nargchk( 2, 3, nargin, 'struct' ) );
if nargin == 2
    if ndims( x ) ~= 2 || size( x, 2 ) ~= 2
        error(message('curvefit:sfit:differentiate:XNotTwoColumns'));
    end
    y = x(:,2);
    x = x(:,1);
elseif nargin == 3
    if ~isequal( size( x ), size( y ) );
        error(message('curvefit:sfit:differentiate:XYSizeMismatch'));
    end
end
if ~isa( x, 'double' ) || ~isa( y, 'double' )
        error(message('curvefit:sfit:differentiate:NonDouble'));
end
    
% Do we need to compute second derivatives?
doSecondDerivatives = (nargout >= 3);

% get derivative handle;
derivativeFcn = derivexpr( fo );

if isempty( derivativeFcn )
    % Need to compute the derivatives numerically.
    
    % First derivative wrt x
    mx = eps^(1/3)*max( 1, max( abs( x(~isinf( x )) ) ) );
    fxp = feval( fo, x+mx, y );
    fxm = feval( fo, x-mx, y );
    fx = (fxp-fxm)./(2*mx);
    
    % First derivative wrt y
    my = eps^(1/3)*max( 1, max( abs( y(~isinf( y )) ) ) );
    fyp = feval( fo, x, y+my );
    fym = feval( fo, x, y-my );
    fy = (fyp-fym)./(2*my);
    
    if doSecondDerivatives
        % Second derivative wrt x
        f0 = feval( fo, x, y );
        fxx = (fxp + fxm - 2*f0)./(mx*mx);
        
        % Second derivative wrt y
        fyy = (fyp + fym - 2*f0)./(my*my);
        
        % Mixed second derivative
        % Eqn 8.21 of Nocedal & Wright "Numerical Optimization", 2nd ed, Springer Series
        % in Operations Research, 2006.
        fxpyp = feval( fo, x+mx, y+my );
        fxmyp = feval( fo, x-mx, y+my );
        fxpym = feval( fo, x+mx, y-my );
        fxmym = feval( fo, x-mx, y-my );
        fxy = (fxpyp - fxmyp - fxpym + fxmym)/(4*mx*my);
    end
    
else % Use the derivative function to compute derivatives.
    % In this case we have to do the centering and scaling here
    x = (x - fo.meanx)/fo.stdx;
    y = (y - fo.meany)/fo.stdy;
    
    consts = constants( fo );
    if doSecondDerivatives
        [fx, fy, fxx, fxy, fyy] = derivativeFcn( fo.fCoeffValues{:}, fo.fProbValues{:}, consts{:}, x, y );
    else
        [fx, fy] = derivativeFcn( fo.fCoeffValues{:}, fo.fProbValues{:}, consts{:}, x, y );
    end
    
    % As we re-scaled x and y above, we need to adjust the derivatives here
    fx = fx/fo.stdx;
    fy = fy/fo.stdy;
    if doSecondDerivatives
        fxx = fxx/(fo.stdx.^2);
        fxy = fxy/(fo.stdx * fo.stdy);
        fyy = fyy/(fo.stdy.^2);
    end
end

