function varargout = getXYZDataExtents(hObj)
%getXYZDataExtents
%
%   hObj.getXYZDataExtents is a 3-by-2 matrix containing the maximum and minimum
%   values in the three dimensions.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:53:00 $ 


ax = ancestor(hObj,'axes');

[~,ydata,ci] = hObj.calcXYData( hObj.getXLimFromPeers() );
if ~isempty(ydata)
    if isempty(ci)
        ylims = [min(ydata(:)) max(ydata(:))];
    else
        ylims = [min(min(ydata(:)),min(ci(:))) max(max(ydata(:)),max(ci(:)))];
    end
else
    ylims = ax.DataSpace.YLim;
end

varargout{1} = [
    NaN NaN; ...
    ylims;...
    0 0];
end
