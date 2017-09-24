function aLine = lineOfPoints( parent, tag, markerStyle )
% lineOfPoints   A line of (unconnected) points.
%   A line of unconnected points is a line with LineStyle = 'none'.
%
%   sftoolgui.util.lineOfPoints( parent, tag, markerStyle ) is a line that
%   displays points.
%
%       parent      - the axes to draw the line in
%       tag         - a tag for the line
%       markerStyle - one of 'inclusion', 'exclusion' or 'validation'

%   Copyright 2011-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $    $Date: 2012/08/20 23:57:39 $

% Create a line with LineStyle = 'none'.
aLine = line( ...
    'Parent', parent, ...
    'Tag', tag, ...
    'LineStyle', 'none', ...
    'XData', [], 'YData', [], 'ZData', [] );

% Set the marker style.
sftoolgui.util.MarkerStylist.style( aLine, markerStyle );

% Make the line "auto-legendable".
curvefit.gui.makeAutoLegendable( aLine );
end
