function c = backgroundColor()
% backgroundColor   The color of the background in CFTOOL

%   Copyright 2012 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:24 $

persistent theColor

if isempty( theColor )
    theColor = iGetColor();
end

c = theColor;

end

function theColor = iGetColor()
c = javax.swing.UIManager.getColor( 'control' );
rgb = [getRed( c ), getGreen( c ), getBlue( c )];
theColor = rgb/255;
end
