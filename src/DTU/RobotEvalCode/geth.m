function  [h, mu] = geth(A,g,mu)
%function  [h, mu] = geth(A,g,mu)
%
% Solve  (Ah + mu*I)h = -g  with possible adjustment of  mu
%
% Version 10.11.03
% This code is part of the toolbox “immoptibox” which was written by Hans Bruun Nielsen.
% Department of Mathematics and Mathematical Modelling, Technical University of Denmark.
%
% Factorize with check of pos. def.
n = size(A,1);  chp = 1;
while  chp
  [R chp] = chol(A + mu*eye(n));
  if  chp == 0  % check for near singularity
    chp = rcond(R) < 1e-15;
  end
  if  chp,  mu = 10*mu; end
end

% Solve  (R'*R)h = -g
h = R \ (R' \ (-g));   