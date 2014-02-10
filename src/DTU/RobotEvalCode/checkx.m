function  [err, x,n] = checkx(x0)
%function  [err, x,n] = checkx(x0)
%
%CHECKX  Check vector
%
% Version 10.11.03
% This code is part of the toolbox “immoptibox” which was written by Hans Bruun Nielsen.
% Department of Mathematics and Mathematical Modelling, Technical University of Denmark.

err = 0;  sx = size(x0);   n = max(sx);
if  (min(sx) ~= 1) | ~isreal(x0) | any(isnan(x0(:))) | isinf(norm(x0(:))) 
  err = -1;   x = []; 
else
  x = x0(:); 
end