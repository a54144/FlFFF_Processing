function makeRecursive(listener)
%makeRecursive Set listener properties so that it allows recursion
%
%  makeRecursive(Listener) sets appropriate properties on Listener so that
%  it will allow recursion.  This function works with both normal and
%  legacy listeners.

%   Copyright 2012 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:54:33 $ 

if isa(listener, 'handle.listener')
    listener.RecursionLimit = 255;
else
    listener.Recursive = true;
end
