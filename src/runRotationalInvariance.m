clc, clear all

syms a b c t

at = cos(t)^2 * a + 2*cos(t)*sin(t) * b + sin(t)^2 * c;
bt = -cos(t)*sin(t) * a + (cos(t)^2 - sin(t)^2) * b + cos(t)*sin(t) * c;
ct = sin(t)^2 * a - 2*cos(t)*sin(t) * b + cos(t)^2 * c;

simplify(at^2 + ct^2)
simplify(2 * bt*bt)
simplify(at^2 + ct^2 + 2 * bt^2)

% simplify(-at-ct)
% simplify(4*(bt^2))
% simplify((at-ct)^2)

% theta(t) = atan(b/a) - t;
% thetaHat(t) = atan((-sin(t)*a + cos(t)*b)/(cos(t)*a + sin(t)*b));
% diff(t) = thetaHat(t) - theta(t);
% simplify(mod(diff,pi))
% 
% a=rand,b=rand,t=rand*2*pi
% t + angle(-(cos(t)*i + sin(t))*(a*i - b)) - atan2(b, a)