function [ ft, fopts, customEquation, errorStr] = createNewSurfaceFittype( fitTypeName, qualifier, args, startpoint, lower, upper, ind, dep )
% createNewSurfaceFittype creates a surface fittype and options.

%   Copyright 2010-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $    $Date: 2012/08/20 23:57:31 $ 
    
errorStr = '';
customEquation = '';

% First create the fittype
switch fitTypeName
    case 'Interpolant'
        ft = iTranslateInterpolantInputs(qualifier);
    case 'Polynomial'
        ft = iTranslatePolynomialInputs(qualifier);
    case 'Lowess'
        ft = iTranslateLowessInputs(qualifier);        
    otherwise
        % Should be a custom equation
        customEquation = fitTypeName;
        [ft, errorStr] = iTranslateCustomInputs( fitTypeName, ind, dep);
end

% Now get the options
fopts = sftoolgui.util.createFitOptions(ft, args, startpoint, lower, upper);
end

function [ft errorStr] = iTranslateCustomInputs( eqn, ind, dep )
[ft, errorStr] = cfswitchyard( 'nonlinearEquationFittype', eqn, ind, dep );
end

function ft = iTranslateInterpolantInputs( qualifier )
    % iTranslateInterpolantInputs translates surface griddata inputs.

switch qualifier
    case 'cubic'
        ft = fittype( 'cubicinterp', 'numindep', 2 );
    case 'nearest'
        ft = fittype( 'nearestinterp', 'numindep', 2  );
    case 'linear'
        ft = fittype( 'linearinterp', 'numindep', 2  );
    case 'v4'
        ft = fittype( 'biharmonicinterp', 'numindep', 2  );
    otherwise
        warning(message('curvefit:sftoolgui:util:createNewSurfaceFittype:TranslationError', qualifier));
        ft = fittype( 'linearinterp', 'numindep', 2  );
end
end

function ft = iTranslatePolynomialInputs(qualifier)
ft = fittype( sprintf( 'poly%s%s', qualifier(1), qualifier(2) ) );
end

function ft = iTranslateLowessInputs(qualifier)

switch qualifier
    case 'linear'
        ft = fittype( 'lowess' );
    case 'quadratic'
        ft = fittype( 'loess' );
    otherwise
        ft = fittype( 'lowess' );
        warning(message('curvefit:sftoolgui:util:createNewSurfaceFittype:unknownPolynomial', qualifier));
end       
end 



