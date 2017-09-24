function postConstructorSetup(h)
%POSTCONSTRUCTORSETUP   Set property values after construction.
%
%   POSTCONSTRUCTORSETUP(OBJ)

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:55:00 $ 

h.LowessOptionsVersion = 1;
h.method = 'LowessFit';
h.Robust = 'off';
h.Span = 0.25;
end
