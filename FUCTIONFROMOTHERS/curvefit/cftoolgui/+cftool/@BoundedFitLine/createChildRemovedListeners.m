function createChildRemovedListeners(hObj, hAxes)
%createChildRemovedListeners

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:52:54 $ 

if ~isempty(hObj.ChildRemovedListener) && isequal(hObj.ChildRemovedListener.Source,hAxes.ChildContainer)
    return;
end
hObj.ChildRemovedListener = event.listener( hAxes.ChildContainer, 'ObjectChildRemoved', ...
    @(es,ed) hObj.MarkDirty('limits') );


end
