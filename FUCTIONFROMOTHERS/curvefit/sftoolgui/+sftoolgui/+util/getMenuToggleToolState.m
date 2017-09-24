function newState = getMenuToggleToolState(obj)
%getMenuToggleToolState gets the new state of a uimenu or uitoggletool

% getMenuToggleToolState(OBJ) gets the state of OBJ which is expected to be
% either a uimenu or a uitoggletool.

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:32 $

if ishghandle(obj, 'uimenu')
    if strcmpi(get(obj, 'Checked'), 'on')
        newState = 'off';
    else
        newState = 'on';
    end
elseif ishghandle(obj, 'uitoggletool')
    newState = get(obj, 'State');
else
    error(message('curvefit:sftoolgui:getMenuToggleToolState:UnexpectedObjectType'));
end
end