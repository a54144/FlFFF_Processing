function hPanel = createEtchedPanel(hParent)
%createEtchedPanel Create a uipanel with etched border
%
%   createEtchedPanel(hParent) creates a uipanel that is correctly set up
%   with the 'etchedin' border type and pixel units.

%   Copyright 2011-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:57:28 $

if graphicsversion(hParent, 'handlegraphics')
    % Width=1 borders are doubled for etched types
    bWidth = 1;
else
    % Borders are not doubled for etched types
    bWidth = 2;
end

hPanel = uipanel(...
    'Parent', hParent, ...
    'Units', 'pixels', ...
    'BorderType', 'etchedin', ...
    'BorderWidth', bWidth, ...
    'BackgroundColor', sftoolgui.util.backgroundColor() );
