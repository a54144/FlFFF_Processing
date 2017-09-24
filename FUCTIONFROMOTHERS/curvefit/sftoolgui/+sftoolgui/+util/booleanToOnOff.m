function onOff = booleanToOnOff( tf )
% booleanToOnOff returns 'on' if tf is true and 'off' otherwise.

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:25 $ 
if tf
    onOff = 'on';
else
    onOff = 'off';
end
end